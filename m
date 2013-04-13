Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab3DMP5j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 11:57:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab3DMP5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 11:57:38 -0400
Date: Sat, 13 Apr 2013 17:54:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
Subject: [PATCH 0/1] (Was: kernel: move exit_task_work() past exit_notify())
Message-ID: <20130413155457.GA6533@redhat.com>
References: <1365794853-23912-1-git-send-email-avagin@openvz.org> <20130413142246.GA864@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130413142246.GA864@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, Oleg Nesterov wrote:
>
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -795,7 +795,6 @@ void do_exit(long code)
> >  	exit_shm(tsk);
> >  	exit_files(tsk);
> >  	exit_fs(tsk);
> > -	exit_task_work(tsk);
> >  	check_stack_usage();
> >  	exit_thread();
> >
> > @@ -822,6 +821,7 @@ void do_exit(long code)
> >  	ptrace_put_breakpoints(tsk);
> >
> >  	exit_notify(tsk, group_dead);
> > +	exit_task_work(tsk);
>
> I am not comfortable with this change...
>
> The task is "really dead" after exit_notify(), even release_task(current)
> can be called.
>
> Let me think a bit... It seems that we have the alternative.

Andrey, Eric, how about this patch?

COMPLETELY UNTESTED and I need to recheck, but perhaps you can review?

Oleg.

