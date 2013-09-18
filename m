Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab3IRMhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:37:01 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:34534 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495Ab3IRMg7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:36:59 -0400
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
Date: Wed, 18 Sep 2013 14:36:18 +0200
Subject: Re: [PATCH 4/4] ARM: STi: Add I2C config to B2000 and B2020 boards
Thread-Topic: [PATCH 4/4] ARM: STi: Add I2C config to B2000 and B2020 boards
Thread-Index: AQHOtGus0azG6iQMtUWKqhz0jWkKZg==
Message-ID: <84625B87D65BCF478CC1E9C886A4C314DEF1BD9576@SAFEX1MAIL4.st.com>
References: <1379498483-4236-1-git-send-email-maxime.coquelin@st.com>
 <1379498483-4236-5-git-send-email-maxime.coquelin@st.com>
 <20130918114032.GD16984@lee--X1>
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

Hi Lee,

On 09/18/2013 01:40 PM, Lee Jones wrote:
> On Wed, 18 Sep 2013, Maxime COQUELIN wrote:
>
>> This patch supplies I2C configuration to B2000 and B2020
>> based on either STiH415 or STiH416 SoCs.
>>
>> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
>> ---
>>  arch/arm/boot/dts/stih41x-b2000.dtsi |    7 +++++++
>>  arch/arm/boot/dts/stih41x-b2020.dtsi |   20 ++++++++++++++++++++
>>  2 files changed, 27 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/stih41x-b2000.dtsi b/arch/arm/boot/dts/stih41x-b2000.dtsi
>> index 8e694d2..346cc4bc 100644
>> --- a/arch/arm/boot/dts/stih41x-b2000.dtsi
>> +++ b/arch/arm/boot/dts/stih41x-b2000.dtsi
>> @@ -37,5 +37,12 @@
>>  			};
>>  		};
>>  
>> +		/* HDMI Tx I2C */
>> +		i2c1: i2c@fed41000{
> nit: Space before the '{'
Ok. It will be fixed for all nodes in next series.
>
>> +			status = "okay";
> Consider enabling the node at the bottom.
>
>> +
>> +			/* HDMI V1.3a supports Standard mode only */
>> +			clock-frequency = <100000>;
>> +		};
>>  	};
>>  };
>> diff --git a/arch/arm/boot/dts/stih41x-b2020.dtsi b/arch/arm/boot/dts/stih41x-b2020.dtsi
>> index 133e181..10b98da 100644
>> --- a/arch/arm/boot/dts/stih41x-b2020.dtsi
>> +++ b/arch/arm/boot/dts/stih41x-b2020.dtsi
>> @@ -38,5 +38,25 @@
>>  				default-state = "off";
>>  			};
>>  		};
>> +
>> +		i2c0: i2c@fed40000{
> As above.
>
>> +			status = "okay";
>> +		};
>> +
>> +		/* HDMI Tx I2C */
>> +		i2c1: i2c@fed41000{
> As above.
>
>> +			status = "okay";
> As above.
>
>> +			/* HDMI V1.3a supports Standard mode only */
>> +			clock-frequency = <100000>;
>> +		};
>> +
>> +		sbc_i2c0: i2c@fe540000{
> As above.
>
>> +			status = "okay";
>> +		};
>> +
>> +		sbc_i2c1: i2c@fe541000{
> Are these nodes referenced by phandle at all?
>
> If not, consider dropping the <lable>:s
It was references in an previous internal version of this series.
This is no more the case, so I will drop the labels.
>
>> +			status = "okay";
>> +		};
>>  	};
>>  };
> Odd tabbing here.
>
Thanks,
Maxime
