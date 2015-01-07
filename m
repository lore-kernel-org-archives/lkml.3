Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbbAGDAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 22:00:49 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:42219 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbbAGDAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 22:00:46 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/+B6NucFBmoXB6epHSYacqjzwpIfZZQZE=
X-DKIM: OpenDKIM Filter v2.0.1 titan 593B963F106
Date: Tue, 6 Jan 2015 22:00:29 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Thomas Gleixner <tglx@linutronix.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter =?iso-8859-1?Q?K=FCmmel?= <syntheticpp@gmx.net>,
        Pavel Machek <pavel@ucw.cz>, Santosh Shilimkar <ssantosh@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] irqchip: omap-intc: fix legacy DMA regression
Message-ID: <20150107030029.GE24989@titan.lakedaemon.net>
References: <1420563093-26026-1-git-send-email-balbi@ti.com>
 <1420576688-10604-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420576688-10604-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 02:38:08PM -0600, Felipe Balbi wrote:
> commit 55601c9f2467 (arm: omap: intc: switch over
> to linear irq domain) introduced a regression with
> SDMA legacy driver because that driver strictly depends
> on INTC's IRQs starting at NR_IRQs. Aparently
> irq_domain_add_linear() won't guarantee that, since we see
> a 7 IRQs difference when booting with and without the
> commit cited above.
> 
> Until arch/arm/plat-omap/dma.c is properly fixed, we
> must maintain OMAP2/3 using irq_domain_add_legacy().
> 
> A FIXME note was added so people know to delete that
> code once that legacy DMA driver is fixed up.
> 
> Fixes: 55601c9f2467 (arm: omap: intc: switch over to linear irq domain)
> Cc: <stable@vger.kernel.org> # v3.18
> Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> Tested-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/irqchip/irq-omap-intc.c | 26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)

Applied to irqchip/urgent.  Thanks for taking care of the Fixes and
stable tags!

thx,

Jason.
