Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab3D2R3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:29:25 -0400
Received: from oproxy13-pub.unifiedlayer.com ([69.89.16.30]:60798 "HELO
	oproxy13-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757381Ab3D2R3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:29:24 -0400
Message-ID: <1367256561.8833.9.camel@Wailaba2>
Subject: Re: [PATCH v2 1/3] process cputimer is moving faster than its
 corresponding clock
From: Olivier Langlois <olivier@trillion01.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 29 Apr 2013 13:29:21 -0400
In-Reply-To: <CAFTL4hwxW9dGZH0rWOAngpYd1DJMGHAF7002weA4stNv6n4t6Q@mail.gmail.com>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>
	 <1365763837.17140.52.camel@laptop> <1365782115.17140.68.camel@laptop>
	 <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>
	 <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>
	 <CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>
	 <1366951210.7911.28.camel@Wailaba2> <1366957639.7911.42.camel@Wailaba2>
	 <517AD0AE.1030404@gmail.com> <1367037606.7911.66.camel@Wailaba2>
	 <CAFTL4hwxW9dGZH0rWOAngpYd1DJMGHAF7002weA4stNv6n4t6Q@mail.gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 02:45 +0200, Frederic Weisbecker wrote:
> 2013/4/27 Olivier Langlois <olivier@trillion01.com>:
> >
> >
> > Forbids the cputimer to drift ahead of its process clock by
> > blocking its update when a tick occurs while a autoreaping task
> > is currently in do_exit() between the call to release_task() and
> > its final call to schedule().
> >
> > Any task stats update after having called release_task() will
> > be lost because they are added to the global process stats located
> > in the signal struct from release_task().
> >
> > Ideally, you should postpone the release_task() call after the
> > final context switch to get all the stats added but this is
> > more complex to achieve.
> >
> > In other words, this is slowing down the cputimer so it keep the same
> > pace than the process clock but in fact, what should be done is to
> > speed up the process clock by adding the missing stats to it.
> >
> > Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> 
> Thanks.
> 
> Could you please resend these three patches in a new mail thread to
> make reviews easier? Also it would be nice to propose a different
> subject for each individual patch. Each of which describing what the
> patch does in a few words.
> 
> Thanks.

Frederic, Ok. I will do it and keep the description brief. If someone
inquire more details, I will make them refer back to specific post
inside this thread to avoid unnecessary repetition.

Is this cool?




