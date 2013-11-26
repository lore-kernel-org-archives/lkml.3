Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab3KZSDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:03:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab3KZSDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:03:11 -0500
Date: Tue, 26 Nov 2013 19:04:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: zhang.yi20@zte.com.cn
Cc: htejun@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
	userspace child
Message-ID: <20131126180420.GA18172@redhat.com>
References: <OFC3933D9B.5510E97E-ON48257C23.0007B7CD-48257C23.000A4246@zte.com.cn> <20131114052326.GA29031@mtj.dyndns.org> <20131114114039.GA29277@redhat.com> <20131114115551.GA30824@redhat.com> <20131114115618.GB30824@redhat.com> <CAOS58YO_pZzBB+T6FEzNqfZv4_UUQ_QF1n1zxy4u+H_KhW-vJQ@mail.gmail.com> <OF36E72FA9.51146BE3-ON48257C2E.0008BC6D-48257C2E.0008FF9C@zte.com.cn> <20131125121416.GB23829@redhat.com> <OF4CF076F6.04AFF122-ON48257C2F.0009B6E4-48257C2F.000BF905@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF4CF076F6.04AFF122-ON48257C2F.0009B6E4-48257C2F.000BF905@zte.com.cn>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, zhang.yi20@zte.com.cn wrote:
>
> Userspace process doesn't want the PF_NO_SETAFFINITY, but its parent may be
> a kernel worker thread which has PF_NO_SETAFFINITY set.

... and this worker thread can do kernel_thread() to create the child.

> Clearing this flag in usersapce child to enable its migrating capability.
>
>
> Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
>
> --- linux-3.12.old/fs/exec.c	2013-11-26 08:53:12.175811856 +0000
> +++ linux-3.12/fs/exec.c	2013-11-26 09:26:53.575999604 +0000
> @@ -1091,7 +1091,8 @@ int flush_old_exec(struct linux_binprm *
>
>  	set_fs(USER_DS);
>  	current->flags &=
> -		~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD | PF_NOFREEZE);
> +		~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD | PF_NOFREEZE
> +		| PF_NO_SETAFFINITY);

Thanks,

Acked-by: Oleg Nesterov <oleg@redhat.com>




Can't resist... perhaps

	current->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
			    PF_NOFREEZE | PF_NO_SETAFFINITY);

looks a bit better, but this is minor and I won't insist.

Oleg.

