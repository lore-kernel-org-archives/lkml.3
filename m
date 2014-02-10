Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaBJSzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:55:41 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:38249 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbaBJSzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:55:36 -0500
MIME-Version: 1.0
In-Reply-To: <1391700529-11816-2-git-send-email-iivanov@mm-sol.com>
References: <1391700529-11816-1-git-send-email-iivanov@mm-sol.com>
	<1391700529-11816-2-git-send-email-iivanov@mm-sol.com>
Date: Mon, 10 Feb 2014 10:55:34 -0800
Message-ID: <CAJAp7OhEE0rTv2KRjajU361wrMh0VqOwCH4u4vC3+F4KMcU0GQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: dts: MSM8974: Add pinctrl node
From: Bjorn Andersson <bjorn@kryo.se>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 7:28 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>
> Add the pin control node and pin definitions of SPI8.
>
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  arch/arm/boot/dts/qcom-msm8974.dtsi |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>
> diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
> index 9e5dadb..395603f 100644
> --- a/arch/arm/boot/dts/qcom-msm8974.dtsi
> +++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
> @@ -117,5 +117,34 @@
>                         clocks = <&gcc GCC_BLSP1_UART2_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK>;
>                         clock-names = "core", "iface";
>                 };
> +
> +               msmgpio: pinctrl@fd510000 {
> +                       compatible = "qcom,msm8974-pinctrl";
> +                       reg = <0xfd510000 0x4000>;
> +                       gpio-controller;
> +                       #gpio-cells = <2>;
> +                       interrupt-controller;
> +                       #interrupt-cells = <2>;
> +                       interrupts = <0 208 0>;
> +
> +                       spi8_default: spi8_default {
> +                               mosi {
> +                                       pins = "gpio45";
> +                                       function = "blsp_spi8";
> +                               };
> +                               miso {
> +                                       pins = "gpio46";
> +                                       function = "blsp_spi8";
> +                               };
> +                               cs {
> +                                       pins = "gpio47";
> +                                       function = "blsp_spi8";
> +                               };
> +                               clk {
> +                                       pins = "gpio48";
> +                                       function = "blsp_spi8";
> +                               };
> +                       };
> +               };
>         };
>  };

Nice, listing it like this makes it easy to add the electrical
properties when inheriting these nodes, closer to the product dts
files.

Reviewed-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
