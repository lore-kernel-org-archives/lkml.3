Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3K0NTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:19:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab3K0NS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:18:58 -0500
Date: Wed, 27 Nov 2013 14:20:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: zhang.yi20@zte.com.cn
Cc: htejun@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
	userspace child
Message-ID: <20131127132004.GA1168@redhat.com>
References: <20131114052326.GA29031@mtj.dyndns.org> <20131114114039.GA29277@redhat.com> <20131114115551.GA30824@redhat.com> <20131114115618.GB30824@redhat.com> <CAOS58YO_pZzBB+T6FEzNqfZv4_UUQ_QF1n1zxy4u+H_KhW-vJQ@mail.gmail.com> <OF36E72FA9.51146BE3-ON48257C2E.0008BC6D-48257C2E.0008FF9C@zte.com.cn> <20131125121416.GB23829@redhat.com> <OF4CF076F6.04AFF122-ON48257C2F.0009B6E4-48257C2F.000BF905@zte.com.cn> <20131126180420.GA18172@redhat.com> <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27, zhang.yi20@zte.com.cn wrote:
>
> Userspace process doesn't want the PF_NO_SETAFFINITY, but its parent may be
> a kernel worker thread which has PF_NO_SETAFFINITY set, and this worker thread
> can do kernel_thread() to create the child.
> Clearing this flag in usersapce child to enable its migrating capability.
>
>
> Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>

Thanks!

Acked-by: Oleg Nesterov <oleg@redhat.com>

> --- linux-3.12.old/fs/exec.c	2013-11-26 08:53:12.175811856 +0000
> +++ linux-3.12/fs/exec.c	2013-11-27 09:36:56.231972168 +0000
> @@ -1090,8 +1090,8 @@ int flush_old_exec(struct linux_binprm *
>  	bprm->mm = NULL;		/* We're using it now */
> 
>  	set_fs(USER_DS);
> -	current->flags &=
> -		~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD | PF_NOFREEZE);
> +	current->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
> +					PF_NOFREEZE | PF_NO_SETAFFINITY);
>  	flush_thread();
>  	current->personality &= ~bprm->per_clear;
> 
> 

