Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbaJNXbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 19:31:48 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34409 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755763AbaJNXbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 19:31:40 -0400
Date: Wed, 15 Oct 2014 00:31:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Drake <drake@endlessm.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3.17-rc4 v7 0/6] arm: Implement
 arch_trigger_all_cpu_backtrace
Message-ID: <20141014233126.GF27405@n2100.arm.linux.org.uk>
References: <1410970218-28847-1-git-send-email-daniel.thompson@linaro.org>
 <CAD8Lp44gPOBh_q1zDy3y1GkrRVAvix5YaNr-+E92+g8Q7fLKJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD8Lp44gPOBh_q1zDy3y1GkrRVAvix5YaNr-+E92+g8Q7fLKJA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 04:37:51PM -0600, Daniel Drake wrote:
> Hi,
> 
> Thanks a lot for working on this!
> 
> On Wed, Sep 17, 2014 at 10:10 AM, Daniel Thompson
> <daniel.thompson@linaro.org> wrote:
> > Changes *before* v1:
> >
> > * This patchset is a hugely cut-down successor to "[PATCH v11 00/19]
> >   arm: KGDB NMI/FIQ support". Thanks to Thomas Gleixner for suggesting
> >   the new structure. For historic details see:
> >         https://lkml.org/lkml/2014/9/2/227
> 
> What's the right way to extend your work in order to get a NMI-like
> watchdog hard lockup detector similar to the one on x86?
> 
> I'm testing your patches on Exynos4412 and I guess in their current
> state they don't go quite this deep, as the only callers of
> trigger_all_cpu_backtrace() are sysrq, hung_task and spinlock debug
> code - none of which seem as fail-safe as a trigger like a
> pre-programmed watchdog NMI interrupt would be.
> 
> Do I need to find a way to get CONFIG_FIQ available on this platform
> first? and/or CONFIG_HARDLOCKUP_DETECTOR?

The blocker on this work right now is the annoying Versatile Express
platform, which pretty much means that we currently can't push the
code into the GIC to support FIQs.  As long as adding FIQ support to
the GIC results in the Versatile Express becoming non-bootable, the
idea of using FIQs is a total non-starter.

Or we decide that we dump the platform completely (which will upset
a number of developers.)

I have patches I'm using for trigger_all_cpu_backtrace() which I'm
maintaining privately in my tree until we can get the FIQ situation
sorted.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
