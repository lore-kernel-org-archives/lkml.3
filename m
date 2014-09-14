Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaINFTQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 01:19:16 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:34014 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbaINFTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 01:19:14 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/bzp7bqSGtvo0ILqcaL4N5SCP7XxC3+A8=
X-DKIM: OpenDKIM Filter v2.0.1 titan 3AC565E113B
Date: Sun, 14 Sep 2014 01:18:58 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        bcousson@baylibre.com, linux@arm.linux.org.uk,
        khilman@deeprootsystems.com, tglx@linutronix.de,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/35] arm: omap: move intc to drivers/irqchip/
Message-ID: <20140914051858.GF21986@titan.lakedaemon.net>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 04:15:48PM -0500, Felipe Balbi wrote:
> Hi folks,
> 
> here's another rebase of the original series moving INTC
> to drivers.
> 
> There aren't many changes, only some fixes here and there
> because of recent changes to irq_domain and irqchip.
> 
> I have also added a patch to enable INTC address space
> protection so that only privileged modes can access
> INTC's address space.
> 
> Patches tested on top of v3.17-rc7 with a beagle bone black,
> the only plataform I have which still uses INTC.
> 
> Tony, if you can run your PM test cases on your side, I'd
> be really glad.
> 
> cheers
> 
> Felipe Balbi (35):
>   arm: omap: irq: make omap_irq_base global
>   arm: omap: irq: define INTC_ILR0 register
>   arm: omap: irq: start to remove irq_banks array
>   arm: omap: irq: add a global omap_nr_irqs variable
>   arm: omap: irq: remove rest of irq_banks usage
>   arm: omap: irq: remove unused macro
>   arm: omap: irq: switch over to intc_readl on omap_intc_handle_irq
>   arm: omap: irq: remove unnecessary base_addr argument
>   arm: omap: irq: rename omap3_intc_regs
>   arm: omap: irq: always define omap3 support
>   arm: omap: irq: reorganize code a little bit
>   arm: omap: irq: make intc_of_init static
>   arm: omap: irq: call set_handle_irq() from intc_of_init
>   arm: omap: irq: use IRQCHIP_DECLARE macro
>   arm: omap: irq: drop .handle_irq and .init_irq fields
>   arm: omap: irq: add specific compatibles for omap3 and am33xx devices
>   arm: omap: irq: use compatible flag to figure out number of IRQ lines
>   arm: boot: dts: am33xx/omap3: fix intc compatible flag
>   arm: omap: irq: drop ti,intc-size support
>   arm: boot: dts: omap2/3/am33xx: drop ti,intc-size
>   arm: omap: irq: move some more code around
>   arm: omap: irq: call set_handle_irq() from .init_irq
>   arm: omap: irq: drop omap3_intc_handle_irq()
>   arm: omap: irq: drop omap2_intc_handle_irq()
>   arm: omap: irq: remove unnecessary header
>   arm: omap: irq: remove nr_irqs argument
>   arm: omap: irq: introduce omap_nr_pending
>   arm: omap: irq: get rid of ifdef hack
>   arm: omap: intc: switch over to linear irq domain
>   irqchip: add irq-omap-intc.h header
>   arm: omap: irq: move irq.c to drivers/irqchip/
>   irq: intc: minor improvement to omap_irq_pending()
>   irq: intc: comment style cleanup
>   irq: intc: remove unnecesary of_address_to_resource() call
>   irq: intc: enable IP protection
> 
>  arch/arm/boot/dts/am33xx.dtsi              |   3 +-
>  arch/arm/boot/dts/omap2.dtsi               |   1 -
>  arch/arm/boot/dts/omap3.dtsi               |   3 +-
>  arch/arm/mach-omap2/Kconfig                |   1 +
>  arch/arm/mach-omap2/Makefile               |   3 +-
>  arch/arm/mach-omap2/board-3430sdp.c        |   2 +-
>  arch/arm/mach-omap2/board-am3517crane.c    |   2 +-
>  arch/arm/mach-omap2/board-am3517evm.c      |   2 +-
>  arch/arm/mach-omap2/board-cm-t35.c         |   3 +-
>  arch/arm/mach-omap2/board-cm-t3517.c       |   2 +-
>  arch/arm/mach-omap2/board-devkit8000.c     |   2 +-
>  arch/arm/mach-omap2/board-generic.c        |  14 -
>  arch/arm/mach-omap2/board-ldp.c            |   2 +-
>  arch/arm/mach-omap2/board-omap3beagle.c    |   2 +-
>  arch/arm/mach-omap2/board-omap3logic.c     |   3 +-
>  arch/arm/mach-omap2/board-omap3pandora.c   |   2 +-
>  arch/arm/mach-omap2/board-omap3stalker.c   |   2 +-
>  arch/arm/mach-omap2/board-omap3touchbook.c |   2 +-
>  arch/arm/mach-omap2/board-overo.c          |   2 +-
>  arch/arm/mach-omap2/board-rx51.c           |   2 +-
>  arch/arm/mach-omap2/board-ti8168evm.c      |   1 +
>  arch/arm/mach-omap2/common.h               |  22 --
>  arch/arm/mach-omap2/cpuidle34xx.c          |   1 +
>  arch/arm/mach-omap2/irq.c                  | 380 ---------------------------
>  arch/arm/mach-omap2/pm24xx.c               |   1 +
>  arch/arm/mach-omap2/pm34xx.c               |   1 +
>  drivers/irqchip/Kconfig                    |   5 +
>  drivers/irqchip/Makefile                   |   1 +
>  drivers/irqchip/irq-omap-intc.c            | 408 +++++++++++++++++++++++++++++
>  include/linux/irqchip/irq-omap-intc.h      |  32 +++
>  30 files changed, 468 insertions(+), 439 deletions(-)
>  delete mode 100644 arch/arm/mach-omap2/irq.c
>  create mode 100644 drivers/irqchip/irq-omap-intc.c
>  create mode 100644 include/linux/irqchip/irq-omap-intc.h

For patches 32-35, please fix the subject line to:

  irqchip: omap-intc: C...

With that changed, patches 30-35 are:

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
