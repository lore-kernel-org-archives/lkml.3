Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbaE1POw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:14:52 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:33388 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaE1POu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:14:50 -0400
MIME-Version: 1.0
In-Reply-To: <1400762084-31606-2-git-send-email-maxime.ripard@free-electrons.com>
References: <1400762084-31606-1-git-send-email-maxime.ripard@free-electrons.com>
 <1400762084-31606-2-git-send-email-maxime.ripard@free-electrons.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 28 May 2014 23:14:29 +0800
X-Google-Sender-Auth: -hQwAa3W35kyCiZYJ145NPYKu38
Message-ID: <CAGb2v67ekvfjx+nFNGfVkWYH1XeeHq4+jPGsVZBzCQNPH9Eddg@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v9 1/2] Documentation: dt: Add Allwinner A31
 DMA controller bindings
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dmaengine@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, Shuge <shuge@allwinnertech.com>,
        zhuzhenhua@allwinnertech.com, Arnd Bergmann <arnd@arndb.de>,
        andriy.shevchenko@intel.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 8:34 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> The Allwinner A31 DMA controller is rather simple to describe in the DT. Add
> the bindings documentation.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  .../devicetree/bindings/dma/sun6i-dma.txt          | 45 ++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/sun6i-dma.txt
>
> diff --git a/Documentation/devicetree/bindings/dma/sun6i-dma.txt b/Documentation/devicetree/bindings/dma/sun6i-dma.txt
> new file mode 100644
> index 000000000000..5d7c86d52665
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/sun6i-dma.txt
> @@ -0,0 +1,45 @@
> +Allwinner A31 DMA Controller
> +
> +This driver follows the generic DMA bindings defined in dma.txt.
> +
> +Required properties:
> +
> +- compatible:  Must be "allwinner,sun6i-a31-dma"
> +- reg:         Should contain the registers base address and length
> +- interrupts:  Should contain a reference to the interrupt used by this device
> +- clocks:      Should contain a reference to the parent AHB clock
> +- resets:      Should contain a reference to the reset controller asserting
> +               this device in reset

Extra spaces between the leading tabs.
(Gmail messes up whitespaces, please see original mail.)

> +- #dma-cells : Should be 1, a single cell holding a line request number
> +
> +Example:
> +       dma: dma-controller@01c02000 {
> +               compatible = "allwinner,sun6i-a31-dma";
> +               reg = <0x01c02000 0x1000>;
> +               interrupts = <0 50 4>;
> +               clocks = <&ahb1_gates 6>;
> +               resets = <&ahb1_rst 6>;
> +               #dma-cells = <1>;
> +       };
> +
> +Clients:
> +
> +DMA clients connected to the A31 DMA controller must use the format
> +described in the dma.txt file, using a two-cell specifier for each
> +channel: a phandle plus one integer cells.
> +The two cells in order are:
> +
> +1. A phandle pointing to the DMA controller.
> +2. The port ID as specified in the datasheet
> +
> +Example:
> +spi2: spi@01c6a000 {
> +       compatible = "allwinner,sun6i-a31-spi";
> +       reg = <0x01c6a000 0x1000>;
> +       interrupts = <0 67 4>;
> +       clocks = <&ahb1_gates 22>, <&spi2_clk>;
> +       clock-names = "ahb", "mod";
> +       dmas = <&dma 25>, <&dma 25>;
> +       dma-names = "rx", "tx";
> +       resets = <&ahb1_rst 22>;
> +};
> --
> 1.9.3
>
> --
> You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.
