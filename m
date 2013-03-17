Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab3CQXI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 19:08:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37318 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab3CQXI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 19:08:28 -0400
Date: Sun, 17 Mar 2013 23:08:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: chpoph <chpoph@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: udelay function delays the wrong time interval in
	multiprocessor system, if ARCH_HAS_READ_CURRENT_TIMER is not
	defined and on current timer is used.
Message-ID: <20130317230812.GE4977@n2100.arm.linux.org.uk>
References: <CAM16m2=6S11d+eSSwQJ2f=nO6dM4K-dGKf3TR-z0nyBUyw=YxQ@mail.gmail.com> <20130315181449.GX4977@n2100.arm.linux.org.uk> <CAM16m2n_Of0MJNtUsrL0MS2cXBZUHg9RzjSHcboDiHKB3s0cdw@mail.gmail.com> <20130317200543.GA20174@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130317200543.GA20174@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 08:05:43PM +0000, Will Deacon wrote:
> On Sat, Mar 16, 2013 at 03:32:43AM +0000, chpoph wrote:
> > On Sat, Mar 16, 2013 at 2:14 AM, Russell King - ARM Linux
> > <linux@arm.linux.org.uk> wrote:
> > > We don't support different CPUs running at different frequencies with
> > > the delay loop.  Sorry.
> > 
> > Does it means that a timer-based delay implementation must be used to
> > get an accurate delay in SMP. I think it should print a warning
> > message if the CPU delay loop is used in SMP.  In my system, the wrong
> > delay interval fluctuated with CPU frequencies caused a control
> > problem.
> 
> I've been playing around with loops_per_jiffy recently, in an attempt to
> clean up the cpufreq scaling code so that the SMP-ness is in core code,
> rather than being duplicated by every architecture:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git lpj
> 
> With those changes, it's pretty easy to get different delays depending on
> the current CPU, but it would require preempt_{enable,disable} calls around
> the delay, which I haven't convinced myself about.

Exactly, and that's why I said what I said.  If you start doing that,
then you might as well turn kernel preemption off altogether, because
the delays will impact your system latency.
