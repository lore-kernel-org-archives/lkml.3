Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbaJAXTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 19:19:31 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:51926 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaJAXTa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 19:19:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Chris Kohn <ckohn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, Jason Wu <huanyu@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>
Subject: Re: [PATCH v2] staging: Add Xilinx Clocking Wizard driver
Date: Thu, 02 Oct 2014 02:19:29 +0300
Message-ID: <2588006.v8XFKnzbpr@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1412197352-21746-1-git-send-email-soren.brinkmann@xilinx.com>
References: <20141001185835.GE23154@mwanda> <1412197352-21746-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sören,

Thank you for the patch.

On Wednesday 01 October 2014 14:02:32 Soren Brinkmann wrote:
> Add a driver for the Xilinx Clocking Wizard soft IP. The clocking wizard
> provides an AXI interface to dynamically reconfigure the clocking
> resources of Xilinx FPGAs.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> Hi Greg, Dan,
> 
> I fixed the things Dan pointed out, please take this v2 instead of the
> original patch.
> 
> Also, don't get caught up too much with style issues around the code that
> registers the clocks. To support set_rate() opeartions this will have to
> change anyway. It doesn't make a lot of sense to spend much time on those
> parts.
> 
> 	Thanks,
> 	Sören
> 
> v2:
>  - implement dev_pm_ops
>  - don't use array for clock inputs
>  - add more information in error output
>  - fix style issues
>  - fix error path
> ---
>  drivers/staging/Kconfig                            |   2 +
>  drivers/staging/Makefile                           |   1 +
>  drivers/staging/clocking-wizard/Kconfig            |   9 +
>  drivers/staging/clocking-wizard/Makefile           |   1 +
>  drivers/staging/clocking-wizard/TODO               |  12 +
>  .../clocking-wizard/clk-xlnx-clock-wizard.c        | 336 ++++++++++++++++++
>  drivers/staging/clocking-wizard/dt-binding.txt     |  30 ++
>  7 files changed, 391 insertions(+)
>  create mode 100644 drivers/staging/clocking-wizard/Kconfig
>  create mode 100644 drivers/staging/clocking-wizard/Makefile
>  create mode 100644 drivers/staging/clocking-wizard/TODO
>  create mode 100644 drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
>  create mode 100644 drivers/staging/clocking-wizard/dt-binding.txt

[snip]

> diff --git a/drivers/staging/clocking-wizard/dt-binding.txt
> b/drivers/staging/clocking-wizard/dt-binding.txt new file mode 100644
> index 000000000000..cc3cc5e91440
> --- /dev/null
> +++ b/drivers/staging/clocking-wizard/dt-binding.txt
> @@ -0,0 +1,30 @@
> +Binding for Xilinx Clocking Wizard IP Core
> +
> +This binding uses the common clock binding[1]. Details about the devices
> can be +found in the product guide[2].
> +
> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> +[2] Clocking Wizard Product Guide
> +http://www.xilinx.com/support/documentation/ip_documentation/clk_wiz/v5_1/p
> g065-clk-wiz.pdf +
> +Required properties:
> + - compatible: Must be 'xlnx,clocking-wizard'
> + - reg: Base and size of the cores register space
> + - clocks: Handle to input clock
> + - clock-names: Tuple containing 'clk_in1' and 's_axi_aclk'
> + - clock-output-names: Names for the output clocks
> +
> +Optional properties:
> + - speed-grade: Speed grade of the device

You should document what values are allowed.

> +
> +Example:
> +	clock-generator@40040000 {
> +		reg = <0x40040000 0x1000>;
> +		compatible = "xlnx,clocking-wizard";
> +		speed-grade = <(-1)>;

Can't we make the speed grade positive ? It looks to me that the - is nowadays 
a dash and not a minus sign, given that higher absolute values of the speed 
grade mean faster devices. The days when the speed grate represented the 
propagation time of signals in ns is long gone I suppose.

> +		clock-names = "clk_in1", "s_axi_aclk";
> +		clocks = <&clkc 15>, <&clkc 15>;
> +		clock-output-names = "clk_out0", "clk_out1", "clk_out2",
> +				     "clk_out3", "clk_out4", "clk_out5",
> +				     "clk_out6", "clk_out7";
> +	};

-- 
Regards,

Laurent Pinchart

