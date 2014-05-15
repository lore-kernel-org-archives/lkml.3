Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaEOIuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:50:08 -0400
Received: from rhcavuit01.kulnet.kuleuven.be ([134.58.240.129]:39089 "EHLO
	cavuit01.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751658AbaEOIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:50:04 -0400
X-KULeuven-Envelope-From: bart.tanghe@thomasmore.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: 12B3B138043.A3174
X-KULeuven-Information: Katholieke Universiteit Leuven
Message-ID: <53747FB8.2090706@thomasmore.be>
Date: Thu, 15 May 2014 10:50:00 +0200
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From: Bart Tanghe <bart.tanghe@thomasmore.be>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: thierry.reding@gmail.com, michal.simek@xilinx.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        grant.likely@linaro.org, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [rfc]pwm: add xilinx pwm driver
References: <1400066773-14393-1-git-send-email-bart.tanghe@thomasmore.be> <4262573.aEBTd7FzV5@wuerfel>
In-Reply-To: <4262573.aEBTd7FzV5@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 09:23 AM, Arnd Bergmann wrote:
> On Wednesday 14 May 2014 13:26:13 Bart Tanghe wrote:
>> @@ -0,0 +1,20 @@
>> +Xilinx PWM controller
>> +
>> +Required properties:
>> +- compatible: should be "xlnx,pwm-xlnx"
>> +- add a clock source to the description
>> +
>> +Examples:
>> +
>> +               axi_timer_0: timer@42800000 {
>> +                       clock-frequency = <100000000>;
>> +                       clocks = <&clkc 15>;
>> +                       compatible = "xlnx,xlnx-pwm";
>> +                       reg = <0x42800000 0x10000>;
>> +                       xlnx,count-width = <0x20>;
>> +                       xlnx,gen0-assert = <0x1>;
>> +                       xlnx,gen1-assert = <0x1>;
>> +                       xlnx,one-timer-only = <0x0>;
>> +                       xlnx,trig0-assert = <0x1>;
>> +                       xlnx,trig1-assert = <0x1>;
>> +               } ;
>>
>
> It seems you are missing a mandatory "#pwm-cells" property.
> How is anybody supposed to use this?
>
> 	Arnd
>

I've added some additional information in the documentation



Xilinx PWM controller

This driver works together with the Xilinx Axi timer hardware core.
The core is available for the microblaze, powerpc and arm based Xilinx
platforms.

The axi timer core is implemented in the pl (programmable logic) of the
fpga. The amount is user defined. Each core has two timers and one pwm 
output.

After genereating the design and bitstream, you have to use the Xilinx 
device tree generator (git://git.xilinx.com/device-tree.git) to generate 
the dts file or the petalinux tools 
(http://www.xilinx.com/tools/petalinux-sdk.htm).

Within this dts file, you find the axi-timer and clock definitions.

		axi_timer_0: timer@42800000 {
			clock-frequency = <100000000>;
			compatible = "xlnx,axi-timer-2.0", "xlnx,xps-timer-1.00.a";
			reg = <0x42800000 0x10000>;
			xlnx,count-width = <0x20>;
			xlnx,gen0-assert = <0x1>;
			xlnx,gen1-assert = <0x1>;
			xlnx,one-timer-only = <0x0>;
			xlnx,trig0-assert = <0x1>;
			xlnx,trig1-assert = <0x1>;
		} ;

		...

ps7_slcr_0: ps7-slcr@f8000000 {
compatible = "xlnx,ps7-slcr-1.00.a", "xlnx,zynqslcr";
reg = <0xf8000000 0x1000>;
clocks {
	#address-cells = <1>;
	#size-cells = <0>;
	clkc: clkc {
		#clock-cells = <1>;
		clock-output-names = "armpll", "ddrpll", "iopll", "cpu_6or4x", 
"cpu_3or2x",
		"cpu_2x", "cpu_1x", "ddr2x", "ddr3x", "dci",
		"lqspi", "smc", "pcap", "gem0", "gem1",
		"fclk0", "fclk1", "fclk2", "fclk3", "can0",
		"can1", "sdio0", "sdio1", "uart0", "uart1",
		"spi0", "spi1", "dma", "usb0_aper", "usb1_aper",
		"gem0_aper", "gem1_aper", "sdio0_aper", "sdio1_aper", "spi0_aper",
		"spi1_aper", "can0_aper", "can1_aper", "i2c0_aper", "i2c1_aper",
		"uart0_aper", "uart1_aper", "gpio_aper", "lqspi_aper", "smc_aper",
		"swdt", "dbg_trc", "dbg_apb";
	compatible = "xlnx,ps7-clkc";
	fclk-enable = <0xf>;
	ps-clk-frequency = <33333333>;
	} ;
} ;
} ;

Some required properties should be changed
- compatible: should be "xlnx,pwm-xlnx"
- add the right clock source to the description - clocks = <&clkc 15>; 
fclk0 in this design
- add #pwm-cells = <1>;

Examples:

		axi_timer_0: timer@42800000 {
			clock-frequency = <100000000>;
			#pwm-cells = <1>;
			clocks = <&clkc 15>;
			compatible = "xlnx,xlnx-pwm";
			reg = <0x42800000 0x10000>;
			xlnx,count-width = <0x20>;
			xlnx,gen0-assert = <0x1>;
			xlnx,gen1-assert = <0x1>;
			xlnx,one-timer-only = <0x0>;
			xlnx,trig0-assert = <0x1>;
			xlnx,trig1-assert = <0x1>;
		} ;

Generate the dtb file and load it on the target platform.

