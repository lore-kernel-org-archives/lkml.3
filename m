Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaIXOxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:53:16 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40970 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753772AbaIXOxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:53:13 -0400
Date: Wed, 24 Sep 2014 15:52:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Nathan Lynch <nathan_lynch@mentor.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Christopher Covington <cov@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Sonny Rao <sonnyrao@chromium.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] arm_arch_timer: VDSO preparation, code
	consolidation
Message-ID: <20140924145257.GY5182@n2100.arm.linux.org.uk>
References: <1411052390-27238-1-git-send-email-nathan_lynch@mentor.com> <20140922153919.GQ25809@arm.com> <20140922223022.GO5182@n2100.arm.linux.org.uk> <20140924144541.GJ15842@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924144541.GJ15842@e104818-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:45:41PM +0100, Catalin Marinas wrote:
> On Mon, Sep 22, 2014 at 11:30:23PM +0100, Russell King - ARM Linux wrote:
> > I raised a while back with Will whether there's much point to having
> > this on ARM.  While it's useful for virtualisation, the majority of
> > 32-bit ARM doesn't run virtualised.
> 
> This has nothing to do with virtualisation. The main reason we use
> CNTVCT is to not require kernel binary differences when running the OS
> as host or guest. But it does _not_ mean that it is only used when
> running as a guest.
> 
> > So there's little point in having the VDSO on the majority of
> > platforms - it will just add additional unnecessary cycles slowing
> > down the system calls that the VDSO is designed to try to speed up.
> 
> A good reason for VDSO is to avoid a system call for gettimeofday when
> you can read the clocks source from user space. That's a significant
> improvement on CPUs like A7, A15.

I'm *not* arguing against having a VDSO to speed up that crap.  What
I'm trying to get to the bottom of - something which has been totally
lost sight of - is what the friggin effect of this stuff is on CPUs
*without* the architected timer.

Until I get an answer to what the measured effect is, I'm saying no to
VDSO on ARM, because - as seems to be the norm - the evaluation job is
only half done.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
