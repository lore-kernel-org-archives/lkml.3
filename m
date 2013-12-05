Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab3LEJw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 04:52:27 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39344 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753196Ab3LEJwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 04:52:22 -0500
Date: Thu, 5 Dec 2013 09:52:18 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "subhashj@codeaurora.org" <subhashj@codeaurora.org>
Subject: Re: [PATCH v7 1/2] mmc: sdhci-msm: Initial SDHCI MSM driver
 documentation
Message-ID: <20131205095218.GH29200@e106331-lin.cambridge.arm.com>
References: <1383753405-23631-1-git-send-email-gdjakov@mm-sol.com>
 <1383753405-23631-2-git-send-email-gdjakov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383753405-23631-2-git-send-email-gdjakov@mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Apologies for the late reply.

On Wed, Nov 06, 2013 at 03:56:44PM +0000, Georgi Djakov wrote:
> This patch adds documentation for Qualcomm SDHCI MSM driver.
> It contains the differences between the core properties in mmc.txt
> and the properties used by the sdhci-msm driver.

Nit, but this is documentation of the binding, not the driver.

> 
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> ---
>  .../devicetree/bindings/mmc/sdhci-msm.txt          |   92 ++++++++++++++++++++
>  1 file changed, 92 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-msm.txt
> 
> diff --git a/Documentation/devicetree/bindings/mmc/sdhci-msm.txt b/Documentation/devicetree/bindings/mmc/sdhci-msm.txt
> new file mode 100644
> index 0000000..8f1a52d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/sdhci-msm.txt
> @@ -0,0 +1,92 @@
> +* Qualcomm SDHCI controller (sdhci-msm)
> +
> +This file documents differences between the core properties in mmc.txt
> +and the properties used by the sdhci-msm driver.
> +
> +Required properties:
> +- compatible: should contain "qcom,sdhci-msm"
> +- reg: should contain SDHC, SD Core register map

As this seems to depend on reg-names, it would be nice to write this in
terms of reg-names (as with clocks and clock-names).


> +- reg-names: indicates various resources passed to driver (via reg proptery) by name
> +	"reg-names" examples are "hc_mem" and "core_mem"

Either there are a fixed set of names you expect (and therefore these
aren't examples but rather a definition), or this property is useless.
Please either define the set of names or remove this property.

> +- interrupts: should contain SDHC interrupts
> +- interrupt-names: indicates interrupts passed to driver (via interrupts property) by name
> +	"interrupt-names" examples are "hc_irq" and "pwr_irq"

Likewise for both points.

> +- vdd-supply: phandle to the regulator for the vdd (flash core voltage) supply.
> +- vddio-supply: phandle to the regulator for the vdd-io (i/o voltage) supply.
> +- pinctrl-names: Should contain only one value - "default".
> +- pinctrl-0: Should specify pin control groups used for this controller.
> +- clocks: A list of phandle + clock-specifier pairs for the clocks listed in clock-names
> +- clock-names: Should contain the following:
> +	"iface" - Main peripheral bus clock (PCLK/HCLK - AHB Bus clock) (required)
> +	"core"	- SDC MMC clock (MCLK) (required)
> +	"bus"	- SDCC bus voter clock (optional)

This looks good :)

> +
> +Optional properties:
> +- qcom,bus-speed-mode: specifies the supported bus speed modes by host
> +	The supported bus speed modes are:
> +	"HS200_1p8v" - indicates that host can support HS200 at 1.8v
> +	"HS200_1p2v" - indicates that host can support HS200 at 1.2v
> +	"DDR_1p8v" - indicates that host can support DDR mode at 1.8v
> +	"DDR_1p2v" - indicates that host can support DDR mode at 1.2v

Is this a list of strings, or does the unit only support one of these?

This could be a set of boolean properties instead, is this likely to
expand in future?

> +
> +- qcom,{vdd,vdd-io}-lpm-sup - specifies whether the supply can be kept in low power mode.

Boolean? Please specify types on properties.

Can you elaborate on what this means? When can a supply not be kept in
low power mode?

> +- qcom,{vdd,vdd-io}-voltage-level - specifies voltage levels for the supply.
> +	Should be specified in pairs (min, max), units uV.
> +- qcom,{vdd,vdd-io}-current-level - specifies load levels for the supply in lpm
> +	or high power mode (hpm). Should be specified in pairs (lpm, hpm), units uA.

Can you not query these from the regulator framework?

If these are configuration, why are they necessary?

Thanks,
Mark.
