Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967868Ab3E3IIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 04:08:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40962 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967842Ab3E3II0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 04:08:26 -0400
Message-ID: <1369901305.22004.138.camel@joe-AO722>
Subject: Re: [PATCH 1/4] sys: remove unnecesscary parameter of set_one_prio
From: Joe Perches <joe@perches.com>
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Date: Thu, 30 May 2013 01:08:25 -0700
In-Reply-To: <1369900686-5936-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1369900686-5936-1-git-send-email-lig.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-30 at 15:58 +0800, liguang wrote:
[]
> diff --git a/kernel/sys.c b/kernel/sys.c
[]
> -static int set_one_prio(struct task_struct *p, int niceval, int error)
> +static int set_one_prio(struct task_struct *p, int niceval)

Umm, error is forwarded through do_each loops.

Are you sure you can do this without
changing any return code behaviors?

[]

> @@ -211,7 +209,7 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
>  			else
>  				pgrp = task_pgrp(current);
>  			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
> -				error = set_one_prio(p, niceval, error);
> +				error = set_one_prio(p, niceval);
>  			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
>  			break;
>  		case PRIO_USER:
> @@ -225,7 +223,7 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
>  
>  			do_each_thread(g, p) {
>  				if (uid_eq(task_uid(p), uid))
> -					error = set_one_prio(p, niceval, error);
> +					error = set_one_prio(p, niceval);
>  			} while_each_thread(g, p);
>  			if (!uid_eq(uid, cred->uid))
>  				free_uid(user);		/* For find_user() */



