Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3JJMtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 08:49:52 -0400
Received: from eu1sys200aog121.obsmtp.com ([207.126.144.151]:60672 "EHLO
	eu1sys200aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076Ab3JJMtv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 08:49:51 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Stephen GALLIMORE <stephen.gallimore@st.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Cc: Stuart MENEFY <stuart.menefy@st.com>, Lee Jones <lee.jones@linaro.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Date: Thu, 10 Oct 2013 14:49:45 +0200
Subject: Re: [PATCH v4 3/4] ARM: STi: Supply I2C configuration to STiH415 SoC
Thread-Topic: [PATCH v4 3/4] ARM: STi: Supply I2C configuration to STiH415
 SoC
Thread-Index: Ac7FtzJGqQ/QUIhWQs6vIHELX9KZqw==
Message-ID: <5256A269.9070809@st.com>
References: <1381250576-7916-1-git-send-email-maxime.coquelin@st.com>
 <1381250576-7916-4-git-send-email-maxime.coquelin@st.com>
 <A3BF01DB4A606149A4C20C4C4C808F6C5BC8A70D4E@SAFEX1MAIL1.st.com>
In-Reply-To: <A3BF01DB4A606149A4C20C4C4C808F6C5BC8A70D4E@SAFEX1MAIL1.st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/10/2013 02:33 PM, Stephen GALLIMORE wrote:
>> -----Original Message-----
>> From: Maxime COQUELIN [mailto:maxime.coquelin@st.com]
>> Sent: 08 October 2013 17:43
>> .....
>> +
>> +		i2c@fed40000 {
>> +			compatible	= "st,comms-ssc-i2c";
>> +			reg		= <0xfed40000 0x110>;
>> +			interrupts	=  <GIC_SPI 187 IRQ_TYPE_EDGE_RISING>;
> This should specify level (high) triggered, not edge triggered, for our
> SoC integrations.
>
> Note that level triggered is the default GIC setup and was therefore
> what was being used when you specified "0" for the flags previously.
Thanks Stephen.
As discussed this morning, I agree this should be high level triggered.

This will be fixed in next revision.

>
>> +			clocks		= <&CLKS_ICN_REG_0>;
>> +			clock-names	= "ssc";
>> +			clock-frequency = <400000>;
>> +			pinctrl-names	= "default";
>> +			pinctrl-0	= <&pinctrl_i2c0_default>;
>> +
>> +			status		= "disabled";
>> +		};
