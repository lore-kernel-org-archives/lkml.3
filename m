Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaJISWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 14:22:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34204 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaJISWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 14:22:41 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v3] ARM: dts: Add initial DTS file for Sony Xperia Z1 phone
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <CA+bK7J5x60WyyAp6+hGDf-fyAC=skQu9EdPUabPrzhMCDnOCrA@mail.gmail.com>
Date: Thu, 9 Oct 2014 13:22:37 -0500
Cc: Tim Bird <tim.bird@sonymobile.com>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        Kevin Hilman <khilman@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6FB01741-5960-45CE-9AB8-20CBE5D9D212@codeaurora.org>
References: <542B338D.2040909@sonymobile.com> <CA+bK7J5x60WyyAp6+hGDf-fyAC=skQu9EdPUabPrzhMCDnOCrA@mail.gmail.com>
To: Tim Bird <tbird20d@gmail.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will not make the 3.18 merge window.  I will queue it up for 3.19.

- k

On Oct 9, 2014, at 11:55 AM, Tim Bird <tbird20d@gmail.com> wrote:

> Kumar,
> 
> Any chance this could make the 3.18 merge window?  Have you had time to take a look at it?
>  -- Tim
> 
> 
> On Tue, Sep 30, 2014 at 3:49 PM, Tim Bird <tim.bird@sonymobile.com> wrote:
> This DTS has support for the Sony Xperia Z1 phone (codenamed Honami).
> This first version of the DTS supports just a serial console.
> 
> changes from V2
>  - fixed dtb name in Makefile
> 
> changes from v1
>  - removed qcom,msm-id attribute
>  - removed mis-capitalized Qualcomm word
>  - changed dts file name
>  - added board-specific compatible-string
> 
> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
> Tested-by: Kevin Hilman <khilman@linaro.org>
> ---
> 
> This version fixes the dtb name.  I asked previously about adding to qcom_dt_match,
> but apparently board compatibles are being removed from that list in
> mach_qcom/board.c
> See https://lkml.org/lkml/2014/9/24/952
> 
> Kevin tested this (modulu re-adding back the qcom,msm-id).  I have a new
> mkqcdtbootimg which works without requiring the qcom,msm-id attribute,
> that I'll send to Kevin shortly (and publish on github).
> 
>  Documentation/devicetree/bindings/vendor-prefixes.txt |  1 +
>  arch/arm/boot/dts/Makefile                            |  3 ++-
>  arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts | 17 +++++++++++++++++
>  3 files changed, 20 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts
> 
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index ac7269f..d3a4579 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -128,6 +128,7 @@ sirf        SiRF Technology, Inc.
>  smsc   Standard Microsystems Corporation
>  snps   Synopsys, Inc.
>  solidrun       SolidRun
> +sony   Sony Corporation
>  spansion       Spansion Inc.
>  st     STMicroelectronics
>  ste    ST-Ericsson
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index b8c5cd3..cf58321 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -343,7 +343,8 @@ dtb-$(CONFIG_ARCH_QCOM) += \
>         qcom-apq8074-dragonboard.dtb \
>         qcom-apq8084-mtp.dtb \
>         qcom-msm8660-surf.dtb \
> -       qcom-msm8960-cdp.dtb
> +       qcom-msm8960-cdp.dtb \
> +       qcom-msm8974-sony-xperia-honami.dtb
>  dtb-$(CONFIG_ARCH_ROCKCHIP) += \
>         rk3066a-bqcurie2.dtb \
>         rk3188-radxarock.dtb \
> diff --git a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts
> new file mode 100644
> index 0000000..cccc21b
> --- /dev/null
> +++ b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts
> @@ -0,0 +1,17 @@
> +#include "qcom-msm8974.dtsi"
> +
> +/ {
> +       model = "Sony Xperia Z1";
> +       compatible = "sony,xperia-honami", "qcom,msm8974";
> +
> +       memory@0 {
> +               reg = <0 0x40000000>, <0x40000000 0x40000000>;
> +               device_type = "memory";
> +       };
> +};
> +
> +&soc {
> +       serial@f991e000 {
> +               status = "ok";
> +       };
> +};
> --
> 1.8.2.2
>  

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

