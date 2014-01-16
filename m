Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaAPEqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:46:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43149 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaAPEqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:46:33 -0500
Date: Wed, 15 Jan 2014 22:46:22 -0600
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Christian Seiler <christian@iwakd.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        lkml <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Lxc development list <lxc-devel@lists.linuxcontainers.org>
Subject: Re: CLONE_PARENT after setns(CLONE_NEWPID)
Message-ID: <20140116044622.GA19821@sergelap>
References: <20131106180232.GA8980@ac100>
 <20131106193311.GA18720@redhat.com>
 <87vc05jgak.fsf@tw-ebiederman.twitter.com>
 <52D6F976.4090405@iwakd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D6F976.4090405@iwakd.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Christian Seiler (christian@iwakd.de):
> Eric W. Biederman writes:
> >So hmm.
> >
> >Because it can do no harm, and because it is a regression let's remove
> >the CLONE_PARENT check and send it stable.
> >
> >diff --git a/kernel/fork.c b/kernel/fork.c
> >index 086fe73..c447fbc 100644
> >--- a/kernel/fork.c
> >+++ b/kernel/fork.c
> >@@ -1174,7 +1174,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >          * do not allow it to share a thread group or signal handlers or
> >          * parent with the forking task.
> >          */
> >-       if (clone_flags & (CLONE_SIGHAND | CLONE_PARENT)) {
> >+       if (clone_flags & (CLONE_SIGHAND)) {
> >                 if ((clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) ||
> >                     (task_active_pid_ns(current) !=
> >                                 current->nsproxy->pid_ns_for_children))
> 
> Just a short question, what happened to this patch? As far as I can
> tell, 3.13rc8 doesn't include it, neither does the current 3.12.7. This
> means that lxc-attach currently still doesn't work on 3.12 and probably
> won't work on 3.13 either... (3.11 is fine, see the previous mails in
> this thread.)

So, hm.  I didn't realize it hadn't hit upstream, because it's in the
ubuntu kernel (unfortunately wrongly attributed).

However it is in linux-next since Nov 27.

-serge
