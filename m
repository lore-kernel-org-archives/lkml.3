Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab3IRMqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:46:48 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:52799 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136Ab3IRMqq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:46:46 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Stephen GALLIMORE <stephen.gallimore@st.com>,
        Stuart MENEFY <stuart.menefy@st.com>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Olivier CLERGEAUD <olivier.clergeaud@st.com>
Date: Wed, 18 Sep 2013 14:46:01 +0200
Subject: Re: [PATCH 2/4] ARM: STi: Supply I2C configuration to STiH416 SoC
Thread-Topic: [PATCH 2/4] ARM: STi: Supply I2C configuration to STiH416 SoC
Thread-Index: AQHOtG0HDpIcYt7pI0S7BVdPmPC7bQ==
Message-ID: <84625B87D65BCF478CC1E9C886A4C314DEF1BD9578@SAFEX1MAIL4.st.com>
References: <1379498483-4236-1-git-send-email-maxime.coquelin@st.com>
 <1379498483-4236-3-git-send-email-maxime.coquelin@st.com>
 <20130918120340.GF16984@lee--X1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 02:03 PM, Lee Jones wrote:
>> This patch supplies I2C configuration to STiH416 SoC.
>>
>> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
>> ---
>>  arch/arm/boot/dts/stih416-pinctrl.dtsi |   35 ++++++++++++++++++++
>>  arch/arm/boot/dts/stih416.dtsi         |   57 ++++++++++++++++++++++++++++++++
>>  2 files changed, 92 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
> I genuinely don't know the answer to this question, but are these
> nodes identical to the ones you've just put in the stih415 DTSI file?
> If so, I think it will be worth creating a stih41x DTSI rather than
> duplicating lots of stuff unnecessarily.
There are close to be identical indeed.
For the clocks and pinctrl, the references names are the same, but they are
pointing on different nodes, as STiH415 and STiH416 have their own
clocks and pinctrl dtsi files.

Srini, what is opinion about this?
>
>> index 0f246c9..b29ff4b 100644
>> --- a/arch/arm/boot/dts/stih416-pinctrl.dtsi
>> +++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
>> @@ -97,6 +97,24 @@
>>  					};
>>  				};
>>  			};
>> +
>> +			sbc_i2c0 {
>> +				pinctrl_sbc_i2c0_default: sbc_i2c0-default {
>> +					st,pins {
>> +						sda = <&PIO4 6 ALT1 BIDIR>;
>> +						scl = <&PIO4 5 ALT1 BIDIR>;
>> +					};
>> +				};
>> +			};
>> +
>> +			sbc_i2c1 {
>> +				pinctrl_sbc_i2c1_default: sbc_i2c1-default {
>> +					st,pins {
>> +						sda = <&PIO3 2 ALT2 BIDIR>;
>> +						scl = <&PIO3 1 ALT2 BIDIR>;
>> +					};
>> +				};
>> +			};
>>  		};
>>  
>>  		pin-controller-front {
>> @@ -175,6 +193,23 @@
>>  				};
>>  			};
>>  
>> +			i2c0 {
>> +				pinctrl_i2c0_default: i2c0-default {
>> +					st,pins {
>> +						sda = <&PIO9 3 ALT1 BIDIR>;
>> +						scl = <&PIO9 2 ALT1 BIDIR>;
>> +					};
>> +				};
>> +			};
>> +
>> +			i2c1 {
>> +				pinctrl_i2c1_default: i2c1-default {
>> +					st,pins {
>> +						sda = <&PIO12 1 ALT1 BIDIR>;
>> +						scl = <&PIO12 0 ALT1 BIDIR>;
>> +					};
>> +				};
>> +			};
>>  		};
>>  
>>  		pin-controller-rear {
>> diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
>> index 1a0326e..8856470 100644
>> --- a/arch/arm/boot/dts/stih416.dtsi
>> +++ b/arch/arm/boot/dts/stih416.dtsi
>> @@ -9,6 +9,7 @@
>>  #include "stih41x.dtsi"
>>  #include "stih416-clock.dtsi"
>>  #include "stih416-pinctrl.dtsi"
>> +#include <dt-bindings/interrupt-controller/arm-gic.h>
>>  / {
>>  	L2: cache-controller {
>>  		compatible = "arm,pl310-cache";
>> @@ -92,5 +93,61 @@
>>  			pinctrl-0 	= <&pinctrl_sbc_serial1>;
>>  			clocks          = <&CLK_SYSIN>;
>>  		};
>> +
>> +		i2c0: i2c@fed40000{
> Same issues here. I assume most of this is copy paste.
Yes indeed. This will be fixed in next version.
>
>> +			compatible	= "st,comms-i2c";
>> +			status		= "disabled";
>> +			reg		= <0xfed40000 0x110>;
>> +			interrupts	=  <GIC_SPI 187 IRQ_TYPE_EDGE_RISING>;
>> +			clocks		= <&CLK_S_ICN_REG_0>;
>> +			clock-frequency = <400000>;
>> +			pinctrl-names	= "default";
>> +			pinctrl-0	= <&pinctrl_i2c0_default>;
>> +			st,glitches;
>> +			st,glitch-clk	= <500>;
>> +			st,glitch-dat	= <500>;
>> +		};
>> +
>> +		i2c1: i2c@fed41000{
>> +			compatible	= "st,comms-i2c";
>> +			status		= "disabled";
>> +			reg		= <0xfed41000 0x110>;
>> +			interrupts	=  <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
>> +			clocks		= <&CLK_S_ICN_REG_0>;
>> +			clock-frequency = <400000>;
>> +			pinctrl-names	= "default";
>> +			pinctrl-0	= <&pinctrl_i2c1_default>;
>> +			st,glitches;
>> +			st,glitch-clk	= <500>;
>> +			st,glitch-dat	= <500>;
>> +		};
>> +
>> +		sbc_i2c0: i2c@fe540000{
>> +			compatible	= "st,comms-i2c";
>> +			status		= "disabled";
>> +			reg		= <0xfe540000 0x110>;
>> +			interrupts	=  <GIC_SPI 206 IRQ_TYPE_EDGE_RISING>;
>> +			clocks		= <&CLK_SYSIN>;
>> +			clock-frequency = <400000>;
>> +			pinctrl-names	= "default";
>> +			pinctrl-0	= <&pinctrl_sbc_i2c0_default>;
>> +			st,glitches;
>> +			st,glitch-clk	= <500>;
>> +			st,glitch-dat	= <500>;
>> +		};
>> +
>> +		sbc_i2c1: i2c@fe541000{
>> +			compatible	= "st,comms-i2c";
>> +			status		= "disabled";
>> +			reg		= <0xfe541000 0x110>;
>> +			interrupts	=  <GIC_SPI 207 IRQ_TYPE_EDGE_RISING>;
>> +			clocks		= <&CLK_SYSIN>;
>> +			clock-frequency = <400000>;
>> +			pinctrl-names	= "default";
>> +			pinctrl-0	= <&pinctrl_sbc_i2c1_default>;
>> +			st,glitches;
>> +			st,glitch-clk	= <500>;
>> +			st,glitch-dat	= <500>;
>> +		};
>>  	};
>>  };
Thanks,
Maxime

