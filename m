Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab3HTSvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:51:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab3HTSvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:51:10 -0400
Date: Tue, 20 Aug 2013 20:45:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Walters <walters@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH? fix unshare(NEWPID) && vfork()
Message-ID: <20130820184521.GA23293@redhat.com>
References: <20130819172524.GA22268@redhat.com> <CALCETrW+dEwR38ERQhx25-aw1dhsCE6X+9BQZJhusO88aUxN1A@mail.gmail.com> <20130819183319.GA24846@redhat.com> <CALCETrWrpNszRGCRRMLgiOopcSdDShB3Mck6gRPco=dAZeX3pQ@mail.gmail.com> <20130819184355.GA25362@redhat.com> <87siy4z1pf.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87siy4z1pf.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > On 08/19, Andy Lutomirski wrote:
> >>
> >> On Mon, Aug 19, 2013 at 11:33 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> >
> >> > So do you think this change is fine or not (ignoring the fact it needs
> >> > cleanups) ?
> >>
> >> I think that removing the CLONE_VM check is fine (although there are
> >> some other ones that should probably be removed as well), but I'm not
> >> sure if that check needs replacing with something else.
> >
> > OK, thanks... but I still can't understand.
> >
> > The patch I sent is equivalent to the new one below. I just tried to
> > unify it with another check in do_fork().
>
> The patch below also needs CLONE_SIGHAND.  You can't meaningfully share
> signal handlers if you can't represent the pid in the siginfo.  pids and
> signals are too interconnected.

I don't really understand. If we allow to share ->mm (with this patch),
why it is bad to share sighand_struct->action[] ? This only shares the
pointers to the code which handles a signal.

However I agree it probably makes sense to deny it "just in case",
I do not think CLONE_SIGHAND can be useful in this case.

But then we should also deny CLONE_SIGHAND if CLONE_NEWUSER|CLONE_NEWPID
(another check in do_fork()). Which makes me think again we should unify
these 2 checks.

Oleg.

