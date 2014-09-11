Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaIKGhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 02:37:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60567 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbaIKGhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 02:37:50 -0400
Message-ID: <54114339.5070404@ti.com>
Date: Thu, 11 Sep 2014 12:07:45 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ARM: dts: dra7: Add CPSW and MDIO module nodes
 for dra7
References: <1410356247-25925-1-git-send-email-mugunthanvnm@ti.com> <1410356247-25925-2-git-send-email-mugunthanvnm@ti.com> <5410573B.5010907@ti.com>
In-Reply-To: <5410573B.5010907@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2014 07:20 PM, Nishanth Menon wrote:
> On 09/10/2014 08:37 AM, Mugunthan V N wrote:
>> Add CPSW and MDIO related device tree data for DRA7XX and made as status
>> disabled. Phy-id, pinmux for active and sleep state needs to be added in
>> board dts files and enable the CPSW device.
>>
>> Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
>> ---
>>  arch/arm/boot/dts/dra7.dtsi | 59 +++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 59 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
>> index d678152..8d79321 100644
>> --- a/arch/arm/boot/dts/dra7.dtsi
>> +++ b/arch/arm/boot/dts/dra7.dtsi
>> @@ -34,6 +34,8 @@
>>  		serial3 = &uart4;
>>  		serial4 = &uart5;
>>  		serial5 = &uart6;
>> +		ethernet0 = &cpsw_emac0;
>> +		ethernet1 = &cpsw_emac1;
> 
> should this rather be in board dts?

This should be here as the MAC address is filled in uboot with ethernet0
and ethernet1, moving this to dts, the ordering of the ethernet can go
for toss when they have other ethernet devices other than cpsw.

> 
>>  	};
>>  
>>  	timer {
>> @@ -1262,6 +1264,63 @@
>>  			ti,irqs-skip = <10 133 139 140>;
>>  			ti,irqs-safe-map = <0>;
>>  		};
>> +
>> +		mac: ethernet@4a100000 {
>> +			compatible = "ti,cpsw";
>> +			ti,hwmods = "gmac";
>> +			cpdma_channels = <8>;
>> +			ale_entries = <1024>;
>> +			bd_ram_size = <0x2000>;
>> +			no_bd_ram = <0>;
>> +			rx_descs = <64>;
>> +			mac_control = <0x20>;
>> +			slaves = <2>;
>> +			active_slave = <0>;
>> +			cpts_clock_mult = <0x80000000>;
>> +			cpts_clock_shift = <29>;
>> +			reg = <0x48484000 0x1000
>> +			       0x48485200 0x2E00>;
>> +			#address-cells = <1>;
>> +			#size-cells = <1>;
>> +			/*
>> +			 * rx_thresh_pend
>> +			 * rx_pend
>> +			 * tx_pend
>> +			 * misc_pend
>> +			 */
>> +			interrupts = <GIC_SPI 334 IRQ_TYPE_LEVEL_HIGH>,
>> +				     <GIC_SPI 335 IRQ_TYPE_LEVEL_HIGH>,
>> +				     <GIC_SPI 336 IRQ_TYPE_LEVEL_HIGH>,
>> +				     <GIC_SPI 337 IRQ_TYPE_LEVEL_HIGH>;
>> +			ranges;
>> +			status = "disabled";
>> +
>> +			davinci_mdio: mdio@48485000 {
>> +				compatible = "ti,davinci_mdio";
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +				ti,hwmods = "davinci_mdio";
>> +				bus_freq = <1000000>;
>> +				reg = <0x48485000 0x100>;
>> +			};
>> +
>> +			cpsw_emac0: slave@48480200 {
>> +				/* Filled in by U-Boot */
>> +				mac-address = [ 00 00 00 00 00 00 ];
> 
> should be disabled? what about platforms that do not have both emac ports?

the mac node is already disabled, so platforms which doesn't have emac
should not enable this which in-turn emac node will be disabled.

Regards
Mugunthan V N
