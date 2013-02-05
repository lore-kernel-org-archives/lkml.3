Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab3BEKzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:55:32 -0500
Received: from www.linutronix.de ([62.245.132.108]:48504 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab3BEKzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:55:21 -0500
Date: Tue, 5 Feb 2013 11:55:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: Oleg Nesterov <oleg@redhat.com>, Tommi Rantala <tt.rantala@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: clock_nanosleep() task_struct leak
In-Reply-To: <20130205103455.GB18313@redhat.com>
Message-ID: <alpine.LFD.2.02.1302051155000.11905@ionos>
References: <CA+ydwtqUUAR9zf3dp+N1JRW+if88EZ73i+5BQtuggVPDFVdCBg@mail.gmail.com> <alpine.LFD.2.02.1302011450160.11905@ionos> <20130204193223.GA11910@redhat.com> <20130205103455.GB18313@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, Stanislaw Gruszka wrote:
> On Mon, Feb 04, 2013 at 08:32:23PM +0100, Oleg Nesterov wrote:
> > On 02/01, Thomas Gleixner wrote:
> > >
> > > B1;2601;0cOn Fri, 1 Feb 2013, Tommi Rantala wrote:
> > >
> > > > Hello,
> > > >
> > > > Trinity discovered a task_struct leak with clock_nanosleep(), reproducible with:
> > > >
> > > > -----8<-----8<-----8<-----
> > > > #include <time.h>
> > > >
> > > > static const struct timespec req;
> > > >
> > > > int main(void) {
> > > >         return clock_nanosleep(CLOCK_PROCESS_CPUTIME_ID,
> > > >                         TIMER_ABSTIME, &req, NULL);
> > > > }
> > > > -----8<-----8<-----8<-----
> > 
> > posix_cpu_timer_create()->get_task_struct() I guess...
> > 
> > Cough. I am not sure I ever understood this code, but now it certainly
> > looks as if I never saw it before.
> 
> Looks on do_cpu_nanosleep() we call posix_cpu_timer_create(), but we do
> not call posix_cpu_timer_del() at the end. Fix will not be super simple,
> since we need to care about error cases. I can cook a patch if nobody
> else want to do this.

Would be much appreciated!

Thanks,

	tglx
