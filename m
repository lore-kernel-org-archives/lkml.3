Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbaEXGft (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 02:35:49 -0400
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:46176 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750736AbaEXGfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 02:35:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3871:3873:3874:4321:4362:5007:6119:6691:7652:10004:10400:10848:11026:11658:11914:12296:12517:12519:12740:13069:13071:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cast61_323ab8b69cc56
X-Filterd-Recvd-Size: 1647
Message-ID: <1400913343.10357.9.camel@joe-AO725>
Subject: Re: [PATCH 1/1] lib/bug.c: convert printk to pr_foo()
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        akpm <akpm@linux-foundation.org>
Date: Fri, 23 May 2014 23:35:43 -0700
In-Reply-To: <20140524081855.54cb27d56214c3ba3827ce7a@skynet.be>
References: <20140524081855.54cb27d56214c3ba3827ce7a@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-24 at 08:18 +0200, Fabian Frederick wrote:
> -Coalesce formats
> -"WARNING:" prefix unchanged to keep bug format.
> -printk(KERN_DEFAULT not converted.

Hello Fabian.

For these conversions where there is a specific
desire to _NOT_ have a prefix, can you please add
a new #define to the file?

#define pr_fmt(fmt) fmt

so that if ever the default in printk.h is changed,
these will not be prefixed.

> diff --git a/lib/bug.c b/lib/bug.c
[]
> @@ -153,15 +153,13 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
>  
>  	if (warning) {
>  		/* this is a WARN_ON rather than BUG/BUG_ON */
> -		printk(KERN_WARNING "------------[ cut here ]------------\n");
> +		pr_warn("------------[ cut here ]------------\n");

Thanks, Joe

