Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbaIKVIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:08:09 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:44899 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750750AbaIKVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:08:07 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/pQ2gZYgX/6hte0XwGeVIZ
Date: Thu, 11 Sep 2014 14:08:01 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        bcousson@baylibre.com, linux@arm.linux.org.uk,
        khilman@deeprootsystems.com, tglx@linutronix.de, jason@lakedaemon.net,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 30/35] irqchip: add irq-omap-intc.h header
Message-ID: <20140911210800.GI18849@atomide.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
 <1406582183-696-31-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406582183-696-31-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [140728 14:19]:
> OMAP INTC irqchip driver will be moved under
> drivers/irqchip/ soon but we still have a dependency
> with mach-omap2 when it comes to idle functions.
> 
> In order to make it easy to share those function
> prototypes with OMAP PM code, we introduce this new
> header.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  arch/arm/mach-omap2/board-3430sdp.c        |  1 +
>  arch/arm/mach-omap2/board-am3517crane.c    |  1 +
>  arch/arm/mach-omap2/board-am3517evm.c      |  1 +
>  arch/arm/mach-omap2/board-cm-t35.c         |  1 +
>  arch/arm/mach-omap2/board-cm-t3517.c       |  1 +
>  arch/arm/mach-omap2/board-devkit8000.c     |  1 +
>  arch/arm/mach-omap2/board-ldp.c            |  1 +
>  arch/arm/mach-omap2/board-omap3beagle.c    |  1 +
>  arch/arm/mach-omap2/board-omap3logic.c     |  1 +
>  arch/arm/mach-omap2/board-omap3pandora.c   |  1 +
>  arch/arm/mach-omap2/board-omap3stalker.c   |  1 +
>  arch/arm/mach-omap2/board-omap3touchbook.c |  1 +
>  arch/arm/mach-omap2/board-overo.c          |  1 +
>  arch/arm/mach-omap2/board-rx51.c           |  1 +
>  arch/arm/mach-omap2/board-ti8168evm.c      |  1 +
>  arch/arm/mach-omap2/common.h               |  9 ---------
>  arch/arm/mach-omap2/cpuidle34xx.c          |  1 +
>  arch/arm/mach-omap2/irq.c                  |  1 +
>  arch/arm/mach-omap2/pm24xx.c               |  1 +
>  arch/arm/mach-omap2/pm34xx.c               |  1 +
>  include/linux/irqchip/irq-omap-intc.h      | 32 ++++++++++++++++++++++++++++++
>  21 files changed, 51 insertions(+), 9 deletions(-)

I ended up setting up another branch without this patch
at omap-for-v3.12/intc-v2. It now has dependency to the
SoC changes from Nishant and the const cleanup fix from Uwe.

This patch is not needed, let's leave this out, the functions
needed by the platform code won't need to be in a separate
header file as they are only needed by the platform code.

If you have a chance, can you please repost the remainging
patches to do the actual move to drivers, but without this
patch? And if we are lucky we'll get an ack from the
drivers/irqchip maintainers and I can apply those changes too
into omap-for-v3.12/intc-v2 ;)

Regards,

Tony
