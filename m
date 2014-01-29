Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaA2RLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:11:38 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:42519 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaA2RLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:11:35 -0500
MIME-Version: 1.0
In-Reply-To: <1391006064-28890-10-git-send-email-b.brezillon.dev@gmail.com>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
	<1391006064-28890-10-git-send-email-b.brezillon.dev@gmail.com>
Date: Wed, 29 Jan 2014 11:11:34 -0600
Message-ID: <CAL_JsqLVr1gSLArqtfOiHce+u6ZK8FiKMX0o9bvMrMoGGhATvg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 09/14] mtd: nand: add sunxi NFC dt bindings doc
From: Rob Herring <robherring2@gmail.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mtd@lists.infradead.org, dev@linux-sunxi.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 8:34 AM, Boris BREZILLON
<b.brezillon.dev@gmail.com> wrote:
> Add the sunxi NAND Flash Controller dt bindings documentation.
>
> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
> ---
>  .../devicetree/bindings/mtd/sunxi-nand.txt         |   46 ++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mtd/sunxi-nand.txt
>
> diff --git a/Documentation/devicetree/bindings/mtd/sunxi-nand.txt b/Documentation/devicetree/bindings/mtd/sunxi-nand.txt
> new file mode 100644
> index 0000000..b0e55a3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mtd/sunxi-nand.txt
> @@ -0,0 +1,46 @@
> +Allwinner NAND Flash Controller (NFC)
> +
> +Required properties:
> +- compatible : "allwinner,sun4i-nand".
> +- reg : shall contain registers location and length for data and reg.
> +- interrupts : shall define the nand controller interrupt.
> +- #address-cells: shall be set to 1. Encode the nand CS.
> +- #size-cells : shall be set to 0.
> +- clocks : shall reference nand controller clocks.
> +- clock-names : nand controller internal clock names. Shall contain :
> +    * "ahb_clk" : AHB gating clock
> +    * "sclk" : nand controller clock
> +
> +Optional children nodes:
> +Children nodes represent the available nand chips.
> +
> +Optional properties:

For the controller or per nand chip?

> +- onfi,nand-timing-mode : mandatory if the chip does not support the ONFI
> +  standard.

Add to generic nand binding.

> +- allwinner,rb : shall contain the native Ready/Busy ids.
> + or
> +- rb-gpios : shall contain the gpios used as R/B pins.

Isn't allwinner,rb implied by a lack of rb-gpios property. Or no R/B
pin is an option? If so, don't you need some fixed time delay
properties like max erase time?

rb-gpios could be added to the generic nand binding as well.

Rob
