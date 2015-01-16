Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbbAPLUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:20:45 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44535 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753671AbbAPLUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:20:19 -0500
Date: Fri, 16 Jan 2015 11:20:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sylvain Rochet <sylvain.rochet@finsecur.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clockevents: don't suspend/resume if unused
Message-ID: <20150116112003.GF12302@n2100.arm.linux.org.uk>
References: <1421399151-26800-1-git-send-email-alexandre.belloni@free-electrons.com>
 <20150116092014.GA27945@gradator.net>
 <20150116111706.GE12302@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116111706.GE12302@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 11:17:06AM +0000, Russell King - ARM Linux wrote:
> On Fri, Jan 16, 2015 at 10:20:14AM +0100, Sylvain Rochet wrote:
> > Hello Alexandre,
> > 
> > 
> > On Fri, Jan 16, 2015 at 10:05:51AM +0100, Alexandre Belloni wrote:
> > > There is no point in calling suspend/resume for unused
> > > clockevents as they are already stopped and disabled.
> > > 
> > > Furthermore, it can take some time to wait for some IPs to stop counting.
> > > 
> > > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > > Reported-by: Sylvain Rochet <sylvain.rochet@finsecur.com>
> > 
> > Indeed, this is way better from what I did.
> > 
> > 
> > > +		if (dev->suspend && dev->mode != CLOCK_EVT_MODE_UNUSED)
> > 
> > I wonder if we should use > CLOCK_EVT_MODE_SHUTDOWN
> > (or CLOCK_EVT_MODE_UNUSED || CLOCK_EVT_MODE_SHUTDOWN) instead of 
> > !CLOCK_EVT_MODE_UNUSED.
> 
> Definitely - consider the effect of the original patch set on a clock
> source which is being used, has PM support, but does not have an
> ->enable callback.

Damn it, that comment should've been on the clocksource patches...

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
