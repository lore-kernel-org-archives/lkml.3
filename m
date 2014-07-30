Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbaG3PxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:53:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43660 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754411AbaG3PxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:53:16 -0400
Date: Wed, 30 Jul 2014 16:53:03 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] regulator: userspace-consumer: add DT binding details
Message-ID: <20140730155302.GE20162@leverpostej>
References: <1406728440-17837-1-git-send-email-ldewangan@nvidia.com>
 <1406728440-17837-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406728440-17837-2-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 02:54:00PM +0100, Laxman Dewangan wrote:
> Add DT binding document and details DT binding for the driver
> regulator/userspace-consumer.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  .../bindings/regulator/userspace-consumer.txt      | 26 ++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/regulator/userspace-consumer.txt
> 
> diff --git a/Documentation/devicetree/bindings/regulator/userspace-consumer.txt b/Documentation/devicetree/bindings/regulator/userspace-consumer.txt
> new file mode 100644
> index 0000000..73c651c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/userspace-consumer.txt
> @@ -0,0 +1,26 @@
> +Userspace consumer regulators
> +
> +Required properties:
> +- compatible		: Must be "reg-userspace-consumer".

I would never expect to see "userspace" in a DT beinding string; this is
entirely a software abstraction description and has nothing to do with
the interaction of HW components.

Why do you think we need this in the DT?

Thanks,
Mark.

> +- regulator-supplies: Supply names for this regulator. This can be
> +	multiple strings.
> +
> +Optional properties:
> +- regulator-name: Name of the consumer line.
> +- regulator-boot-on: Enable regulator on booting.
> +
> +With all supply names, there should be <supply-name>-supply to pass regulators
> +handle as defined in regulator.txt.
> +
> +Example:
> +
> +	userspace-consumer {
> +		compatible = "reg-userspace-consumer";
> +
> +		regulator-name = "gps-consumer";
> +		regulator-boot-on;
> +		regulator-supplies = "vdd", "vcc", "vdd-3v3";
> +		vdd-supply = <&reg1>;
> +		vcc-supply = <&reg2>;
> +		vdd-3v3-supply = <&reg3>;
> +	};
> -- 
> 1.8.1.5
> 
> 
