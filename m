Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaI2WUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:20:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48975 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaI2WUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:20:47 -0400
Message-ID: <5429DB3D.5080701@codeaurora.org>
Date: Mon, 29 Sep 2014 15:20:45 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
CC: broonie@kernel.org, lee.jones@linaro.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@sonymobile.com
Subject: Re: [PATCH 4/4] ARM: DT: apq8064: Add SATA controller support.
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org> <1411982134-8090-1-git-send-email-srinivas.kandagatla@linaro.org>
In-Reply-To: <1411982134-8090-1-git-send-email-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/14 02:15, Srinivas Kandagatla wrote:
> @@ -396,6 +407,35 @@
>  			usb-phy		= <&usb4_phy>;
>  		};
>  
> +		sata_phy0:sata-phy@1b400000{

add some spaces here?

> +			compatible	= "qcom,apq8064-sata-phy";
> +			reg		= <0x1b400000 0x200>;
> +			reg-names	= "phy_mem";
> +			clocks		= <&gcc SATA_PHY_CFG_CLK>;
> +			clock-names = "cfg";
> +			#phy-cells = <0>;

These two lost the pretty tabs.

> +		};
> +
> +		sata0: sata@29000000 {
> +			compatible	= "generic-ahci";
> +			reg		= <0x29000000 0x180>;
> +			interrupts	= <0 209 0>;

Sorry I'm nitpicking but it annoys me. Either align it all or don't
align it.

> +			clocks = <&gcc SFAB_SATA_S_H_CLK>, <&gcc SATA_H_CLK>,
> +				 <&gcc SATA_A_CLK>, <&gcc SATA_RXOOB_CLK>,
> +				 <&gcc SATA_PMALIVE_CLK>;
> +
> +			clock-names = "slave_iface", "iface",
> +				      "bus", "rxoob",
> +				      "core_pmalive";
> +			assigned-clocks = <&gcc SATA_RXOOB_CLK>,
> +						<&gcc SATA_PMALIVE_CLK>;
> +			assigned-clock-rates = <100000000>, <100000000>;
> +
> +			phys  = <&sata_phy0>;
> +			phy-names = "sata-phy";
> +			target-supply = <&pm8921_s4>;
> +		};
> +
>  		/* Temporary fixed regulator */
>  		vsdcc_fixed: vsdcc-regulator {
>  			compatible = "regulator-fixed";


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

