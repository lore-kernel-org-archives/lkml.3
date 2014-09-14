Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaINGzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 02:55:04 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:30620 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752401AbaINGzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 02:55:02 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+IM6oWmLVfFL4LhnoX6nKxvr52xes/cbk=
X-DKIM: OpenDKIM Filter v2.0.1 titan 5A45E5E1569
Date: Sun, 14 Sep 2014 02:54:46 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Thomas Gleixner <tglx@linutronix.de>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/4] ARM: shmobile: r8a7740: Handle implicitly enabled
 clocks
Message-ID: <20140914065446.GO21986@titan.lakedaemon.net>
References: <1410527720-18061-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410527720-18061-1-git-send-email-geert+renesas@glider.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 03:15:16PM +0200, Geert Uytterhoeven wrote:
> 	Hi all,
> 
> This patch series fixes an issue with the INTCA module clock, which we
> currently assume enabled by the bootloader or reset state.
> If this clock was not enabled before booting Linux, the intc-irqpin driver
> and all devices connected to it (buttons, RTC on i2c-gpio) don't work.
> 
> To fix this, the clock is added to the system, and is managed in the driver
> through runtime PM, taking into account wake-up sources (gpio-keys, RTC alarm).
> 
> There's one remaining issue for armadillo-legacy, which has support for the LCD
> controller. Although the shmobile_lcd_fb driver doesn't use MERAM on r8a7740
> (unlike on sh7372), the MERAM (Media RAM) and ICB (MERAM Interconnect Buffer)
> clocks must be enabled to show a picture on the display. However, the MERAM
> doesn't have any device associated with it, so it's non-trivial to hook it up.
> 
> This patch series is based on renesas-devel-20140911-v3.17-rc4 and
> irqchip/for-next.
> 
> Geert Uytterhoeven (4):
>   irqchip: renesas-intc-irqpin: Add helper variable dev = &pdev->dev
>   irqchip: renesas-intc-irqpin: Add minimal runtime PM support
>   ARM: shmobile: r8a7740 legacy: Add missing INTCA clock for irqpin
>     module
>   ARM: shmobile: r8a7740 dtsi: Add missing INTCA clock for irqpin module
> 
>  arch/arm/boot/dts/r8a7740.dtsi            | 14 ++++--
>  arch/arm/mach-shmobile/clock-r8a7740.c    |  7 ++-
>  drivers/irqchip/irq-renesas-intc-irqpin.c | 83 +++++++++++++++++++++----------
>  include/dt-bindings/clock/r8a7740-clock.h |  1 +
>  4 files changed, 73 insertions(+), 32 deletions(-)

Patches 1 and 2 applied to irqchip/core

thx,

Jason.
