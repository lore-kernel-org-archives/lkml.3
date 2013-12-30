Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab3L3RHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 12:07:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051Ab3L3RHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 12:07:15 -0500
Date: Mon, 30 Dec 2013 18:07:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/5] audit: convert PPIDs to the inital PID namespace.
Message-ID: <20131230170738.GB2457@redhat.com>
References: <cover.1387834776.git.rgb@redhat.com> <b607363a286c315801a0027401a2df9017a5c419.1387834776.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b607363a286c315801a0027401a2df9017a5c419.1387834776.git.rgb@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23, Richard Guy Briggs wrote:
>
> @@ -1839,10 +1839,10 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
>  	spin_unlock_irq(&tsk->sighand->siglock);
>  
>  	audit_log_format(ab,
> -			 " ppid=%ld pid=%d auid=%u uid=%u gid=%u"
> +			 " ppid=%d pid=%d auid=%u uid=%u gid=%u"
>  			 " euid=%u suid=%u fsuid=%u"
>  			 " egid=%u sgid=%u fsgid=%u tty=%s ses=%u",
> -			 sys_getppid(),
> +			 task_ppid_nr(tsk),

Hmm. But sys_getppid() returns tgid, not pid.

This probably means that 1/5 should use task_tgid_nr_*() ?

Note that ->real_parent is not necessarily the group leader.

> @@ -459,7 +459,7 @@ static int audit_filter_rules(struct task_struct *tsk,
>  		case AUDIT_PPID:
>  			if (ctx) {
>  				if (!ctx->ppid)
> -					ctx->ppid = sys_getppid();
> +					ctx->ppid = task_ppid_nr(tsk);

The same.

Oleg.

