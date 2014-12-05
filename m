Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaLES10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:27:26 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33909 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaLES1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:27:24 -0500
Date: Fri, 5 Dec 2014 10:27:25 -0800
From: Olof Johansson <olof@lixom.net>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        dianders@chromium.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kever Yang <kever.yang@rock-chips.com>, eddie.cai@rock-chips.com
Subject: Re: [PATCH] ARM: dts: rk3288: add arm,cpu-registers-not-fw-configured
Message-ID: <20141205182725.GA11755@quad.lixom.net>
References: <1416941640-324-1-git-send-email-sonnyrao@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416941640-324-1-git-send-email-sonnyrao@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 10:54:00AM -0800, Sonny Rao wrote:
> This will enable use of physical arch timers on rk3288, where each
> core comes out of reset with a different virtual offset.  Using
> physical timers will help with SMP booting on coreboot and older
> u-boot and should also allow suspend-resume and cpu-hotplug to work on
> all firmwares.
> 
> Firmware which does initialize the cpu registers properly at boot and
> cpu-hotplug can remove this property from the device tree.
> 
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> ---
>  arch/arm/boot/dts/rk3288.dtsi | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 0f50d5d..c861f52 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -139,6 +139,7 @@
>  
>  	timer {
>  		compatible = "arm,armv7-timer";
> +		arm,cpu-registers-not-fw-configured;
>  		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>,
>  			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>,
>  			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>,

Applied, thanks.


-Olof
