Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaK3I5A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 03:57:00 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42208 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbaK3I46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 03:56:58 -0500
Date: Sun, 30 Nov 2014 00:56:54 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Zhou Wang <wangzhou.bry@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
        galak@codeaurora.org, caizhiyong@huawei.com, haojian.zhuang@gmail.com,
        xuwei5@hisilicon.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] mtd: hisilicon: add device tree binding
 documentation
Message-ID: <20141130085654.GE3608@norris-Latitude-E6410>
References: <1415105221-7732-1-git-send-email-wangzhou.bry@gmail.com>
 <1415105221-7732-3-git-send-email-wangzhou.bry@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415105221-7732-3-git-send-email-wangzhou.bry@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 08:47:01PM +0800, Zhou Wang wrote:
> Signed-off-by: Zhou Wang <wangzhou.bry@gmail.com>
> ---
>  .../devicetree/bindings/mtd/hisi504-nand.txt       |   40 ++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mtd/hisi504-nand.txt
> 
> diff --git a/Documentation/devicetree/bindings/mtd/hisi504-nand.txt b/Documentation/devicetree/bindings/mtd/hisi504-nand.txt
> new file mode 100644
> index 0000000..c8b3988
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mtd/hisi504-nand.txt
> @@ -0,0 +1,40 @@
> +Hisilicon Hip04 Soc NAND controller DT binding
> +
> +Required properties:
> +- compatible:          Should be "hisilicon,504-nfc".
> +- reg:                 The first contains base physical address and size of
> +                       NAND controller's registers. The second contains base
> +                       physical address and size of NAND controller's buffer.
> +- interrupts:          Interrupt number for nfc.
> +- nand-bus-width:      See nand.txt.
> +- nand-ecc-mode:       See nand.txt.

Do you support all modes, or just "hw"? Might be worth noting here.

> +- hisi,nand-ecc-bits:  ECC bits type support.
> +                 <0>:  none ecc
> +                 <1>:  Can correct 1bit per 512byte.
> +                 <6>:  Can correct 16bits per 1K byte.

You should re-use the nand-ecc-strength and nand-ecc-step-size
properties here. So you'll support these options:

  nand-ecc-strength=0  nand-ecc-step-size=<don't care>
  nand-ecc-strength=1  nand-ecc-step-size=512
  nand-ecc-strength=16 nand-ecc-step-size=1024

> +- #address-cells:      partition address, should be set 1.
> +- #size-cells:         partition size, should be set 1.
> +
> +Flash chip may optionally contain additional sub-nodes describing partitions of
> +the address space. See partition.txt for more detail.
> +
> +Example:
> +
> +	nand: nand@4020000 {
> +		compatible = "hisilicon,504-nfc";
> +		reg = <0x4020000 0x10000>, <0x5000000 0x1000>;
> +		interrupts = <0 379 4>;
> +		nand-bus-width = <8>;
> +		nand-ecc-mode = "hw";
> +		hisi,nand-ecc-bits = <1>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +
> +		partition@0 {
> +			label = "nand_text";
> +			reg = <0x00000000 0x00400000>;
> +		};
> +
> +		...
> +
> +	};

Brian
