Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbbASLFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:05:00 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37736 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbbASLE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:04:58 -0500
Date: Mon, 19 Jan 2015 11:04:36 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2] remoteproc: microblaze: Document device tree bindings
Message-ID: <20150119110436.GD21553@leverpostej>
References: <a458462d2dc6901440bded015608f7a9df9e7942.1421662385.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a458462d2dc6901440bded015608f7a9df9e7942.1421662385.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 10:30:19AM +0000, Michal Simek wrote:
> Add device tree binding documentation for the Microblaze remoteproc
> on Xilinx Zynq.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
>  .../bindings/remoteproc/mb_remoteproc.txt          | 46 ++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/remoteproc/mb_remoteproc.txt
> 
> diff --git a/Documentation/devicetree/bindings/remoteproc/mb_remoteproc.txt b/Documentation/devicetree/bindings/remoteproc/mb_remoteproc.txt
> new file mode 100644
> index 000000000000..a2490eac0208
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/remoteproc/mb_remoteproc.txt
> @@ -0,0 +1,46 @@
> +Xilinx ARM-Microblaze remoteproc driver
> +
> +This driver requires specific Zynq hardware design where Microblaze is added
> +to the programmable logic.

The binding should describe the _hardware_, not the particular driver.
Please remove any references to the 'driver'.

What hardware does this binding describe? Please focus on that.

> +Microblaze is connected with PS block via axi bus connected to PS HP port
> +to ensure access to PS DDR.
> +Communication channels are done via soft GPIO IP connected to PS block
> +and to Microblaze. There are also 2 gpio control signals reset and debug
> +which are used for resetting Microblaze.
> +
> +Required properties:
> +- compatible : Should be "xlnx,mb_remoteproc"

s/_/-/ in compatible strings please.

> +- reg : Address and length of the ddr address space
> +- bram: Phandle to bram controller which can access Microblaze BRAM
> +- bram-firmware : Microblaze BRAM bootloader name

Huh? What's this aname used for?

This looks like a filesystem name, which shouldn't be in the DT.

> +- firmware : Default firmware name which can be override by
> +	     "firmware" module parameter

Likewise on all points.

> +- reset : Gpio phandle which reset Microblaze remoteproc
> +- debug : Gpio phandle which setup Microblaze to debug state
> +- ipino : Gpio phandle for Microblaze to ARM communication
> +- vring0 : Gpio phandle for ARM to Microblaze communication vring 0
> +- vring1 : Gpio phandle for ARM to Microblaze communication vring 1

s/phandle/ / -- there's a gpio-specifier too, but we may as well just
ignore the specifics of the format and leave that to the GPIO bindings.

These should all have a "-gpio" suffix, too.

> +
> +Microblaze SoC can be also connected to the PS block via a axi bus.
> +That's why there is the option to allocate interrupts for Microblaze use only.
> +The driver will allocate interrupts to itself and Microblaze sw has to ensure
> +that interrupts are properly enabled and handled by Microblaze interrupt
> +controller.

I'm not sure I follow? What is this for?

Thanks,
Mark.

> +
> +Optional properties:
> + - interrupts : Interrupt mapping for remoteproc
> + - interrupt-parent : Phandle for the interrupt controller
> +
> +Example:
> +mb_remoteproc@800000 {
> +	compatible = "xlnx,mb_remoteproc";
> +	reg = < 0x8000000 0x8000000 >;
> +	bram = <&axi_bram_ctrl_0>;
> +	bram-firmware = "mb.bin";
> +	firmware = "image.elf";
> +	reset = <&zynq_gpio_reset 1 0>;
> +	debug = <&zynq_gpio_reset 0 0>;
> +	ipino = <&zynq_gpio_vring 0 0>;
> +	vring0 = <&zynq_gpio_vring 1 0>;
> +	vring1 = <&zynq_gpio_vring 2 0>;
> +};
> --
> 1.8.2.3
> 


