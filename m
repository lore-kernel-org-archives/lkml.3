Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763590Ab3ECWXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 18:23:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43917 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab3ECWXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 18:23:18 -0400
Date: Fri, 3 May 2013 23:23:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC patch 7/8] genirq: generic chip: Add linear irq domain
	support
Message-ID: <20130503222300.GF18614@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.02.1305031514230.2886@ionos> <20130503212258.385818955@linutronix.de> <20130503214629.810207749@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130503214629.810207749@linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 09:50:53PM -0000, Thomas Gleixner wrote:
> +	/* Init mask cache ? */
> +	if (dgc->gc_flags & IRQ_GC_INIT_MASK_CACHE) {
> +		raw_spin_lock_irqsave(&gc->lock, flags);
> +		gc->mask_cache = irq_reg_readl(gc->reg_base + ct->regs.mask);
> +		raw_spin_unlock_irqrestore(&gc->lock, flags);
> +	}

This looks a little weird to me - it seems that it'll re-read this
each time any irq is mapped in the domain, which is probably not
wanted.
