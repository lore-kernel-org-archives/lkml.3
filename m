Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaESOBC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:01:02 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41324 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaESOBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:01:00 -0400
Message-ID: <537A0E73.9080006@ti.com>
Date: Mon, 19 May 2014 19:30:19 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <kernel@stlinux.com>
Subject: Re: [PATCH 1/4] phy: miphy365x: Add Device Tree bindings for the
 MiPHY365x
References: <1398756095-32542-1-git-send-email-lee.jones@linaro.org> <1398756095-32542-2-git-send-email-lee.jones@linaro.org> <20140519135622.GL4978@lee--X1>
In-Reply-To: <20140519135622.GL4978@lee--X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 19 May 2014 07:26 PM, Lee Jones wrote:
> Kishon,
> 
> Did you receive this set okay?  I believe it's still unmerged?

I think I missed it. But I'm already done with the PULL REQUEST to greg for
3.16 merge window.

Can't we take it through dt tree for miphy?

Thanks
Kishon
> 
>> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
>> devices. It has 2 ports which it can use for either; both SATA, both
>> PCIe or one of each in any configuration.
>>
>> Cc: Kishon Vijay Abraham I <kishon@ti.com>
>> Acked-by: Mark Rutland <mark.rutland@arm.com>
>> Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> ---
>>  .../devicetree/bindings/phy/phy-miphy365x.txt      | 62 ++++++++++++++++++++++
>>  1 file changed, 62 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/phy/phy-miphy365x.txt
>>
>> diff --git a/Documentation/devicetree/bindings/phy/phy-miphy365x.txt b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
>> new file mode 100644
>> index 0000000..cb39de1
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
>> @@ -0,0 +1,62 @@
>> +STMicroelectronics STi MIPHY365x PHY binding
>> +============================================
>> +
>> +This binding describes a miphy device that is used to control PHY hardware
>> +for SATA and PCIe.
>> +
>> +Required properties:
>> +- compatible :	Should be "st,miphy365x-phy"
>> +- #phy-cells :	Should be 2 (See second example)
>> +		First cell is the port number from:
>> +			- MIPHY_PORT_0
>> +			- MIPHY_PORT_1
>> +		Second cell is device type from:
>> +			- MIPHY_TYPE_SATA
>> +			- MIPHY_TYPE_PCI
>> +- reg       :	Address and length of register sets for each device in
>> +		"reg-names"
>> +- reg-names : 	The names of the register addresses corresponding to the
>> +		registers filled in "reg", from:
>> +			- sata0: For SATA port 0 registers
>> +			- sata1: For SATA port 1 registers
>> +			- pcie0: For PCIE port 0 registers
>> +			- pcie1: For PCIE port 1 registers
>> +- st,syscfg : 	Should be a phandle of the system configuration register group
>> +		which contain the SATA, PCIe mode setting bits
>> +
>> +Optional properties:
>> +- st,sata-gen	     :	Generation of locally attached SATA IP. Expected values
>> +			are {1,2,3). If not supplied generation 1 hardware will
>> +			be expected
>> +- st,pcie-tx-pol-inv :	Bool property to invert the polarity PCIe Tx (Txn/Txp)
>> +- st,sata-tx-pol-inv :	Bool property to invert the polarity SATA Tx (Txn/Txp)
>> +
>> +Example:
>> +
>> +	miphy365x_phy: miphy365x@fe382000 {
>> +		compatible = "st,miphy365x-phy";
>> +		#phy-cells = <2>;
>> +		reg =	<0xfe382000 0x100>,
>> +			<0xfe38a000 0x100>,
>> +			<0xfe394000 0x100>,
>> +			<0xfe804000 0x100>;
>> +		reg-names = "sata0", "sata1", "pcie0", "pcie1";
>> +		st,syscfg = <&syscfg_rear>;
>> +	};
>> +
>> +Specifying phy control of devices
>> +=================================
>> +
>> +Device nodes should specify the configuration required in their "phys"
>> +property, containing a phandle to the miphy device node, a port number
>> +and a device type.
>> +
>> +Example:
>> +
>> +#include <dt-bindings/phy/phy-miphy365x.h>
>> +
>> +	sata0: sata@fe380000 {
>> +		...
>> +		phys	  = <&miphy365x_phy MIPHY_PORT_0 MIPHY_TYPE_SATA>;
>> +		...
>> +	};
> 
