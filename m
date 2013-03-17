Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab3CQUGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 16:06:06 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47544 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756500Ab3CQUGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 16:06:01 -0400
Date: Sun, 17 Mar 2013 20:05:43 +0000
From: Will Deacon <will.deacon@arm.com>
To: chpoph <chpoph@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: udelay function delays the wrong time interval in multiprocessor
 system, if ARCH_HAS_READ_CURRENT_TIMER is not defined and on current timer
 is used.
Message-ID: <20130317200543.GA20174@mudshark.cambridge.arm.com>
References: <CAM16m2=6S11d+eSSwQJ2f=nO6dM4K-dGKf3TR-z0nyBUyw=YxQ@mail.gmail.com>
 <20130315181449.GX4977@n2100.arm.linux.org.uk>
 <CAM16m2n_Of0MJNtUsrL0MS2cXBZUHg9RzjSHcboDiHKB3s0cdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM16m2n_Of0MJNtUsrL0MS2cXBZUHg9RzjSHcboDiHKB3s0cdw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 03:32:43AM +0000, chpoph wrote:
> On Sat, Mar 16, 2013 at 2:14 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > We don't support different CPUs running at different frequencies with
> > the delay loop.  Sorry.
> 
> Does it means that a timer-based delay implementation must be used to
> get an accurate delay in SMP. I think it should print a warning
> message if the CPU delay loop is used in SMP.  In my system, the wrong
> delay interval fluctuated with CPU frequencies caused a control
> problem.

I've been playing around with loops_per_jiffy recently, in an attempt to
clean up the cpufreq scaling code so that the SMP-ness is in core code,
rather than being duplicated by every architecture:

  git://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git lpj

With those changes, it's pretty easy to get different delays depending on
the current CPU, but it would require preempt_{enable,disable} calls around
the delay, which I haven't convinced myself about.

Do you actually have an ARM platform that can scale the CPU frequencies
independently?

Will
