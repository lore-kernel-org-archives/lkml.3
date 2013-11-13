Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab3KMK5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 05:57:17 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57809 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab3KMK5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 05:57:13 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCHv3] dmaengine: Add support for BCM2835
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <528154A1.1050303@koalo.de>
Date: Wed, 13 Nov 2013 04:57:07 -0600
Cc: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        devicetree <devicetree@vger.kernel.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <2B888C9F-DA6A-472C-AF14-95FB9CF1D41A@codeaurora.org>
References: <528154A1.1050303@koalo.de>
To: Florian Meier <florian.meier@koalo.de>
X-Mailer: Apple Mail (2.1822)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 11, 2013, at 4:05 PM, Florian Meier <florian.meier@koalo.de> wrote:

> Add support for DMA controller of BCM2835 as used in the Raspberry Pi.
> Currently it only supports cyclic DMA.
> 
> Signed-off-by: Florian Meier <florian.meier@koalo.de>
> ---
> 
> Thank you for your comments!
> I hope I have now removed all leftovers of the sg struct.
> Regarding the endian-ness: I have not found any hint about that in the datasheet. Therefore, I chose uint32_t. If you think fixed le32 is more likely I will change it.
> The PAD fields do not seem to be used, but the datasheet states they should be set to 0.
> 
> 
> .../devicetree/bindings/dma/bcm2835-dma.txt        |   57 ++
> arch/arm/boot/dts/bcm2835.dtsi                     |   23 +
> drivers/dma/Kconfig                                |    6 +
> drivers/dma/Makefile                               |    1 +
> drivers/dma/bcm2835-dma.c                          |  810 ++++++++++++++++++++
> 5 files changed, 897 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/dma/bcm2835-dma.txt
> create mode 100644 drivers/dma/bcm2835-dma.c
> 
> diff --git a/Documentation/devicetree/bindings/dma/bcm2835-dma.txt b/Documentation/devicetree/bindings/dma/bcm2835-dma.txt
> new file mode 100644
> index 0000000..9542ac8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/bcm2835-dma.txt
> @@ -0,0 +1,57 @@
> +* BCM2835 DMA controller
> +
> +Required properties:
> +- compatible: Should be "brcm,bcm2835-dma".
> +- reg: Should contain DMA registers location and length.
> +- interrupts: Should contain all DMA interrupts. First cell is the IRQ bank
> +		Second cell is the IRQ number.

Can you be more specific about what you mean by ‘all DMA interrupts’?

> +- #dma-cells: Must be <1>, used to represent the number of integer cells in
> +the dmas property of client devices.
> +- dma-channels: Maximum number of DMA channels available
> +- dma-requests: Number of DMA Requests. 
> +- dma-channel-mask: Bit mask representing the channels available.

Should be brcm,dma-channel-mask

> +
> +Example:
> +
> +dma: dma@7e007000 {
> +	compatible = "brcm,bcm2835-dma";
> +	reg = <0x7e007000 0xf00>;
> +	interrupts = <1 16
> +		      1 17
> +		      1 18
> +		      1 19
> +		      1 20
> +		      1 21
> +		      1 22
> +		      1 23
> +		      1 24
> +		      1 25
> +		      1 26
> +		      1 27
> +		      1 28>;
> +	
> +	#dma-cells = <1>;
> +	dma-channels = <15>;
> +	dma-requests = <32>;
> +	dma-channel-mask = <0x7f35>;
> +};
> +
> +DMA clients connected to the BCM2835 DMA controller must use the format
> +described in the dma.txt file, using a two-cell specifier for each channel:
> +a phandle plus one integer cells.
> +The two cells in order are:
> +
> +1. A phandle pointing to the DMA controller.
> +2. The DREQ number.
> +
> +Example:
> +
> +bcm2835_i2s: i2s@7e203000 {
> +	compatible = "brcm,bcm2835-i2s";
> +	reg = <	0x7e203000 0x20
> +		0x7e101098 0x02>;
> +
> +	dmas = <&dma 2
> +		&dma 3>;
> +	dma-names = "tx", "rx";
> +};

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

