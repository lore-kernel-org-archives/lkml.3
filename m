Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaFUUCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:02:17 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22522 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaFUUCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:02:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/j3cPlvy1nFXZDooMWe+7ye1P5Bv9hn50=
X-DKIM: OpenDKIM Filter v2.0.1 titan 214E45957B1
Date: Sat, 21 Jun 2014 16:02:02 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: linux-kernel@vger.kernel.org, linux@openrisc.net, jonas@southpole.se,
        tglx@linutronix.de, geert@linux-m68k.org
Subject: Re: [PATCH v4] openrisc: irq: use irqchip framework
Message-ID: <20140621200202.GH21711@titan.lakedaemon.net>
References: <1401136302-27654-1-git-send-email-stefan.kristiansson@saunalahti.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401136302-27654-1-git-send-email-stefan.kristiansson@saunalahti.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan,

On Mon, May 26, 2014 at 11:31:42PM +0300, Stefan Kristiansson wrote:
> In addition to consolidating the or1k-pic with other interrupt
> controllers, this makes OpenRISC less tied to its on-cpu
> interrupt controller.
> 
> All or1k-pic specific parts are moved out of irq.c and into
> drivers/irqchip/irq-or1k-pic.c
> 
> In that transition, the funtionality have been divided into
> three chip variants.
> One that handles level triggered interrupts, one that handles edge
> triggered interrupts and one that handles the interrupt
> controller that is present in the or1200 OpenRISC cpu
> implementation.
> 
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> ---
> Changes in v2:
>  - Move or1k-pic related code into irq-or1k-pic
>  - Add documentation for device tree bindings
> 
> Changes in v3:
>  - Split level-, edge-triggered and or1200 implementation into seperate
>    chip variants.
> 
> Changes in v4:
>  - Fix typos in documentation
> ---
>  .../interrupt-controller/opencores,or1k-pic.txt    |  23 +++
>  arch/openrisc/Kconfig                              |   1 +
>  arch/openrisc/include/asm/irq.h                    |   3 +
>  arch/openrisc/kernel/irq.c                         | 146 ++---------------
>  drivers/irqchip/Kconfig                            |   4 +
>  drivers/irqchip/Makefile                           |   1 +
>  drivers/irqchip/irq-or1k-pic.c                     | 182 +++++++++++++++++++++
>  7 files changed, 227 insertions(+), 133 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/opencores,or1k-pic.txt
>  create mode 100644 drivers/irqchip/irq-or1k-pic.c

I've now applied this to irqchip/unstable with Jonas' Ack to get it some
time in -next.  As the name implies, I can rebase or edit this as
needed.

Since this crosses into arch/openrisc, you may have other changes
depending on it.  If so, just let me know and I'll create a stable topic
branch for you instead of merging it directly into irqchip/core.

thx,

Jason.
