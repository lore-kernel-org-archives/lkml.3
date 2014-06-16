Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaFPHoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 03:44:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:55621 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaFPHow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 03:44:52 -0400
Date: Mon, 16 Jun 2014 09:43:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: Matthias Brugger <matthias.bgg@gmail.com>, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk, grant.likely@linaro.org,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        heiko.stuebner@bq.com, olof@lixom.net, sebastian.hesselbarth@gmail.com,
        sboyd@codeaurora.org, gregory.clement@free-electrons.com,
        arnd@arndb.de, robherring2@gmail.com, marc.zyngier@arm.com,
        maxime.ripard@free-electrons.com, soren.brinkmann@xilinx.com,
        shawn.guo@freescale.com, anders.berg@lsi.com, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 2/7] clocksource: Add support for the Mediatek SoCs
In-Reply-To: <539E116D.6030002@linaro.org>
Message-ID: <alpine.DEB.2.10.1406160943370.5170@nanos>
References: <1402490055-15197-1-git-send-email-matthias.bgg@gmail.com> <1402490055-15197-3-git-send-email-matthias.bgg@gmail.com> <alpine.DEB.2.10.1406112012460.5170@nanos> <539E116D.6030002@linaro.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jun 2014, Daniel Lezcano wrote:

> On 06/11/2014 08:14 PM, Thomas Gleixner wrote:
> > On Wed, 11 Jun 2014, Matthias Brugger wrote:
> > > +static void mtk_clkevt_mode(enum clock_event_mode mode,
> > > +				struct clock_event_device *clk)
> > > +{
> > > +	struct mtk_clock_event_device *evt = to_mtk_clk(clk);
> > > +
> > > +	mtk_clkevt_time_stop(evt, GPT_CLK_EVT);
> > > +
> > > +	switch (mode) {
> > > +	case CLOCK_EVT_MODE_PERIODIC:
> > > +		mtk_clkevt_time_setup(evt, evt->ticks_per_jiffy, GPT_CLK_EVT);
> > > +		mtk_clkevt_time_start(evt, true, GPT_CLK_EVT);
> > > +		break;
> > > +	case CLOCK_EVT_MODE_ONESHOT:
> > > +		mtk_clkevt_time_start(evt, false, GPT_CLK_EVT);
> > 
> > Why start the timer here? The code will call set next event right away.
> > 
> > > +		break;
> > > +	case CLOCK_EVT_MODE_UNUSED:
> > > +	case CLOCK_EVT_MODE_SHUTDOWN:
> > > +	default:
> > > +		/* No more interrupts will occur as source is disabled */
> > > +		break;
> > > +	}
> > > +}
> > 
> > Looks good otherwise.
> 
> Hi Thomas,
> 
> Can I consider the 8.1 patch (the one taking into account your comment) as
> acked-by ?

Yes
