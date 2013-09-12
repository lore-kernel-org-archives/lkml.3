Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab3ILUab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:30:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:60974 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab3ILUa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:30:27 -0400
Date: Thu, 12 Sep 2013 22:30:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] tick: broadcast: Deny per-cpu clockevents from being
 broadcast sources
In-Reply-To: <1379004640-15117-2-git-send-email-soren.brinkmann@xilinx.com>
Message-ID: <alpine.DEB.2.02.1309122224420.4089@ionos.tec.linutronix.de>
References: <1379004640-15117-1-git-send-email-soren.brinkmann@xilinx.com> <1379004640-15117-2-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Soren Brinkmann wrote:
> From: Stephen Boyd <sboyd@codeaurora.org>
> 
> On most ARM systems the per-cpu clockevents are truly per-cpu in
> the sense that they can't be controlled on any other CPU besides
> the CPU that they interrupt. If one of these clockevents were to
> become a broadcast source we will run into a lot of trouble
> because the broadcast source is enabled on the first CPU to go
> into deep idle (if that CPU suffers from FEAT_C3_STOP) and that
> could be a different CPU than what the clockevent is interrupting
> (or even worse the CPU that the clockevent interrupts could be
> offline).
> 
> Theoretically it's possible to support per-cpu clockevents as the
> broadcast source but so far we haven't needed this and supporting
> it is rather complicated. Let's just deny the possibility for now
> until this becomes a reality (let's hope it never does!).

Well, we can't do it this way. There are globally accessible clock
event devices which deliver only to cpu0. So the mask check might be
causing failure here.

Just add a feature flag CLOCK_EVT_FEAT_PERCPU to the clock event
device and check for it.

Thanks,

	tglx

