Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbaJ2TCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:02:37 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:40411 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbaJ2TCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:02:36 -0400
Message-ID: <545139F0.4060409@gmail.com>
Date: Wed, 29 Oct 2014 12:03:12 -0700
From: Santosh Shilimkar <santosh.shilimkar@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
CC: Santosh Shilimkar <ssantosh@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org
Subject: Re: [PATCH v1 3/4] ARM: dts: keystone: add DT bindings for PCI controller
 for port 0
References: <1414601134-31825-1-git-send-email-m-karicheri2@ti.com> <1414601134-31825-4-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1414601134-31825-4-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 09:45 AM, Murali Karicheri wrote:
> Add common DT bindings to support PCI controller driver for port 0 on all of
> the K2 SoCs that has Synopsis Designware based pcie h/w.
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> CC: Santosh Shilimkar <ssantosh@kernel.org>
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Pawel Moll <pawel.moll@arm.com>
> CC: Mark Rutland <mark.rutland@arm.com>
> CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
> CC: Kumar Gala <galak@codeaurora.org>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: devicetree@vger.kernel.org
> ---
>   v1 - fixed email ID for Santosh and reworded the commit description a bit to
>        be consistent with the subject.
>   arch/arm/boot/dts/keystone.dtsi |   45 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 45 insertions(+)
>
> diff --git a/arch/arm/boot/dts/keystone.dtsi b/arch/arm/boot/dts/keystone.dtsi
> index 5d3e83f..87b2daa 100644
> --- a/arch/arm/boot/dts/keystone.dtsi
> +++ b/arch/arm/boot/dts/keystone.dtsi
> @@ -285,5 +285,50 @@
>   			#interrupt-cells = <1>;
>   			ti,syscon-dev = <&devctrl 0x2a0>;
>   		};
> +
> +		pcie@21800000 {
> +			compatible = "ti,keystone-pcie", "snps,dw-pcie";
> +			clocks = <&clkpcie>;
> +			clock-names = "pcie";
> +			#address-cells = <3>;
> +			#size-cells = <2>;
> +			reg =  <0x21801000 0x2000>, <0x21800000 0x1000>, <0x02620128 4>;
> +			ranges = <0x81000000 0 0 0x23250000 0 0x4000
> +				0x82000000 0 0x50000000 0x50000000 0 0x10000000>;
> +
> +			device_type = "pci";
> +			num-lanes = <2>;
> +
> +			#interrupt-cells = <1>;
> +			interrupt-map-mask = <0 0 0 7>;
> +			interrupt-map = <0 0 0 1 &pcie_intc0 0>, // INT A
> +					<0 0 0 2 &pcie_intc0 1>, // INT B
> +					<0 0 0 3 &pcie_intc0 2>, // INT C
> +					<0 0 0 4 &pcie_intc0 3>; // INT D
> +
Can you just keep the comments under /* ... * / just to be consistent
across file. Rest of the patch looks fine by me.

Regards,
Santosh
