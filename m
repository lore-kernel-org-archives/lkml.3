Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab3KNTCC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 14:02:02 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28551 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab3KNTBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 14:01:55 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19dodfBtaXYuKZDuVFQ+N8c
Date: Thu, 14 Nov 2013 11:01:51 -0800
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] doc: devicetree: Add bindings documentation for
 omap-des driver
Message-ID: <20131114190150.GT10317@atomide.com>
References: <1384199386-14504-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384199386-14504-1-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [131111 11:50]:
> Add documentation for the generic OMAP DES crypto modul describing the device
> tree bindings.
> 
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Joel Fernandes <joelf@ti.com>

Thanks applying into omap-for-v3.13/fixes.

Tony

> ---
> v2 changes: Update documentation for clocks, clock-names and dma-names.
> 
>  .../devicetree/bindings/crypto/omap-des.txt        | 30 ++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/omap-des.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/omap-des.txt b/Documentation/devicetree/bindings/crypto/omap-des.txt
> new file mode 100644
> index 0000000..e8c63bf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/omap-des.txt
> @@ -0,0 +1,30 @@
> +OMAP SoC DES crypto Module
> +
> +Required properties:
> +
> +- compatible : Should contain "ti,omap4-des"
> +- ti,hwmods: Name of the hwmod associated with the DES module
> +- reg : Offset and length of the register set for the module
> +- interrupts : the interrupt-specifier for the DES module
> +- clocks : A phandle to the functional clock node of the DES module
> +           corresponding to each entry in clock-names
> +- clock-names : Name of the functional clock, should be "fck"
> +
> +Optional properties:
> +- dmas: DMA specifiers for tx and rx dma. See the DMA client binding,
> +	Documentation/devicetree/bindings/dma/dma.txt
> +	Each entry corresponds to an entry in dma-names
> +- dma-names: DMA request names should include "tx" and "rx" if present
> +
> +Example:
> +	/* DRA7xx SoC */
> +	des: des@480a5000 {
> +		compatible = "ti,omap4-des";
> +		ti,hwmods = "des";
> +		reg = <0x480a5000 0xa0>;
> +		interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
> +		dmas = <&sdma 117>, <&sdma 116>;
> +		dma-names = "tx", "rx";
> +		clocks = <&l3_iclk_div>;
> +		clock-names = "fck";
> +	};
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
