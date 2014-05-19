Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaESOH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:07:58 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:54498 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaESOH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:07:57 -0400
Date: Mon, 19 May 2014 15:07:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com
Subject: Re: [PATCH 1/4] phy: miphy365x: Add Device Tree bindings for the
 MiPHY365x
Message-ID: <20140519140752.GN4978@lee--X1>
References: <1398756095-32542-1-git-send-email-lee.jones@linaro.org>
 <1398756095-32542-2-git-send-email-lee.jones@linaro.org>
 <20140519135622.GL4978@lee--X1>
 <537A0E73.9080006@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <537A0E73.9080006@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Did you receive this set okay?  I believe it's still unmerged?
> 
> I think I missed it. But I'm already done with the PULL REQUEST to greg for
> 3.16 merge window.

Really, already? It's only -rc5?

> Can't we take it through dt tree for miphy?

Well there are 3 patches.  2 of which could go through your DT tree,
but the 3rd one is the driver itself.

> >> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> >> devices. It has 2 ports which it can use for either; both SATA, both
> >> PCIe or one of each in any configuration.
> >>
> >> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> >> Acked-by: Mark Rutland <mark.rutland@arm.com>
> >> Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
> >> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >> ---
> >>  .../devicetree/bindings/phy/phy-miphy365x.txt      | 62 ++++++++++++++++++++++
> >>  1 file changed, 62 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/phy/phy-miphy365x.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/phy/phy-miphy365x.txt b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
> >> new file mode 100644
> >> index 0000000..cb39de1
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
> >> @@ -0,0 +1,62 @@
> >> +STMicroelectronics STi MIPHY365x PHY binding
> >> +============================================
> >> +
> >> +This binding describes a miphy device that is used to control PHY hardware
> >> +for SATA and PCIe.
> >> +
> >> +Required properties:
> >> +- compatible :	Should be "st,miphy365x-phy"
> >> +- #phy-cells :	Should be 2 (See second example)
> >> +		First cell is the port number from:
> >> +			- MIPHY_PORT_0
> >> +			- MIPHY_PORT_1
> >> +		Second cell is device type from:
> >> +			- MIPHY_TYPE_SATA
> >> +			- MIPHY_TYPE_PCI
> >> +- reg       :	Address and length of register sets for each device in
> >> +		"reg-names"
> >> +- reg-names : 	The names of the register addresses corresponding to the
> >> +		registers filled in "reg", from:
> >> +			- sata0: For SATA port 0 registers
> >> +			- sata1: For SATA port 1 registers
> >> +			- pcie0: For PCIE port 0 registers
> >> +			- pcie1: For PCIE port 1 registers
> >> +- st,syscfg : 	Should be a phandle of the system configuration register group
> >> +		which contain the SATA, PCIe mode setting bits
> >> +
> >> +Optional properties:
> >> +- st,sata-gen	     :	Generation of locally attached SATA IP. Expected values
> >> +			are {1,2,3). If not supplied generation 1 hardware will
> >> +			be expected
> >> +- st,pcie-tx-pol-inv :	Bool property to invert the polarity PCIe Tx (Txn/Txp)
> >> +- st,sata-tx-pol-inv :	Bool property to invert the polarity SATA Tx (Txn/Txp)
> >> +
> >> +Example:
> >> +
> >> +	miphy365x_phy: miphy365x@fe382000 {
> >> +		compatible = "st,miphy365x-phy";
> >> +		#phy-cells = <2>;
> >> +		reg =	<0xfe382000 0x100>,
> >> +			<0xfe38a000 0x100>,
> >> +			<0xfe394000 0x100>,
> >> +			<0xfe804000 0x100>;
> >> +		reg-names = "sata0", "sata1", "pcie0", "pcie1";
> >> +		st,syscfg = <&syscfg_rear>;
> >> +	};
> >> +
> >> +Specifying phy control of devices
> >> +=================================
> >> +
> >> +Device nodes should specify the configuration required in their "phys"
> >> +property, containing a phandle to the miphy device node, a port number
> >> +and a device type.
> >> +
> >> +Example:
> >> +
> >> +#include <dt-bindings/phy/phy-miphy365x.h>
> >> +
> >> +	sata0: sata@fe380000 {
> >> +		...
> >> +		phys	  = <&miphy365x_phy MIPHY_PORT_0 MIPHY_TYPE_SATA>;
> >> +		...
> >> +	};
> > 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
