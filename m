Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab3BEKe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:34:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab3BEKeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:34:25 -0500
Date: Tue, 5 Feb 2013 11:34:56 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Tommi Rantala <tt.rantala@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: clock_nanosleep() task_struct leak
Message-ID: <20130205103455.GB18313@redhat.com>
References: <CA+ydwtqUUAR9zf3dp+N1JRW+if88EZ73i+5BQtuggVPDFVdCBg@mail.gmail.com>
 <alpine.LFD.2.02.1302011450160.11905@ionos>
 <20130204193223.GA11910@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204193223.GA11910@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 08:32:23PM +0100, Oleg Nesterov wrote:
> On 02/01, Thomas Gleixner wrote:
> >
> > B1;2601;0cOn Fri, 1 Feb 2013, Tommi Rantala wrote:
> >
> > > Hello,
> > >
> > > Trinity discovered a task_struct leak with clock_nanosleep(), reproducible with:
> > >
> > > -----8<-----8<-----8<-----
> > > #include <time.h>
> > >
> > > static const struct timespec req;
> > >
> > > int main(void) {
> > >         return clock_nanosleep(CLOCK_PROCESS_CPUTIME_ID,
> > >                         TIMER_ABSTIME, &req, NULL);
> > > }
> > > -----8<-----8<-----8<-----
> 
> posix_cpu_timer_create()->get_task_struct() I guess...
> 
> Cough. I am not sure I ever understood this code, but now it certainly
> looks as if I never saw it before.

Looks on do_cpu_nanosleep() we call posix_cpu_timer_create(), but we do
not call posix_cpu_timer_del() at the end. Fix will not be super simple,
since we need to care about error cases. I can cook a patch if nobody
else want to do this.

Stanislaw
