Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab3FLI0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:26:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:42140 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab3FLI0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:26:05 -0400
Date: Wed, 12 Jun 2013 10:25:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: David Miller <davem@davemloft.net>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: Fix locking vs. interrupts
In-Reply-To: <1371015544.8250.182.camel@pasglop>
Message-ID: <alpine.LFD.2.02.1306121023150.22970@ionos>
References: <1371015544.8250.182.camel@pasglop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013, Benjamin Herrenschmidt wrote:

> The OF code uses irqsafe locks everywhere except in a handful of functions
> for no obvious reasons. Since the conversion from the old rwlocks, this
> now triggers lockdep warnings when used at interrupt time. At least one
> driver (ibmvscsi) seems to be doing that from softirq context.
> 
> This converts the few non-irqsafe locks into irqsafe ones, making them
> consistent with the rest of the code.

Fun. https://lkml.org/lkml/2013/2/4/416 seems to have got lost 
 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: <stable@vger.kernel.org> [v3.9+]

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
> 
> Note: It's silly to access the device-tree at interrupt time in most cases,
> and we should probably fix ibmvscsi, but for the time being, let's fix the

Right.

> obvious bug. Thomas, this can probably still go into 3.10... If not, I've
> CCed stable.

Should go through Grant I think.

Thanks,

	tglx
