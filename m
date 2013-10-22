Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3JVQgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:36:12 -0400
Received: from smtprelay0173.hostedemail.com ([216.40.44.173]:39160 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754307Ab3JVQgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:36:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:334:355:368:369:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3874:4250:4321:5007:7576:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: deer79_6f7e50d1d9501
X-Filterd-Recvd-Size: 1961
Message-ID: <1382459764.2041.90.camel@joe-AO722>
Subject: Re: [PATCH 1/3] kbuild: Increase kallsyms max symbol length
From: Joe Perches <joe@perches.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Mario <jmario@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Tue, 22 Oct 2013 09:36:04 -0700
In-Reply-To: <1382456783-22826-2-git-send-email-andi@firstfloor.org>
References: <1382456783-22826-1-git-send-email-andi@firstfloor.org>
	 <1382456783-22826-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-22 at 08:46 -0700, Andi Kleen wrote:
> From: Joe Mario <jmario@redhat.com>
> 
> [AK: This seems like a ticking time bomb even without LTO,
> so should be merged now. It causes very weird problems.
> Thanks to Joe for tracking them down.]
> 
> With the added postfixes that LTO adds for local
> symbols, the longest name in the kernel overflows
> the namebuf[KSYM_NAME_LEN] array by two bytes.  That name is:
> __pci_fixup_resumePCI_VENDOR_ID_SERVERWORKSPCI_DEVICE_ID_SERVERWORKS_HT1000SBquirk_disable_broadcom_boot_interrupt.1488004.672802
> 
> Double the max symbol name length.
[]
> diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
> index 6883e19..711a50f 100644
> --- a/include/linux/kallsyms.h
> +++ b/include/linux/kallsyms.h
> @@ -9,7 +9,7 @@
>  #include <linux/kernel.h>
>  #include <linux/stddef.h>
>  
> -#define KSYM_NAME_LEN 128
> +#define KSYM_NAME_LEN 256

Doesn't doubling seems a tad excessive given the
silly length of that symbol above?


