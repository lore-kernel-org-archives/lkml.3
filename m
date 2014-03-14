Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbaCNQOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:14:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57481 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755798AbaCNQOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:14:16 -0400
Date: Fri, 14 Mar 2014 16:14:03 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Rob Landley <rob@landley.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH] spi: dw-mmio: add oftree support
Message-ID: <20140314161403.GN25870@e106331-lin.cambridge.arm.com>
References: <1394787326-14520-1-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394787326-14520-1-git-send-email-s.trumtrar@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 08:55:26AM +0000, Steffen Trumtrar wrote:
> Allow probing the dw-mmio from devicetree.
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> ---
> This was tested on Socfpga and v3.14-rc6
> 
>  .../devicetree/bindings/spi/spi-dw-mmio.txt        | 25 ++++++++++++++++++++++
>  drivers/spi/spi-dw-mmio.c                          | 19 +++++++++++++++-
>  2 files changed, 43 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/spi/spi-dw-mmio.txt
> 
> diff --git a/Documentation/devicetree/bindings/spi/spi-dw-mmio.txt b/Documentation/devicetree/bindings/spi/spi-dw-mmio.txt
> new file mode 100644
> index 0000000..2b9bb90
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/spi/spi-dw-mmio.txt
> @@ -0,0 +1,25 @@
> +Synopsys DesignWare SPI master controller.
> +
> +Required properties:
> +- compatible : "snps,dw-spi-mmio"

Is there not a better name than "dw-spi-mmio"?

What's the full name of the device, as on a datasheet? Is there no model
number?

Otherwise this looks ok.

> +- reg : The register base for the controller.
> +- interrupts : One interrupt, used by the controller.
> +- #address-cells : <1>, as required by generic SPI binding.
> +- #size-cells : <0>, also as required by generic SPI binding.
> +
> +Optional properties:
> +- num-chipselects : The number of chipselects.

If this is optional, when wuold I need to set this? What's the default
assumption?

Mark: I see some bindings have "num-chipselects", and some have
"num-cs". Do you have a preferred form that people could align on?

Cheers,
Mark.
