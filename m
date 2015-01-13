Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbbAMKsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:48:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:43969 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbbAMKsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:48:07 -0500
Date: Tue, 13 Jan 2015 11:47:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        sylvain.rochet@finsecur.com
Subject: Re: [PATCH] clocksource: timer-atmel-pit: don't suspend/resume if
 unused
In-Reply-To: <54B3D88C.80702@linaro.org>
Message-ID: <alpine.DEB.2.11.1501131143250.17382@nanos>
References: <1418911523-28492-1-git-send-email-nicolas.ferre@atmel.com> <54B3D450.7050405@atmel.com> <54B3D88C.80702@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-703863616-1421146069=:17382"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-703863616-1421146069=:17382
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 12 Jan 2015, Daniel Lezcano wrote:

> On 01/12/2015 03:04 PM, Nicolas Ferre wrote:
> > Le 18/12/2014 15:05, Nicolas Ferre a écrit :
> > > From: Sylvain Rochet <sylvain.rochet@finsecur.com>
> > > 
> > > Waiting for PIT to stop counting takes a long time:
> > >    1/(Master clock/prescaler/PIVR)
> > > = 1/(133 MHz     /16       /2^20)
> > > = 126 ms
> > > 
> > > Up to 126 ms if master clock is set to 133 MHz, skipping suspend/resume
> > > of the unused PIT device reduce (suspend time + resume time) from ~140 ms
> > > to ~17 ms.
> > > 
> > > Signed-off-by: Sylvain Rochet <sylvain.rochet@finsecur.com>
> > > [nicolas.ferre@atmel.com: move to newer clocksource driver]
> > > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > > Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> > > ---
> > > Hi Sylvain,
> > > 
> > > I re-worked (and "Acked") your patch so it can be applied on the newer
> > > Mainline
> > > kernels. Beware, I changed the "subject line" as well. The PIT driver
> > > moved
> > > recently (3.18).
> > > 
> > > Daniel,
> > > Can you take this patch in your tree?
> > 
> > Hi Daniel,
> > 
> > Anything prevents this patch from being merged (aka ping ;-))?
> 
> [Cc'ed tglx].
> 
> Hi Nico,
> 
> thanks for the head up.
> 
> Nothing prevents it but I am wondering if this change shouldn't be in the
> generic framework (kernel/time/clocksource.c and kernel/time/clockevents.c),
> so all drivers will benefit this change ?

Indeed. There is no point in calling suspend/resume for unused
clockevents. They should be stopped and disabled already.

Now with clocksources this might be different. We have no explicit
state for this, but its trivial to add one at least for those
clocksources which have enable/disable callbacks. For the other ones
not so much.

Thanks,

	tglx


--8323329-703863616-1421146069=:17382--
