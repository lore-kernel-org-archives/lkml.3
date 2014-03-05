Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbaCEPRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:17:49 -0500
Received: from smtprelay0177.hostedemail.com ([216.40.44.177]:36932 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755781AbaCEPRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 10:17:46 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3872:4321:5007:7652:7875:8660:9190:10004:10400:10466:10848:11026:11232:11473:11658:11914:12296:12517:12519:12740:13069:13148:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: match62_5fcd9307aca60
X-Filterd-Recvd-Size: 1944
Message-ID: <1394032656.3271.51.camel@joe-AO722>
Subject: Re: [PATCH 2/3] sched: Use clamp() and clamp_val() to make it more
 readable.
From: Joe Perches <joe@perches.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        peterz@infradead.org, mingo@redhat.com,
        Kees Cook <keescook@chromium.org>
Date: Wed, 05 Mar 2014 07:17:36 -0800
In-Reply-To: <0b02fa0f05c9cebca19cadce92cb8c85ee130ce0.1394022835.git.yangds.fnst@cn.fujitsu.com>
References: <8ae8a3aefb157e9e7d1b62a4c136289e74783eaf.1394022835.git.yangds.fnst@cn.fujitsu.com>
	 <0b02fa0f05c9cebca19cadce92cb8c85ee130ce0.1394022835.git.yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 20:36 +0800, Dongsheng Yang wrote:
> As Kees suggested, I use clamp() function to replace the if and
> else branch, making it more readable and modular.
> 
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
[]
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
[]
> @@ -3070,17 +3070,10 @@ SYSCALL_DEFINE1(nice, int, increment)
>  	 * We don't have to worry. Conceptually one call occurs first
>  	 * and we have a single winner.
>  	 */
> -	if (increment < -40)
> -		increment = -40;
> -	if (increment > 40)
> -		increment = 40;
> -
> +	increment = clamp(increment, -40, 40);

Maybe:

	increment = clamp(increment, -(NICE_MAX - NICE_MIN + 1), 
				   , NICE_MAX - NICE_MIN + 1)

or add yet another define like #define NICE_RANGE
or #define NICE_MAX_INCREMENT

