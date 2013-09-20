Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab3ITMkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 08:40:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46472 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754612Ab3ITMkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 08:40:22 -0400
Date: Fri, 20 Sep 2013 13:39:56 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: "rob@landley.net" <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxime-ripard@free-electrons.com" <maxime-ripard@free-electrons.com>,
        "linux-sunxi@google-groups.com" <linux-sunxi@google-groups.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "oliver@schinagl.nl" <oliver@schinagl.nl>
Subject: Re: [PATCH] [PATCH] ARM: sunxi: doc: Add sun7i (A20) interrupt
 table
Message-ID: <20130920123956.GI17453@e106331-lin.cambridge.arm.com>
References: <1379675560-30656-1-git-send-email-oliver+list@schinagl.nl>
 <1379675560-30656-2-git-send-email-oliver+list@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379675560-30656-2-git-send-email-oliver+list@schinagl.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 12:12:40PM +0100, Oliver Schinagl wrote:
> From: Oliver Schinagl <oliver@schinagl.nl>
> 
> This patch adds some documentation about the Allwinner sun7i (A20) using
> the GIC.
> 
> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>

NAK.

This information is not a binding, and it's not a property of the
interrupt controller. It's the integration of a full SoC, which should
be described full in a dtsi where it can actually be used.

The only other SoCs that have this are other sunxi variants, and I see
no reason to have them here either.

Thanks,
Mark.

> ---
>  .../interrupt-controller/sunxi/sun7i-a20.txt       | 102 +++++++++++++++++++++
>  1 file changed, 102 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/sunxi/sun7i-a20.txt
> 
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/sunxi/sun7i-a20.txt b/Documentation/devicetree/bindings/interrupt-controller/sunxi/sun7i-a20.txt
> new file mode 100644
> index 0000000..e5e59df
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/interrupt-controller/sunxi/sun7i-a20.txt
> @@ -0,0 +1,102 @@
> +Allwinner A20 (sun7i) interrupt sources
> +---------------------------------------
> +The sun7i interrupt controller is actually a standard arm GIC one. For more
> +information see Documentation/devicetree/bindings/arm/gic.txt
> +
> +Interrupts are offset by 32, skipping the SGI and PPI's. The IRQ numbers here
> +is what is expected in the drivers device tree table.
> +
> +The interrupt sources available for the Allwinner A20 SoC are the
> +following ones:
> +
> +0: ENMI
> +1: UART0
> +2: UART1
> +3: UART2
> +4: UART3
> +5: IR0
> +6: IR1
> +7: I2C0
> +8: I2C1
> +9: I2C2
> +10: SPI0
> +11: SPI1
> +12: SPI2
> +13: SPDIF
> +14: AC97
> +15: TS
> +16: I2S0
> +17: UART4
> +18: UART5
> +19: UART6
> +20: UART7
> +21: KEYPAD
> +22: TIMER0
> +23: TIMER1
> +24: TIMER2
> +25: TIMER3
> +26: CAN
> +27: DMA
> +28: PIO
> +29: TOUCH_PANEL
> +30: AUDIO_CODEC
> +31: LRADC
> +32: MMC0
> +33: MMC1
> +34: MMC2
> +35: MMC3
> +36: MEMSTICK
> +37: NAND
> +38: USB0
> +39: USB1
> +40: USB2
> +41: SCR
> +42: CSI0
> +43: CSI1
> +44: LCDCTRL0
> +45: LCDCTRL1
> +46: MP
> +47: DEFEBE0
> +48: DEFEBE1
> +49: PMU
> +50: SPI3
> +51: TZASC
> +52: PATA
> +53: VE
> +54: SS
> +55: EMAC
> +56: SATA
> +57: GPS
> +58: HDMI
> +59: TVE
> +60: ACE
> +61: TVD
> +62: PS2_0
> +63: PS2_1
> +64: USB3
> +65: USB4
> +66: PLE_PFM
> +67: TIMER4
> +68: TIMER5
> +69: GPU_GP
> +70: GPU_GPMMU
> +71: GPU_PP0
> +72: GPU_PPMMU0
> +73: GPU_PMU
> +74: GPU_PP1
> +75: GPU_PPMMU1
> +76: GPU_RSV0
> +77: GPU_RSV1
> +78: GPU_RSV2
> +79: GPU_RSV3
> +80: GPU_RSV4
> +81: HS_TIMER0
> +82: HS_TIMER1
> +83: HS_TIMER2
> +84: HS_TIMER3
> +85: GMAC
> +86: HDMI1
> +87: I2S1
> +88: I2C3
> +89: I2C4
> +90: I2S2
> -- 
> 1.8.1.5
> 
> 
