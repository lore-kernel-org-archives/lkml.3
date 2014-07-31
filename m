Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbaGaHSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:18:00 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:48596 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbaGaHR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:17:58 -0400
Date: Thu, 31 Jul 2014 00:17:53 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        michal.simek@xilinx.com, grant.likely@linaro.org,
        gregkh@linuxfoundation.org, jason@lakedaemon.net,
        ezequiel.garcia@free-electrons.com, arnd@arndb.de, dwmw2@infradead.org,
        artem.bityutskiy@linux.intel.com, pekon@ti.com, jussi.kivilinna@iki.fi,
        acourbot@nvidia.com, ivan.khoronzhuk@ti.com, joern@logfs.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        kpc528@gmail.com, kalluripunnaiahchoudary@gmail.com,
        anirudh@xilinx.com, svemula@xilinx.com,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH RFC v4 1/2] Devicetree: Add pl353 smc controller
 devicetree binding information
Message-ID: <20140731071753.GH11952@brian-ubuntu>
References: <1406561236-29207-1-git-send-email-punnaia@xilinx.com>
 <f9cb28fc-6a68-42b8-bdc0-9ad0941de977@BN1AFFO11FD013.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9cb28fc-6a68-42b8-bdc0-9ad0941de977@BN1AFFO11FD013.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 28, 2014 at 08:57:15PM +0530, Punnaiah Choudary Kalluri wrote:
> Add pl353 static memory controller devicetree binding information.
> 
> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
> ---
> Changes in v4:
>  - none
> Changes in v3:
>  - none
> Changes in v2:
>  - modified timing binding info as per onfi timing parameters

^^^ There were other comments here:

  http://lists.infradead.org/pipermail/linux-mtd/2014-April/053488.html

You don't need or want these timing parameters at all, I don't think.

>  - add suffix nano second as timing unit
>  - modified the clock names as per the IP spec
> ---
>  .../bindings/memory-controllers/pl353-smc.txt      |   53 ++++++++++++++++++++
>  1 files changed, 53 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/memory-controllers/pl353-smc.txt
> 
> diff --git a/Documentation/devicetree/bindings/memory-controllers/pl353-smc.txt b/Documentation/devicetree/bindings/memory-controllers/pl353-smc.txt
> new file mode 100644
> index 0000000..c1f011d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/memory-controllers/pl353-smc.txt
> @@ -0,0 +1,53 @@
> +Device tree bindings for ARM PL353 static memory controller
> +
> +PL353 static memory controller supports two kinds of memory
> +interfaces.i.e NAND and SRAM/NOR interfaces.
> +The actual devices are instantiated from the child nodes of pl353 smc node.
> +
> +Required properties:
> +- compatible		: Should be "arm,pl353-smc-r2p1"
> +- reg			: Controller registers map and length.
> +- clock-names		: List of input clock names - "memclk", "aclk"
> +			  (See clock bindings for details).
> +- clocks		: Clock phandles (see clock bindings for details).
> +- address-cells	: Address cells, must be 1.
> +- size-cells		: Size cells. Must be 1.
> +
> +Child nodes:
> + For NAND the "arm,pl353-nand-r2p1" and for NOR the "cfi-flash" drivers are
> +supported as child nodes.
> +
> +Mandatory timing properties for child nodes:
> +- nand-tRC-ns	: Read cycle time.
> +- nand-tWC-ns	: Write cycle time.
> +- nand-tREA-ns	: re_n assertion delay.
> +- nand-tWP-ns	: we_n de-assertion delay.
> +- nand-tCLR-ns	: Status read time
> +- nand-tAR-ns	: ID read time
> +- nand-tRR-ns	: busy to re_n

These properties should probably be dropped. Look in l2-mtd.git, where
we now have drivers/mtd/nand/nand_timings.c to define the ONFI timing
modes, which can be auto-detected (look at struct
nand_onfi_params::async_timing_mode). Boris also has pending patches for
non-ONFI chips.

> +for nand partition information please refer the below file
> +Documentation/devicetree/bindings/mtd/partition.txt
> +
> +Example:
> +	pl353smcc_0: pl353smcc@e000e000 {
> +			compatible = "arm,pl353-smcc-r2p1"
> +			clock-names = "memclk", "aclk";
> +			clocks = <&clkc 11>, <&clkc 44>;
> +			reg = <0xe000e000 0x1000>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges;
> +			nand_0: nand@e1000000 {
> +				compatible = "arm,pl353-nand-r2p1"
> +				reg = <0xe1000000 0x1000000>;
> +				nand-tRC-ns = <40>;
> +				nand-tWC-ns = <40>;
> +				nand-tREA-ns = <10>;
> +				nand-tWP-ns = <20>;
> +				nand-tCLR-ns = <20>;
> +				nand-tAR-ns = <20>;
> +				nand-tRR-ns = <40>;
> +				(...)
> +			};
> +	};

Brian
