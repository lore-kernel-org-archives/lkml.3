Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbbASB1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 20:27:38 -0500
Received: from smtprelay0098.hostedemail.com ([216.40.44.98]:54152 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751191AbbASB1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 20:27:36 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3870:3871:3872:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12219:12438:12517:12519:12555:12740:13069:13311:13357:21080:21088,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mine30_7c621a9442d53
X-Filterd-Recvd-Size: 1714
Message-ID: <1421630853.29879.10.camel@perches.com>
Subject: Re: [PATCH] checkpatch: add check for the buggy while_each_thread()
From: Joe Perches <joe@perches.com>
To: Sergey Dyasly <dserrg@gmail.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Andy Whitcroft <apw@canonical.com>
Date: Sun, 18 Jan 2015 17:27:33 -0800
In-Reply-To: <1421591040-4892-1-git-send-email-dserrg@gmail.com>
References: <1421591040-4892-1-git-send-email-dserrg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2015-01-18 at 17:24 +0300, Sergey Dyasly wrote:
> Now it's preferable to use for_each_thread() instead of while_each_thread().
> Add a check to checkpatch.pl in order to prevent any new usages of the buggy
> while_each_thread() when possible.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -3255,6 +3255,12 @@ sub process {
>  			     "Prefer dev_$level(... to dev_printk(KERN_$orig, ...\n" . $herecurr);
>  		}
>  
> +# Check for the buggy while_each_thread()
> +		if ($line =~ /\bwhile_each_thread\(/) {

	\bwhile_each_thread\s*\(
or maybe
	\bwhile_each_thread\b

> +			WARN("WHILE_EACH_THREAD",
> +			     "Prefer to use for_each_thread() instead of the buggy while_each_thread(). See commit 0c740d0afc3bff0a097ad03a1c8df92757516f5c for details.\n" . $herecurr);

Pretty long commit id, 12 is probably enough.


