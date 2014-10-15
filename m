Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaJOX0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 19:26:50 -0400
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:35861 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750966AbaJOX0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 19:26:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2689:2828:3138:3139:3140:3141:3142:3353:3622:3865:3868:3872:3873:4321:5007:6261:10004:10400:10848:11026:11658:11914:12296:12517:12519:12555:12740:13069:13311:13357:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: list95_58794ea31d60f
X-Filterd-Recvd-Size: 2220
Message-ID: <1413415606.7484.19.camel@perches.com>
Subject: Re: [PATCH] Change for codestyle and good read
From: Joe Perches <joe@perches.com>
To: Albino Biasutti Neto <bino@riseup.net>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 16:26:46 -0700
In-Reply-To: <1413414942-5338-1-git-send-email-bino@riseup.net>
References: <1413414942-5338-1-git-send-email-bino@riseup.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-15 at 20:15 -0300, Albino Biasutti Neto wrote:
> ---

Are you not mentioning the logic changes because you
didn't notice them?

> diff --git a/fs/open.c b/fs/open.c
[]
> @@ -71,10 +71,8 @@ long vfs_truncate(struct path *path, loff_t length)
>  	inode = path->dentry->d_inode;
>  
>  	/* For directories it's -EISDIR, for other non-regulars - -EINVAL */
> -	if (S_ISDIR(inode->i_mode))
> +	if ((S_ISDIR(inode->i_mode)) && (!S_ISRG(inode->i_mode)))
>  		return -EISDIR;
> -	if (!S_ISREG(inode->i_mode))
> -		return -EINVAL;

Don't think so...

Did you read the comment?

> @@ -137,14 +135,13 @@ retry:
>  	return error;
>  }
>  
> -SYSCALL_DEFINE2(truncate, const char __user *, path, long, length)
> -{
> +SYSCALL_DEFINE2(truncate, const char __user *, path, long, length) {
>  	return do_sys_truncate(path, length);
>  }

Poorer, non-kernel style

[]

diff --git a/kernel/exit.c b/kernel/exit.c
> index 32c58f7..f429fdd 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -78,8 +78,8 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
>  }
>  
>  /*
> - * This function expects the tasklist_lock write-locked.
> - */
> + * This function expects the tasklist_lock write-locked. 
> +*/
>  static void __exit_signal(struct task_struct *tsk)
>  {
>  	struct signal_struct *sig = tsk->signal;

Adding trailing whitespace and misaligning too.

