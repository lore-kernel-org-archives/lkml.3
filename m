Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab3JWNba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:31:30 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:41386 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164Ab3JWNb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:31:27 -0400
To: Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH] ARM: dts: Add max77686 RTC interrupt to cros5250-common
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Oct 2013 14:31:24 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>, <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>,
        Rahul Sharma <rahul.sharma@samsung.com>
Organization: ARM Ltd
In-Reply-To: <1382533861-12688-1-git-send-email-dianders@chromium.org>
References: <1382533861-12688-1-git-send-email-dianders@chromium.org>
Message-ID: <777cfa1b95066d03b19252ac1b6eac2d@www.loen.fr>
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: dianders@chromium.org, kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com, linux-kernel@vger.kernel.org, olof@lixom.net, linux-arm-kernel@lists.infradead.org, rahul.sharma@samsung.com
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-10-23 14:11, Doug Anderson wrote:
> Without the interrupt you'll get problems if you enable
> CONFIG_RTC_DRV_MAX77686.  Setup the interrupt properly in the device
> tree.

Awesome! Thanks for fixing this, Doug. My Chromebook is much happier 
now!

> Signed-off-by: Doug Anderson <dianders@chromium.org>

Tested-by: Marc Zyngier <marc.zyngier@arm.com>

         M.

> ---
>  arch/arm/boot/dts/cros5250-common.dtsi | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/arch/arm/boot/dts/cros5250-common.dtsi
> b/arch/arm/boot/dts/cros5250-common.dtsi
> index dc259e8b..9b186ac 100644
> --- a/arch/arm/boot/dts/cros5250-common.dtsi
> +++ b/arch/arm/boot/dts/cros5250-common.dtsi
> @@ -27,6 +27,13 @@
>  		i2c2_bus: i2c2-bus {
>  			samsung,pin-pud = <0>;
>  		};
> +
> +		max77686_irq: max77686-irq {
> +			samsung,pins = "gpx3-2";
> +			samsung,pin-function = <0>;
> +			samsung,pin-pud = <0>;
> +			samsung,pin-drv = <0>;
> +		};
>  	};
>
>  	i2c@12C60000 {
> @@ -35,6 +42,11 @@
>
>  		max77686@09 {
>  			compatible = "maxim,max77686";
> +			interrupt-parent = <&gpx3>;
> +			interrupts = <2 0>;
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&max77686_irq>;
> +			wakeup-source;
>  			reg = <0x09>;
>
>  			voltage-regulators {

-- 
Fast, cheap, reliable. Pick two.
