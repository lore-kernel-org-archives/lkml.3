Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3CRPZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:25:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38372 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab3CRPZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:25:32 -0400
Date: Mon, 18 Mar 2013 15:25:14 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: chpoph <chpoph@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: udelay function delays the wrong time interval in
	multiprocessor system, if ARCH_HAS_READ_CURRENT_TIMER is not
	defined and on current timer is used.
Message-ID: <20130318152514.GG4977@n2100.arm.linux.org.uk>
References: <CAM16m2=6S11d+eSSwQJ2f=nO6dM4K-dGKf3TR-z0nyBUyw=YxQ@mail.gmail.com> <20130315181449.GX4977@n2100.arm.linux.org.uk> <CAM16m2n_Of0MJNtUsrL0MS2cXBZUHg9RzjSHcboDiHKB3s0cdw@mail.gmail.com> <20130317200543.GA20174@mudshark.cambridge.arm.com> <20130317230812.GE4977@n2100.arm.linux.org.uk> <CAM16m2kHp46rgiivUt7EL1Dr06b4UobzT3aXgPZOpFJP-FkTSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM16m2kHp46rgiivUt7EL1Dr06b4UobzT3aXgPZOpFJP-FkTSA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 10:40:56PM +0800, chpoph wrote:
>  On Sun, Mar 17, 2013 at 08:05:43PM +0000, Will Deacon wrote:
> >Do you actually have an ARM platform that can scale the CPU frequencies
> independently?
> 
> Yes,  my smart phone use Qualcomm's 8x25 and 8064 platform, which can
> scale the CPU frequencies independently. I test the delay loop, the
> phone can't get accurate delayed time intervals.

That is expected.  udelay() is only approximate.  Sometimes, it will give
you a slightly shorter delay than asked for, or if preempted, it can give
you a much longer delay - because it has no idea how long it has been
preempted for.

This is why in a SMP system it is much better to use a timer-based udelay()
implementation which is more independent of these effects.
