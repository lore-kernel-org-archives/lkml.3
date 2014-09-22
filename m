Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaIVKla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:41:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56916 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753858AbaIVKl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:41:28 -0400
Date: Mon, 22 Sep 2014 11:40:42 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Chris Zhong <zyw@rock-chips.com>
Cc: "dianders@chromium.org" <dianders@chromium.org>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "linux-rockchip@lists.infradead.org" 
	<linux-rockchip@lists.infradead.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] dt-bindings: add devicetree bindings for st-pwm
 regulator
Message-ID: <20140922104042.GG3290@leverpostej>
References: <1411354380-14326-1-git-send-email-zyw@rock-chips.com>
 <1411354380-14326-3-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411354380-14326-3-git-send-email-zyw@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 03:53:00AM +0100, Chris Zhong wrote:
> Document the st-pwm regulator
> 
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> 
> Adviced by Doug Anderson
> - remove regulator-always-on and regulator-boot-on from the Example
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> ---
> 
> Changes in v4: None
> Changes in v3:
> Adviced by Doug Anderson
> - update the Example
> 
> Changes in v2:
> Adviced by Lee Jones
> - rename the documentation
> Adviced by Doug Anderson
> - update the example
> Adviced by Mark Rutland
> - remove pwm-reg-period
> 
>  .../bindings/regulator/pwm-regulator.txt           |   27 ++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/regulator/pwm-regulator.txt
> 
> diff --git a/Documentation/devicetree/bindings/regulator/pwm-regulator.txt b/Documentation/devicetree/bindings/regulator/pwm-regulator.txt
> new file mode 100644
> index 0000000..c6756a9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/pwm-regulator.txt
> @@ -0,0 +1,27 @@
> +pwm regulator bindings
> +
> +Required properties:
> +- compatible: Should be "pwm-regulator"
> +- pwms: OF device-tree PWM specification (see PWM binding pwm.txt)
> +- voltage-table: voltage and duty table, include 2 merbers in each set of

Typo: s/merbers/members/ (I guess)

Otherwise this looks fine.

Mark.

> +  brackets, first one is voltage(unit: uv), the next is duty(unit: percent)
> +
> +Any property defined as part of the core regulator binding defined in
> +regulator.txt can also be used.
> +
> +Example:
> +	pwm_regulator {
> +		compatible = "pwm-regulator;
> +		pwms = <&pwm1 0 8448 0>;
> +
> +		voltage-table = <1114000 0>,
> +				<1095000 10>,
> +				<1076000 20>,
> +				<1056000 30>,
> +				<1036000 40>,
> +				<1016000 50>;
> +
> +		regulator-min-microvolt = <1016000>;
> +		regulator-max-microvolt = <1114000>;
> +		regulator-name = "vdd_logic";
> +	};
> -- 
> 1.7.9.5
> 
> 
