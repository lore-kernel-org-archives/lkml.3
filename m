Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaFZWfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 18:35:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:45846 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaFZWfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 18:35:15 -0400
Date: Fri, 27 Jun 2014 00:35:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Austin Schuh <austin@peloton-tech.com>
cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
In-Reply-To: <CANGgnMYVoP-Z0Bv-VDEkJnvfa7Fi4-zY2F4A0PhMewGvwo3VVw@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1406270027300.5170@nanos>
References: <CANGgnMbHckBQdKGN_N5Q6qEKc9n1CenxvMpeXog1NbSdL8UrTw@mail.gmail.com> <CANGgnMYDXerOUDOO9-RHMJKadKACA2KBGskZwoP-1ZwAhDEfVA@mail.gmail.com> <CAFLxGvxfBt7OvW=a2Kz08GLHSEiiOZsN-vB19CXnQiwqFxqMsA@mail.gmail.com>
 <CANGgnMYVoP-Z0Bv-VDEkJnvfa7Fi4-zY2F4A0PhMewGvwo3VVw@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014, Austin Schuh wrote:
> On Wed, May 21, 2014 at 12:33 AM, Richard Weinberger
> <richard.weinberger@gmail.com> wrote:
> > CC'ing RT folks
> >
> > On Wed, May 21, 2014 at 8:23 AM, Austin Schuh <austin@peloton-tech.com> wrote:
> >> On Tue, May 13, 2014 at 7:29 PM, Austin Schuh <austin@peloton-tech.com> wrote:
> >>> Hi,
> >>>
> >>> I am observing a filesystem lockup with XFS on a CONFIG_PREEMPT_RT
> >>> patched kernel.  I have currently only triggered it using dpkg.  Dave
> >>> Chinner on the XFS mailing list suggested that it was a rt-kernel
> >>> workqueue issue as opposed to a XFS problem after looking at the
> >>> kernel messages.
> 
> I've got a 100% reproducible test case that doesn't involve a
> filesystem.  I wrote a module that triggers the bug when the device is
> written to, making it easy to enable tracing during the event and
> capture everything.
> 
> It looks like rw_semaphores don't trigger wq_worker_sleeping to run
> when work goes to sleep on a rw_semaphore.  This only happens with the
> RT patches, not with the mainline kernel.  I'm foreseeing a second
> deadlock/bug coming into play shortly.  If a task holding the work
> pool spinlock gets preempted, and we need to schedule more work from
> another worker thread which was just blocked by a mutex, we'll then
> end up trying to go to sleep on 2 locks at once.

I remember vaguely, that I've seen and analyzed that quite some time
ago. I can't page in all the gory details right now, but I have a look
how the related code changed in the last couple of years tomorrow
morning with an awake brain.

Steven, you did some analysis on that IIRC, or was that just related
to rw_locks?

Thanks,

	tglx




