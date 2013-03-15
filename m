Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3COSPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:15:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36447 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3COSPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:15:00 -0400
Date: Fri, 15 Mar 2013 18:14:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: chpoph <chpoph@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, will.deacon@arm.com
Subject: Re: udelay function delays the wrong time interval in
	multiprocessor system, if ARCH_HAS_READ_CURRENT_TIMER is not
	defined and on current timer is used.
Message-ID: <20130315181449.GX4977@n2100.arm.linux.org.uk>
References: <CAM16m2=6S11d+eSSwQJ2f=nO6dM4K-dGKf3TR-z0nyBUyw=YxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM16m2=6S11d+eSSwQJ2f=nO6dM4K-dGKf3TR-z0nyBUyw=YxQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 12:08:54AM +0800, chpoph wrote:
> If ARCH_HAS_READ_CURRENT_TIMER is not defined and on current timer is
> used for udelay, then __loop_delay and __loop_const_udelay is used to
> delay a specific time interval.  but in delay-loop.S, loops_per_jiffy
> (not per cpu data) is used to calculate the number of loops. in SMP
> system, udelay delays the wrong time interval if two cpus running at
> different frequency.

We don't support different CPUs running at different frequencies with
the delay loop.  Sorry.
