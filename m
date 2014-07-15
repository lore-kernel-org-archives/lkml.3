Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbaGOFqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 01:46:44 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41225 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279AbaGOFql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 01:46:41 -0400
Message-ID: <53C4BFF2.5080103@gmail.com>
Date: Tue, 15 Jul 2014 11:15:22 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Iyappan Subramanian <isubramanian@apm.com>, davem@davemloft.net,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com,
        Ravi Patel <rapatel@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Subject: Re: [PATCH v9 2/4] Documentation: dts: Add bindings for APM X-Gene
 SoC ethernet driver
References: <1405376285-23008-1-git-send-email-isubramanian@apm.com> <1405376285-23008-3-git-send-email-isubramanian@apm.com>
In-Reply-To: <1405376285-23008-3-git-send-email-isubramanian@apm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 03:48 AM, Iyappan Subramanian wrote:
> This patch adds documentation for APM X-Gene SoC ethernet DTS binding.
>
> Signed-off-by: Iyappan Subramanian <isubramanian@apm.com>
> Signed-off-by: Ravi Patel <rapatel@apm.com>
> Signed-off-by: Keyur Chudgar <kchudgar@apm.com>
> ---
>   .../devicetree/bindings/net/apm-xgene-enet.txt     | 72 ++++++++++++++++++++++
>   1 file changed, 72 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/net/apm-xgene-enet.txt
>
> diff --git a/Documentation/devicetree/bindings/net/apm-xgene-enet.txt b/Documentation/devicetree/bindings/net/apm-xgene-enet.txt
> new file mode 100644
> index 0000000..3e2a295
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/apm-xgene-enet.txt
> @@ -0,0 +1,72 @@
> +APM X-Gene SoC Ethernet nodes
> +
> +Ethernet nodes are defined to describe on-chip ethernet interfaces in
> +APM X-Gene SoC.
> +
> +Required properties:
> +- compatible:		Should be "apm,xgene-enet"
> +- reg: Address and length of the register set for the device. It contains the
> +       information of registers in the same order as described by reg-names
> +- reg-names: Should contain the register set names

These are not aligned properly...

Required properties:
- compatble		: Should be "apm,xgene-enet"
- reg			: Address and length of the register set for the device.
			  It contains the information of registers in the same order
			  as described by reg-names

.....

> +  "enet_csr":		Ethernet control and status register address space
> +  "ring_csr":		Descriptor ring control and status register address space
> +  "ring_cmd":		Descriptor ring command register address space
> +- interrupts:		Ethernet main interrupt
> +- clocks:		Reference to the clock entry.
> +- local-mac-address:	MAC address assigned to this device
> +- phy-connection-type:	Interface type between ethernet device and PHY device
> +- phy-handle:		Reference to a PHY node connected to this device
> +
> +- mdio: 		Device tree subnode with the following required
> +			properties:
> +
> +	- compatible: Must be "apm,xgene-mdio".
> +	- #address-cells: Must be <1>.
> +	- #size-cells: Must be <0>.
> +
> +	For the phy on the mdio bus, there must be a node with the following
> +	fields:
> +
> +	- compatible: PHY identifier.  Please refer ./phy.txt for the format.
> +	- reg: The ID number for the phy.
> +

alignment...  :-)

> +Optional properties:
> +- status		: Should be "ok" or "disabled" for enabled/disabled.
> +			  Default is "ok".
> +
> +
> +Example:
> +	menetclk: menetclk {
> +		compatible = "apm,xgene-device-clock";
> +		clock-output-names = "menetclk";
> +		status = "ok";
> +	};
> +
> +	menet: ethernet@17020000 {
> +		compatible = "apm,xgene-enet";
> +		status = "disabled";
> +		reg = <0x0 0x17020000 0x0 0xd100>,
> +		      <0x0 0X17030000 0x0 0X400>,
> +		      <0x0 0X10000000 0x0 0X200>;
> +		reg-names = "enet_csr", "ring_csr", "ring_cmd";
> +		interrupts = <0x0 0x3c 0x4>;
> +		clocks = <&menetclk 0>;
> +		local-mac-address = [00 01 73 00 00 01];
> +		phy-connection-type = "rgmii";
> +		phy-handle = <&menetphy>;
> +		mdio {
> +			compatible = "apm,xgene-mdio";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			menetphy: menetphy@3 {
> +				compatible = "ethernet-phy-id001c.c915";
> +				reg = <0x3>;
> +			};
> +
> +		};
> +	};
> +
> +/* Board-specific peripheral configurations */
> +&menet {
> +        status = "ok";
> +};


-- 
Regards,
Varka Bhadram.

