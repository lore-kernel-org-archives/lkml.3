Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbbASShv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:37:51 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:24094 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbbASSht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:37:49 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+r9tX3AYwN84l5WBWdW8vz
Date: Mon, 19 Jan 2015 10:34:09 -0800
From: Tony Lindgren <tony@atomide.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Felipe Balbi <balbi@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter =?utf-8?Q?K=C3=BCmmel?= <syntheticpp@gmx.net>,
        Pavel Machek <pavel@ucw.cz>, Santosh Shilimkar <ssantosh@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] irqchip: omap-intc: fix legacy DMA regression
Message-ID: <20150119183409.GZ18552@atomide.com>
References: <1420563093-26026-1-git-send-email-balbi@ti.com>
 <1420576688-10604-1-git-send-email-balbi@ti.com>
 <20150107030029.GE24989@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150107030029.GE24989@titan.lakedaemon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Cooper <jason@lakedaemon.net> [150106 19:03]:
> On Tue, Jan 06, 2015 at 02:38:08PM -0600, Felipe Balbi wrote:
> > commit 55601c9f2467 (arm: omap: intc: switch over
> > to linear irq domain) introduced a regression with
> > SDMA legacy driver because that driver strictly depends
> > on INTC's IRQs starting at NR_IRQs. Aparently
> > irq_domain_add_linear() won't guarantee that, since we see
> > a 7 IRQs difference when booting with and without the
> > commit cited above.
> > 
> > Until arch/arm/plat-omap/dma.c is properly fixed, we
> > must maintain OMAP2/3 using irq_domain_add_legacy().
> > 
> > A FIXME note was added so people know to delete that
> > code once that legacy DMA driver is fixed up.
> > 
> > Fixes: 55601c9f2467 (arm: omap: intc: switch over to linear irq domain)
> > Cc: <stable@vger.kernel.org> # v3.18
> > Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> > Tested-by: Tony Lindgren <tony@atomide.com>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  drivers/irqchip/irq-omap-intc.c | 26 +++++++++++++++++++++-----
> >  1 file changed, 21 insertions(+), 5 deletions(-)
> 
> Applied to irqchip/urgent.  Thanks for taking care of the Fixes and
> stable tags!

Jason, I'm not seeing this merged into v3.19-rc5, seems to be
in Linux next though.

Regards,

Tony
