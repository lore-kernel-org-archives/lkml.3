Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbaGCLcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 07:32:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55157 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbaGCLco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 07:32:44 -0400
Date: Thu, 3 Jul 2014 12:32:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [RESEND PATCH 5/5] devicetree: mfd: max14577: Add device tree
 bindings document
Message-ID: <20140703113236.GA28504@leverpostej>
References: <1404198121-22989-1-git-send-email-k.kozlowski@samsung.com>
 <1404198121-22989-6-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404198121-22989-6-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 01, 2014 at 08:02:00AM +0100, Krzysztof Kozlowski wrote:
> Add document describing device tree bindings for MAX14577 MFD
> drivers: MFD core, extcon, regulator and charger.
> 
> Both MAX14577 and MAX77836 chipsets are documented.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: devicetree@vger.kernel.org
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/max14577.txt | 152 +++++++++++++++++++++
>  1 file changed, 152 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/max14577.txt b/Documentation/devicetree/bindings/mfd/max14577.txt
> new file mode 100644
> index 000000000000..b235250a7b41
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/max14577.txt
> @@ -0,0 +1,152 @@
> +Maxim MAX14577/77836 Multi-Function Device
> +
> +MAX14577 is a Multi-Function Device with Micro-USB Interface Circuit, Li+
> +Battery Charger and SFOUT LDO output for powering USB devices. It is
> +interfaced to host controller using I2C.
> +
> +MAX77836 additionally contains PMIC (with two LDO regulators) and Fuel Gauge.
> +
> +
> +Required properties:
> +- compatible : Must be "maxim,max14577" or "maxim,max77836".
> +- reg : I2C slave address for the max14577 chip (0x25 for max14577/max77836)
> +- interrupts : IRQ line for the chip.
> +- interrupt-parent :  The parent interrupt controller.
> +
> +
> +Required nodes:
> + - charger :
> +	Node for configuring the charger driver.
> +	Required properties:
> +		- compatible : "maxim,max14577-charger"
> +			or "maxim,max77836-charger"
> +		- maxim,fast-charge-timer : Timer in hours to trigger the
> +			INT3/MBCCHGERR interrupt; Valid values:
> +			- 5, 6 or 7 (hours),
> +			- 0 to disable.

I'm not sure I follow what this is any why it should be in the DT.

Could you explain what this is used for?

Thanks,
Mark.
