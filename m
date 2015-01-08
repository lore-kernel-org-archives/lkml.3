Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbbAHOgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:36:43 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64428 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752063AbbAHOgl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:36:41 -0500
Date: Thu, 8 Jan 2015 14:35:42 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Peter Pan =?utf-8?B?5r2Y5qCLIChwZXRlcnBhbmRvbmcp?= 
	<peterpandong@micron.com>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Qi Wang =?utf-8?B?546L6LW3IChxaXdhbmcp?= <qiwang@micron.com>,
        Frank Liu =?utf-8?B?5YiY576kIChmcmFua2xpdSk=?= 
	<frankliu@micron.com>,
        Melanie Zhang =?utf-8?B?5byg54eVIChtZWxhbmllemhhbmcp?= 
	<melaniezhang@micron.com>
Subject: Re: [PATCH 3/3] mtd: spi-nand: add devicetree binding
Message-ID: <20150108143542.GF10537@leverpostej>
References: <87F60714EC601C4C83DFF1D2E3D390A04AB425@NTXXIAMBX02.xacn.micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <87F60714EC601C4C83DFF1D2E3D390A04AB425@NTXXIAMBX02.xacn.micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 12:52:26AM +0000, Peter Pan 潘栋 (peterpandong) wrote:
> This commit adds the devicetree binding document that specifies the
> spi nand devices support.
> 
> Signed-off-by: Peter Pan <peterpandong@micron.com>
> ---
>  Documentation/devicetree/bindings/mtd/spi-nand.txt | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mtd/spi-nand.txt
> 
> diff --git a/Documentation/devicetree/bindings/mtd/spi-nand.txt b/Documentation/devicetree/bindings/mtd/spi-nand.txt
> new file mode 100644
> index 0000000..9dd3efd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mtd/spi-nand.txt
> @@ -0,0 +1,22 @@
> +* NAND driver for MT29F, GD5F and similar SPI NAND flash chips
> +
> +Required properties:
> +- #address-cells, #size-cells : Must be present if the device has sub-nodes
> +  representing partitions.

Can we refer to the binding document for that?

> +- compatible : Should be the manufacturer and the name of the chip. Bear in mind
> +               the DT binding is not Linux-only, but in case of Linux, see the
> +               "spi_nand_id_table" array in drivers/mtd/spi-nand/spi-nand-device.c
> +               for the list of supported chips.

NAK for referring to Linux internals from a binding document.

The list of compatible string should be defined in this binding
document.

> +- reg : Chip-Select number
> +- spi-max-frequency : Maximum frequency of the SPI bus the chip can operate at
> +
> +Example:
> +
> +	flash: flash@0 {
> +		#address-cells = <1>;
> +		#size-cells = <1>;

These aren't necessary as no partitions are defined here.

Otherwise, this looks ok.

Thanks,
Mark.

> +		compatible = "micron,mt29f";
> +		reg = <0>;
> +		spi-max-frequency = <50000000>;
> +	};
> +
> -- 
> 1.9.1
> N嫥叉靣笡y氊b瞂千v豝?藓{.n?壏漽鴾z谵z)韰骅w*jg?秹殠娸/侁鋤罐枈?娹櫒璀??摺玜囤瓽珴閔?鎗:+v墾妛鑶佶
