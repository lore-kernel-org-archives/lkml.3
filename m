Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab3B0Iwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 03:52:34 -0500
Received: from linux-sh.org ([111.68.239.195]:35082 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297Ab3B0Iwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 03:52:33 -0500
Date: Wed, 27 Feb 2013 17:52:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        horms@verge.net.au, tglx@linutronix.de
Subject: Re: [PATCH] irqchip: Renesas INTC External IRQ pin driver
Message-ID: <20130227085216.GC30395@linux-sh.org>
References: <20130218142834.28739.39417.sendpatchset@w520>
 <20130227082335.GB30395@linux-sh.org>
 <CANqRtoSbiPhRbDsZppkJ+F48tEmuCdSfVRo3dTs9cEUxfvLopA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqRtoSbiPhRbDsZppkJ+F48tEmuCdSfVRo3dTs9cEUxfvLopA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 05:35:51PM +0900, Magnus Damm wrote:
> On Wed, Feb 27, 2013 at 5:23 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> > So how exactly does this interact with the existing sh_intc code? Or is
> > there some reason why you have opted to bypass it in order to implement a
> > simplified reduced-functionality version of INTC support focused only on
> > external pins? If both are used together this is going to be a nightmare
> > for locking, and it's also non-obvious how the IRQ domains on both sides
> > will interact.
> >
> > This needs a lot more explanation.
> 
> Recent GIC-based SoCs do not make use of INTC for any on-chip I/O
> devices. This driver is meant to be used as a layer between the actual
> IRQ pin and the GIC. Anything else needs the full driver. The existing
> non-DT INTC driver can happily coexist with this driver like it does
> in the case of sh73a0 here:
> 
> [PATCH 02/03] ARM: shmobile: INTC External IRQ pin driver on sh73a0
> 
Ok, thanks for clarifying.

I suppose the main concern is how quickly this will simply turn in to a
deviated partial implementation of the full driver as newer SoCs begin
deviating from your simplified case, and we basically end up
reimplementing sh_intc anyways.

> The driver is not meant to be used with INTC-only based systems like
> sh7372 and the SH architecture. I would be very happy if someone could
> get their shit together and fix up DT support for the common INTC
> code. This has not happened yet though. So if you know anyone with
> time to spare then feel free to suggest them to work together with
> Iwamatsu-san to get the DT version of the code reviewed together with
> Linaro.
> 
I haven't heard or seen anything new on that in some time, so I assumed
the work had stalled. I'm not sure why there wasn't more effort put in to
DT support for the INTC code rather than simply coming up with a
temporary bypass shim, and I'm not sure why you think this work is
blocked by anyone (unless you're just referring to a general lack of
resources).

In any event, I'm not sure what the best option for the interim is. I
suppose we can merge the irqchips until the INTC stuff catches up, but
then we are probaby going to run in to a situation where they either have
to co-exist, or the irqchips are removed and the sh_intc code has to
carry a compat shim to deal with those DT bindings. Neither of those
options seem particularly appealing to me.
