Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab3IRMjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:39:00 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:57052 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359Ab3IRMi6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:38:58 -0400
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
Date: Wed, 18 Sep 2013 14:38:21 +0200
Subject: Re: [PATCH 3/4] ARM: STi: Supply I2C configuration to STiH415 SoC
Thread-Topic: [PATCH 3/4] ARM: STi: Supply I2C configuration to STiH415 SoC
Thread-Index: AQHOtGv1Mms0PeajT0iQkzN5gRBeNA==
Message-ID: <84625B87D65BCF478CC1E9C886A4C314DEF1BD9577@SAFEX1MAIL4.st.com>
References: <1379498483-4236-1-git-send-email-maxime.coquelin@st.com>
 <1379498483-4236-4-git-send-email-maxime.coquelin@st.com>
 <20130918120012.GE16984@lee--X1>
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

On 09/18/2013 02:00 PM, Lee Jones wrote:
> On Wed, 18 Sep 2013, Maxime COQUELIN wrote:
>
>> This patch supplies I2C configuration to STiH415 SoC.
>>
>> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
>> ---
>>  arch/arm/boot/dts/stih415-pinctrl.dtsi |   36 ++++++++++++++++++++
>>  arch/arm/boot/dts/stih415.dtsi         |   57 ++++++++++++++++++++++++++++++++
>>  2 files changed, 93 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/stih415-pinctrl.dtsi b/arch/arm/boot/dts/stih415-pinctrl.dtsi
>> index 1d322b2..e56449d 100644
>> --- a/arch/arm/boot/dts/stih415-pinctrl.dtsi
>> +++ b/arch/arm/boot/dts/stih415-pinctrl.dtsi
>> @@ -86,6 +86,24 @@
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
>> @@ -143,6 +161,24 @@
>>  				reg		= <0x7000 0x100>;
>>  				st,bank-name	= "PIO12";
>>  			};
>> +
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
>> diff --git a/arch/arm/boot/dts/stih415.dtsi b/arch/arm/boot/dts/stih415.dtsi
>> index 74ab8de..643ae1c 100644
>> --- a/arch/arm/boot/dts/stih415.dtsi
>> +++ b/arch/arm/boot/dts/stih415.dtsi
>> @@ -9,6 +9,7 @@
>>  #include "stih41x.dtsi"
>>  #include "stih415-clock.dtsi"
>>  #include "stih415-pinctrl.dtsi"
>> +#include <dt-bindings/interrupt-controller/arm-gic.h>
>>  / {
>>  
>>  	L2: cache-controller {
>> @@ -83,5 +84,61 @@
>>  			pinctrl-names 	= "default";
>>  			pinctrl-0	= <&pinctrl_sbc_serial1>;
>>  		};
>> +
>> +		i2c0: i2c@fed40000{
> Space before the '{'.
It will be fixed in next series
>
>> +			compatible	= "st,comms-i2c";
>> +			status		= "disabled";
> Consider putting the node status at the bottom.
Ok.
>
>> +			reg		= <0xfed40000 0x110>;
>> +			interrupts	=  <GIC_SPI 187 IRQ_TYPE_EDGE_RISING>;
>> +			clocks		= <&CLKS_ICN_REG_0>;
>> +			clock-frequency = <400000>;
>> +			pinctrl-names	= "default";
>> +			pinctrl-0	= <&pinctrl_i2c0_default>;
>> +			st,glitches;
>> +			st,glitch-clk	= <500>;
>> +			st,glitch-dat	= <500>;
>> +		};
>> +
>> +		i2c1: i2c@fed41000{
> Same here and throughout.
Ok.
>
>> +			compatible	= "st,comms-i2c";
>> +			status		= "disabled";
> Same here and throughout.
Ok.
>
>> +			reg		= <0xfed41000 0x110>;
>> +			interrupts	=  <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
>> +			clocks		= <&CLKS_ICN_REG_0>;
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
> Is this odd tabbing just the result of the patch format?
This is just the result of the patch format.

Regards,
Maxime

