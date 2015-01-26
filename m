Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbbAZNgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:36:32 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:43139 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbbAZNg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:36:29 -0500
Date: Mon, 26 Jan 2015 13:36:02 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stefan Agner <stefan@agner.ch>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND v3 2/3] irqchip: vf610-mscm: dt-bindings: add MSCM
 bindings
Message-ID: <20150126133602.GG23313@leverpostej>
References: <1421309046-22452-1-git-send-email-stefan@agner.ch>
 <1421309046-22452-3-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421309046-22452-3-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 08:04:05AM +0000, Stefan Agner wrote:
> Add binding documentation for Miscellaneous System Control Module
> found in Freescale Vybrid SoC's.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  .../bindings/arm/freescale/fsl,vf610-mscm.txt         | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/freescale/fsl,vf610-mscm.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/freescale/fsl,vf610-mscm.txt b/Documentation/devicetree/bindings/arm/freescale/fsl,vf610-mscm.txt
> new file mode 100644
> index 0000000..e051b88
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/freescale/fsl,vf610-mscm.txt
> @@ -0,0 +1,19 @@
> +Freescale Vybrid Miscellaneous System Control Module
> +
> +The MSCM IP contains Access Control and TrustZone Security hardware,
> +CPU Configuration registers and Interrupt Router control.
> +
> +Required properties:
> +- compatible : "fsl,vf610-mscm", "syscon"

I'm a little concerned by this also being a syscon. What other devices
need to refer to this block as a syscon?

> +- interrupt-controller : Identifies the node as an interrupt controller
> +- #interrupt-cells : Two cells, interrupt number and flags (IRQ type)

What numbers and flags are valid?

Mark.

> +- reg : the register range of the MSCM module
> +
> +Example:
> +	mscm: mscm@40001000 {
> +		compatible = "fsl,vf610-mscm", "syscon";
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +		interrupt-parent = <&intc>;
> +		reg = <0x40001000 0x1000>;
> +	}
> -- 
> 2.2.1
> 
> 
