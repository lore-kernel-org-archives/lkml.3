Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165Ab3HSStn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 14:49:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab3HSStm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 14:49:42 -0400
Date: Mon, 19 Aug 2013 20:43:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Brad Spengler <spender@grsecurity.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Walters <walters@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH? fix unshare(NEWPID) && vfork()
Message-ID: <20130819184355.GA25362@redhat.com>
References: <20130819172524.GA22268@redhat.com> <CALCETrW+dEwR38ERQhx25-aw1dhsCE6X+9BQZJhusO88aUxN1A@mail.gmail.com> <20130819183319.GA24846@redhat.com> <CALCETrWrpNszRGCRRMLgiOopcSdDShB3Mck6gRPco=dAZeX3pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWrpNszRGCRRMLgiOopcSdDShB3Mck6gRPco=dAZeX3pQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19, Andy Lutomirski wrote:
>
> On Mon, Aug 19, 2013 at 11:33 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > So do you think this change is fine or not (ignoring the fact it needs
> > cleanups) ?
>
> I think that removing the CLONE_VM check is fine (although there are
> some other ones that should probably be removed as well), but I'm not
> sure if that check needs replacing with something else.

OK, thanks... but I still can't understand.

The patch I sent is equivalent to the new one below. I just tried to
unify it with another check in do_fork().

Oleg.

--- x/kernel/fork.c
+++ x/kernel/fork.c
@@ -1176,7 +1176,7 @@ static struct task_struct *copy_process(
 	 * If the new process will be in a different pid namespace
 	 * don't allow the creation of threads.
 	 */
-	if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
+	if ((clone_flags & (CLONE_THREAD | CLONE_PARENT | CLONE_NEWPID)) &&
 	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
 		return ERR_PTR(-EINVAL);
 

