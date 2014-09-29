Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaI2Wia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:38:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:54444 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbaI2Wi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:38:29 -0400
Date: Tue, 30 Sep 2014 00:38:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
cc: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] clocksource: Add BE APIs support for clocksource
 counter reading.
In-Reply-To: <f22d0c6ab97f4f45ac66f646626b8c37@BN1PR0301MB0609.namprd03.prod.outlook.com>
Message-ID: <alpine.DEB.2.02.1409300027150.22082@ionos.tec.linutronix.de>
References: <1411712529-35293-1-git-send-email-Li.Xiubo@freescale.com> <alpine.DEB.2.11.1409261521340.4567@nanos> <f22d0c6ab97f4f45ac66f646626b8c37@BN1PR0301MB0609.namprd03.prod.outlook.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Sep 2014, Li.Xiubo@freescale.com wrote:
> > Subject: Re: [PATCH v2] clocksource: Add BE APIs support for clocksource
> > counter reading.
> > 
> > On Fri, 26 Sep 2014, Xiubo Li wrote:
> > > For now I just added  _be() support using ioread{16,32}be.
> > > And i have a check of the clocksource drivers, didn't find anyone
> > > using LE mode on one BE SoC, so _le() APIs is not needed.
> > 
> > Nonsense. The existing clocksource_mmio accessor function are
> > providing LE access independent of the CPU endianess. So we don't need
> > an _le() API simply because we have it already.
> > 
> > >  cycle_t clocksource_mmio_readl_up(struct clocksource *c)
> > >  {
> > > -	return (cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
> > > +	return (cycle_t)ioread32(to_mmio_clksrc(c)->reg);
> > 
> > And how exactly is this change related to adding BE support?
> > 
> 
> Actually not very much, since the _be() APIs are using ioread{16,32}be(),
> so I think using ioread{16,32}() will be less odd to having two different
> accessors here.
> 
> Wouldn't this be more unified somehow ?  

Changing existing code wants to be a separate patch with a proper
changelog and a proper argument WHY it needs to be changed in the
first place.

So please provide that separate patch first with a VERY REASONABLE
explanation in the changelog WHY the existing readl_relaxed() should
be replaced by ioread32().

Thanks,

	tglx
