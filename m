Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934230AbaGXRwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 13:52:40 -0400
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:57934 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932857AbaGXRwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 13:52:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:4321:5007:7652:7807:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: arm01_33dda04665951
X-Filterd-Recvd-Size: 1848
Message-ID: <1406224354.27221.53.camel@joe-AO725>
Subject: Re: [PATCH 1/3] staging: dgng: Fix Macros with complex values
 should be enclosed in parenthesis
From: Joe Perches <joe@perches.com>
To: Seunghun Lee <waydi1@gmail.com>
Cc: gregkh@linuxfoundation.org, lidza.louina@gmail.com, markh@compro.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 24 Jul 2014 10:52:34 -0700
In-Reply-To: <1406215613-9314-1-git-send-email-waydi1@gmail.com>
References: <1406215613-9314-1-git-send-email-waydi1@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 00:26 +0900, Seunghun Lee wrote:
> This patch fixes a checkpatch errors
> "Macros with complex values should be enclosed in parenthesis"
[]
> diff --git a/drivers/staging/dgnc/dgnc_driver.h b/drivers/staging/dgnc/dgnc_driver.h

> @@ -111,32 +111,32 @@
>  #endif
>  
>  #if defined TRC_TO_KMEM
> -#define PRINTF_TO_KMEM(args) dgnc_tracef args
> +#define PRINTF_TO_KMEM(args) do { dgnc_tracef args } while (0)

All this _TO_KMEM code is #if 0 in dgnc_trace.h

It'd be good to change the dgnc_tracef prototype to use
__printf(1, 2)

and this code in drivers/staging/dgnc/dgnc_driver.h:

#if defined TRC_TO_CONSOLE
#define PRINTF_TO_CONSOLE(args) { printk(DRVSTR": "); printk args; }
#else /* !defined TRACE_TO_CONSOLE */
#define PRINTF_TO_CONSOLE(args)
#endif

should really consolidate the printk to something like:

#define PRINTF_TO_CONSOLE(fmt, ...)			\
	printk(KERN_INFO DRVSTR ": " fmt, ##__VA_ARGS__)


