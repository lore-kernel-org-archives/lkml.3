Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab3LPRuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:50:08 -0500
Received: from smtprelay0013.hostedemail.com ([216.40.44.13]:33727 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754575Ab3LPRuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:50:05 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3865:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6117:7652:7903:9025:9388:10004:10400:10848:11026:11658:11914:12043:12292:12517:12519:12555:12740:13069:13311:13357:13437:13845,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: loss25_1d71fe331fe17
X-Filterd-Recvd-Size: 2145
Message-ID: <1387216201.18217.58.camel@joe-AO722>
Subject: Re: [PATCH v2 1/2] printk: Add a pr_warn_deprecated macro
From: Joe Perches <joe@perches.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-sctp@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 16 Dec 2013 09:50:01 -0800
In-Reply-To: <1387213605-27206-2-git-send-email-nhorman@tuxdriver.com>
References: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
	 <1387213605-27206-1-git-send-email-nhorman@tuxdriver.com>
	 <1387213605-27206-2-git-send-email-nhorman@tuxdriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Andrew Morton to cc's)

On Mon, 2013-12-16 at 12:06 -0500, Neil Horman wrote:
> sctp has several points in its setsockopt path in which it issues deprecation
> warnings.  It seems like it might be handy to macrotize such a warning so other
> subsystems can use it easily
[]
> diff --git a/include/linux/printk.h b/include/linux/printk.h
[]
> @@ -336,6 +336,9 @@ extern asmlinkage void dump_stack(void) __cold;
>  	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
>  /* no pr_cont_ratelimited, don't do that... */
>  
> +#define pr_warn_deprecated(fmt, ...)					\
> +	pr_warn_ratelimited("Deprecated: " fmt, ##__VA_ARGS__)

Continuing the thread from:
http://patchwork.ozlabs.org/patch/301738/

Making this a global kernel #define is different than
using it in your subsystem.

I think this is very analogous to the FW_INFO/FW_WARN
uses and maybe should just have a #define for the
string "deprecated:" inserted as a constant.

ie: just using

	pr_warn_once(DEPRECATED fmt, args...)
or
	pr_warn_ratelimited(DEPRECATED fmt, args...)


