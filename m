Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935003AbaGXJxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:53:32 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:46455 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934547AbaGXJxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:53:25 -0400
MIME-Version: 1.0
In-Reply-To: <1405475714-10006-4-git-send-email-huayi.li@csr.com>
References: <1405475714-10006-1-git-send-email-huayi.li@csr.com> <1405475714-10006-4-git-send-email-huayi.li@csr.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 24 Jul 2014 17:53:05 +0800
Message-ID: <CAGsJ_4xy7c7+tN114YQyE3cQ4EOyJ5bdGPUwXvZjJqpd0qYG1w@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] ARM: dts: sirf: fix the pwm-cells and clocks
To: Huayi Li <huayi.li@csr.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rongjun Ying <rongjun.ying@csr.com>, Barry Song <barry.song@csr.com>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-16 9:55 GMT+08:00 Huayi Li <huayi.li@csr.com>:
> This patch adds missed pwm-cells, clock-names and signal source
> clock for PWM module.
>
> Signed-off-by: Huayi Li <huayi.li@csr.com>

Reviewed-by: Barry Song <Baohua.Song@csr.com>

> ---
>  arch/arm/boot/dts/atlas6.dtsi | 8 ++++++--
>  arch/arm/boot/dts/prima2.dtsi | 8 ++++++--
>  2 files changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/boot/dts/atlas6.dtsi b/arch/arm/boot/dts/atlas6.dtsi
> index bb22842..d424a69 100644
> --- a/arch/arm/boot/dts/atlas6.dtsi
> +++ b/arch/arm/boot/dts/atlas6.dtsi
> @@ -638,10 +638,14 @@
>                                  };
>                         };
>
> -                       pwm@b0130000 {
> +                       pwm: pwm@b0130000 {
>                                 compatible = "sirf,prima2-pwm";
> +                               #pwm-cells = <2>;
>                                 reg = <0xb0130000 0x10000>;
> -                               clocks = <&clks 21>;
> +                               clocks = <&clks 21>, <&clks 1>, <&clks 2>,
> +                                       <&clks 3>, <&clks 0>, <&clks 4>;
> +                               clock-names = "pwmc", "sigsrc0", "sigsrc1",
> +                                       "sigsrc2", "sigsrc3", "sigsrc4";
>                         };
>
>                         efusesys@b0140000 {
> diff --git a/arch/arm/boot/dts/prima2.dtsi b/arch/arm/boot/dts/prima2.dtsi
> index 963b7e5..68bb0c4 100644
> --- a/arch/arm/boot/dts/prima2.dtsi
> +++ b/arch/arm/boot/dts/prima2.dtsi
> @@ -646,10 +646,14 @@
>                                  };
>                         };
>
> -                       pwm@b0130000 {
> +                       pwm: pwm@b0130000 {
>                                 compatible = "sirf,prima2-pwm";
> +                               #pwm-cells = <2>;
>                                 reg = <0xb0130000 0x10000>;
> -                               clocks = <&clks 21>;
> +                               clocks = <&clks 21>, <&clks 1>, <&clks 2>,
> +                                       <&clks 3>, <&clks 0>, <&clks 4>;
> +                               clock-names = "pwmc", "sigsrc0", "sigsrc1",
> +                                       "sigsrc2", "sigsrc3", "sigsrc4";
>                         };
>
>                         efusesys@b0140000 {
> --
> 1.9.3
>

-barry
