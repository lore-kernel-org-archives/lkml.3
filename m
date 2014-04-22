Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbaDVNeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:34:36 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:61725 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbaDVNe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:34:27 -0400
MIME-Version: 1.0
In-Reply-To: <1392465619-27614-3-git-send-email-sthokal@xilinx.com>
References: <1392465619-27614-1-git-send-email-sthokal@xilinx.com>
	<1392465619-27614-3-git-send-email-sthokal@xilinx.com>
Date: Tue, 22 Apr 2014 08:34:25 -0500
Message-ID: <CAL_Jsq+FZt5yLwePEwiAHoACM1S2rE3Yi0302LwRHWdn-pcnFQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] dma: Add Xilinx Video DMA DT Binding Documentation
From: Rob Herring <robherring2@gmail.com>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, levex@linux.com,
        Lars-Peter Clausen <lars@metafoo.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dmaengine@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 6:00 AM, Srikanth Thokala <sthokal@xilinx.com> wrote:
> Device-tree binding documentation of Xilinx Video DMA Engine
>
> Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>

A few typos below, but otherwise:

Acked-by: Rob Herring <robh@kernel.org>

> ---
> Changes in v3:
> None
>
> Changes in v2:
> - Removed device-id DT property, as suggested by Arnd Bergmann
> - Properly documented DT bindings as suggested by Arnd Bergmann
> ---
>  .../devicetree/bindings/dma/xilinx/xilinx_vdma.txt |   75 ++++++++++++++++++++
>  1 file changed, 75 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
>
> diff --git a/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
> new file mode 100644
> index 0000000..ab8be1a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
> @@ -0,0 +1,75 @@
> +Xilinx AXI VDMA engine, it does transfers between memory and video devices.
> +It can be configured to have one channel or two channels. If configured
> +as two channels, one is to transmit to the video device and another is
> +to receive from the video device.
> +
> +Required properties:
> +- compatible: Should be "xlnx,axi-vdma-1.00.a"
> +- #dma-cells: Should be <1>, see "dmas" property below
> +- reg: Should contain VDMA registers location and length.
> +- xlnx,num-fstores: Should be the number of framebuffers as configured in h/w.
> +- dma-channel child node: Should have atleast one channel and can have upto

s/atleast/at least/
s/upto/up to/

> +       two channels per device. This node specifies the properties of each
> +       DMA channel (see child node properties below).
> +
> +Optional properties:
> +- xlnx,include-sg: Tells whether configured for Scatter-mode in
> +       the hardware.
> +- xlnx,flush-fsync: Tells whether which channel to Flush on Frame sync.

s/whether//

> +       It takes following values:
> +       {1}, flush both channels
> +       {2}, flush mm2s channel
> +       {3}, flush s2mm channel
> +
> +Required child node properties:
> +- compatible: It should be either "xlnx,axi-vdma-mm2s-channel" or
> +       "xlnx,axi-vdma-s2mm-channel".
> +- interrupts: Should contain per channel VDMA interrupts.
> +- xlnx,data-width: Should contain the stream data width, take values
> +       {32,64...1024}.
> +
> +Option child node properties:

s/Option/Optional/

> +- xlnx,include-dre: Tells whether hardware is configured for Data
> +       Realignment Engine.
> +- xlnx,genlock-mode: Tells whether Genlock synchronization is
> +       enabled/disabled in hardware.
> +
> +Example:
> +++++++++
> +
> +axi_vdma_0: axivdma@40030000 {
> +       compatible = "xlnx,axi-vdma-1.00.a";
> +       #dma_cells = <1>;
> +       reg = < 0x40030000 0x10000 >;
> +       xlnx,num-fstores = <0x8>;
> +       xlnx,flush-fsync = <0x1>;
> +       dma-channel@40030000 {
> +               compatible = "xlnx,axi-vdma-mm2s-channel";
> +               interrupts = < 0 54 4 >;
> +               xlnx,datawidth = <0x40>;
> +       } ;
> +       dma-channel@40030030 {
> +               compatible = "xlnx,axi-vdma-s2mm-channel";
> +               interrupts = < 0 53 4 >;
> +               xlnx,datawidth = <0x40>;
> +       } ;
> +} ;
> +
> +
> +* DMA client
> +
> +Required properties:
> +- dmas: a list of <[Video DMA device phandle] [Channel ID]> pairs,
> +       where Channel ID is '0' for write/tx and '1' for read/rx
> +       channel.
> +- dma-names: a list of DMA channel names, one per "dmas" entry
> +
> +Example:
> +++++++++
> +
> +vdmatest_0: vdmatest@0 {
> +       compatible ="xlnx,axi-vdma-test-1.00.a";
> +       dmas = <&axi_vdma_0 0
> +               &axi_vdma_0 1>;
> +       dma-names = "vdma0", "vdma1";
> +} ;
> --
> 1.7.9.5
>
