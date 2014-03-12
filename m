Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaCLLNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:13:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39365 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753519AbaCLLNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:13:45 -0400
Date: Wed, 12 Mar 2014 11:13:11 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] phy: miphy365x: Add Device Tree bindings for
 the MiPHY365x
Message-ID: <20140312111311.GF3263@e106331-lin.cambridge.arm.com>
References: <1392377036-12816-1-git-send-email-lee.jones@linaro.org>
 <20140310162254.GG13661@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140310162254.GG13661@lee--X1>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 04:22:54PM +0000, Lee Jones wrote:
> phy: miphy365x: Add Device Tree bindings for the MiPHY365x
> 
> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> devices. It has 2 ports which it can use for either; both SATA, both
> PCIe or one of each in any configuration.
> 
> Cc: devicetree@vger.kernel.org
> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

> 
> diff --git a/Documentation/devicetree/bindings/phy/phy-miphy365x.txt b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
> new file mode 100644
> index 0000000..15d105a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
> @@ -0,0 +1,62 @@
> +STMicroelectronics STi MIPHY365x PHY binding
> +============================================
> +
> +This binding describes a miphy device that is used to control PHY hardware
> +for SATA and PCIe.
> +
> +Required properties:
> +- compatible :	Should be "st,miphy365x-phy"
> +- #phy-cells :	Should be 2 (See second example)
> +		First cell is the port number from:
> +			- MIPHY_PORT_0
> +			- MIPHY_PORT_1
> +		Second cell is device type from:
> +			- MIPHY_TYPE_SATA
> +			- MIPHY_TYPE_PCI
> +- reg       :	Address and length of register sets for each device in
> +		"reg-names"
> +- reg-names : 	The names of the register addresses corresponding to the
> +		registers filled in "reg", from:
> +			- sata0: For SATA port 0 registers
> +			- sata1: For SATA port 1 registers
> +			- pcie0: For PCIE port 0 registers
> +			- pcie1: For PCIE port 1 registers
> +- st,syscfg : 	Should be a phandle of the system configuration register group
> +		which contain the SATA, PCIe mode setting bits
> +
> +Optional properties:
> +- st,sata-gen	     :	Generation of locally attached SATA IP. Expected values
> +			are {1,2,3). If not supplied generation 1 hardware will
> +			be expected
> +- st,pcie-tx-pol-inv :	Bool property to invert the polarity PCIe Tx (Txn/Txp)
> +- st,sata-tx-pol-inv :	Bool property to invert the polarity SATA Tx (Txn/Txp)
> +
> +Example:
> +
> +	miphy365x_phy: miphy365x@0 {

Please fix the unit-address to match the first reg entry.

Otherwise this looks fine. With that fixed:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> +		compatible = "st,miphy365x-phy";
> +		#phy-cells = <2>;
> +		reg =	<0xfe382000 0x100>,
> +			<0xfe38a000 0x100>,
> +			<0xfe394000 0x100>,
> +			<0xfe804000 0x100>;
> +		reg-names = "sata0", "sata1", "pcie0", "pcie1";
> +		st,syscfg = <&syscfg_rear>;
> +	};
> +
> +Specifying phy control of devices
> +=================================
> +
> +Device nodes should specify the configuration required in their "phys"
> +property, containing a phandle to the miphy device node, a port number
> +and a device type.
> +
> +Example:
> +
> +#include <dt-bindings/phy/phy-miphy365x.h>
> +
> +	sata0: sata@fe380000 {
> +		...
> +		phys	  = <&miphy365x_phy MIPHY_PORT_0 MIPHY_TYPE_SATA>;
> +		...
> +	};
> 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
> 
