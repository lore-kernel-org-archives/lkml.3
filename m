Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935299Ab3BTUbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:31:31 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:46269 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934126Ab3BTUba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:31:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Raphael S.Carvalho" <raphael.scarv@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
References: <1361390975-8831-1-git-send-email-raphael.scarv@gmail.com>
Date: Wed, 20 Feb 2013 12:31:19 -0800
In-Reply-To: <1361390975-8831-1-git-send-email-raphael.scarv@gmail.com>
	(Raphael S. Carvalho's message of "Wed, 20 Feb 2013 17:09:35 -0300")
Message-ID: <87hal6iv6w.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18nkI56gJoR34/AfaKxTKguIdsYsXXlHTw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Raphael S.Carvalho" <raphael.scarv@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/1] kernel/fork.c: Simplifying a snippet of code.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Raphael S.Carvalho" <raphael.scarv@gmail.com> writes:

> Just sending this patch in order to simplify the code.
> However, I'm not sure if the code was written in that way due to
> specific reasons.

That doesn't look any simpler to me, and I expect you have now biased
the branch in the wrong direction.

The CLONE_THREAD is not the common case.

Eric

> Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>
> ---
>  kernel/fork.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index c535f33..237204d 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1341,9 +1341,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	}
>  
>  	p->pid = pid_nr(pid);
> -	p->tgid = p->pid;
> -	if (clone_flags & CLONE_THREAD)
> -		p->tgid = current->tgid;
> +	p->tgid = (clone_flags & CLONE_THREAD) ? current->tgid : p->pid;
>  
>  	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
>  	/*
