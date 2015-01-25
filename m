Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbbAYVQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 16:16:15 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:38295 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbbAYVQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 16:16:13 -0500
Message-ID: <54C55D1A.9010706@linaro.org>
Date: Sun, 25 Jan 2015 22:16:10 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>
CC: tglx@linutronix.de, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH V2] clockevents: rockchip: Add rockchip timer for rk3288
References: <1422178979-12382-1-git-send-email-daniel.lezcano@linaro.org> <2285293.ZBcGIuxxDo@diego>
In-Reply-To: <2285293.ZBcGIuxxDo@diego>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2015 09:52 PM, Heiko Stübner wrote:
> Hi Daniel,
>
> one big request and some more style nitpicks :-)
>
> With the nitpicks fixed
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
>
>
> Before applying this patch could you drop the rk3288.dtsi change please?
> Instead I'd like to add the following patch separately to _my_ devicetree
> branch for 3.20.
>
> I already wasn't fast enough to prevent the ethernet controller changes
> going through the network tree and would like to prevent a third tree sending
> changes for the same dts area to Linus - merge conflicts and all.
>
>
> I don't think that neither the nitpicks nor dropping the dtsi segment need
> another submission though.

Hi Heiko,

I removed the dtsi change, fixed the spaces indentation and pushed in my 
tree the driver [1]

Thanks the review

   -- Daniel

[1] http://git.linaro.org/people/daniel.lezcano/linux.git clockevents/3.20


> ----- 8< -----------
> From: Daniel Lezcano <daniel.lezcano@linaro.org>
> Date: Sun, 25 Jan 2015 10:42:59 +0100
> Subject: [PATCH] ARM: dts: rockchip: Add rockchip timer node for rk3288
>
> The rk3288 board uses the architected timers and these ones are shutdown when
> the cpu is powered down. There is a need of a broadcast timer in this case to
> ensure proper wakeup when the cpus are in sleep mode and a timer expires.
>
> Add the timer node for the broadcast timer.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>   arch/arm/boot/dts/rk3288.dtsi | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index c7235fa..37847c1 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -149,6 +149,14 @@
>   		clock-frequency = <24000000>;
>   	};
>
> +	timer: timer@ff810000 {
> +		compatible = "rockchip,rk3288-timer";
> +		reg = <0xff810000 0x20>;
> +		interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&xin24m>, <&cru PCLK_TIMER>;
> +		clock-names = "timer", "pclk";
> +	};
> +
>   	display-subsystem {
>   		compatible = "rockchip,display-subsystem";
>   		ports = <&vopl_out>, <&vopb_out>;
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

