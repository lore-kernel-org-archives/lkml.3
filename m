Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaLCSqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:46:07 -0500
Received: from smtprelay0248.hostedemail.com ([216.40.44.248]:41205 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751190AbaLCSqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:46:02 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3870:3872:4321:4605:5007:6261:6691:7903:7904:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13019:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: girls44_345453c83d11a
X-Filterd-Recvd-Size: 1602
Message-ID: <1417632358.2902.20.camel@perches.com>
Subject: Re: [PATCH] Staging: line6: fix parentheses around macro in
 usbdefs.h
From: Joe Perches <joe@perches.com>
To: Sam van Kampen <sam@tehsvk.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Bajumpaa <cbajumpa@gmail.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org
Date: Wed, 03 Dec 2014 10:45:58 -0800
In-Reply-To: <20141203183442.GA3480@nsa.gov>
References: <20141203183442.GA3480@nsa.gov>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 19:34 +0100, Sam van Kampen wrote:
> This patch fixes the error "Macros with complex values should be enclosed in
> parentheses", as reported by checkpatch.pl.
[]
> diff --git a/drivers/staging/line6/usbdefs.h b/drivers/staging/line6/usbdefs.h
[]
> @@ -40,7 +40,7 @@
>  #define LINE6_DEVID_TONEPORT_UX2  0x4142
>  #define LINE6_DEVID_VARIAX        0x534d
>  
> -#define LINE6_BIT(x) LINE6_BIT_ ## x = 1 << LINE6_INDEX_ ## x
> +#define LINE6_BIT(x) (LINE6_BIT_ ## x = 1 << LINE6_INDEX_ ## x)

The uses are pretty ugly.

It'd probably be nicer if all the LINE6_BIT uses were
direct enum declarations instead.



