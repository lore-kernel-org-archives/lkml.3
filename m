Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3EMKgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:36:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:46976 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3EMKgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:36:02 -0400
Date: Mon, 13 May 2013 12:35:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: Steven Rostedt <rostedt@goodmis.org>, pjt@google.com,
        paul.mckenney@linaro.org, tj@kernel.org, mingo@redhat.com,
        peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH V2 Resend 4/4] timer: Migrate running timer
In-Reply-To: <CAKohpo=eAGVA540jN8+t0aaqCV9qJRkH0q9-q6QVUYusWQqSYw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1305131223470.2863@ionos>
References: <cover.1352196505.git.viresh.kumar@linaro.org> <d12b25130db5a8b645929eb93d1cf4ddc2d68826.1352196505.git.viresh.kumar@linaro.org> <1354024039.6276.72.camel@gandalf.local.home> <CAKohponv-AKZzM98Ujeek4oXQx+8ba+sMgMbM9eV8PgQR38kZw@mail.gmail.com>
 <CAKohpo=St0z0L9ei248s3KL_DqZtewQ50o7d=BTdwLFcpM+x3w@mail.gmail.com> <CAKohpo=0r=HY5w-XqnXv42eSJcH08C47J+TqWn7vY1aNBhGT_A@mail.gmail.com> <CAKohpo=eAGVA540jN8+t0aaqCV9qJRkH0q9-q6QVUYusWQqSYw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013, Viresh Kumar wrote:
> On 24 April 2013 16:52, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > On 9 April 2013 20:22, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >> [Steven replied to a personal Ping!!, including everybody again]
> >>
> >> On 9 April 2013 19:25, Steven Rostedt <rostedt@goodmis.org> wrote:
> >>> On Tue, 2013-04-09 at 14:05 +0530, Viresh Kumar wrote:
> >>>> Ping!!
> >>>>
> >>>
> >>> Remind me again. What problem are you trying to solve?
> >>
> >> I was trying to migrate a running timer which arms itself, so that we don't
> >> keep a cpu busy just for servicing this timer.

Which mechanism is migrating the timer away?

> >>>> On 20 March 2013 20:43, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >>>> >
> >>>> > Hi Steven/Thomas,
> >>>> >
> >>>> > I came back to this patch after completing some other stuff and posting
> >>>> > wq part of this patchset separately.
> >>>> >
> >>>> > I got your point and understand how this would fail.
> >>>> >
> >>>> > @Thomas: I need your opinion first. Do you like this concept of migrating
> >>>> > running timer or not? Or you see some basic problem with this concept?

I have no objections to the functionality per se, but the proposed
solution is not going to fly.

Aside of bloating the data structure you're changing the semantics of
__mod_timer(). No __mod_timer() caller can deal with -EBUSY. So you'd
break the world and some more.

Here is a list of questions:

      - Which mechanism migrates timers?

      - How is that mechanism triggered?

      - How does that deal with CPU bound timers?

Thanks,

	tglx



