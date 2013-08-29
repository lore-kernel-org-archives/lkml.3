Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab3H2CyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 22:54:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35215 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab3H2Cx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 22:53:58 -0400
Message-ID: <521EB7A8.3000603@ti.com>
Date: Thu, 29 Aug 2013 08:23:28 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: <balbi@ti.com>, <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob@landley.net>, <ian.campbell@citrix.com>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <bcousson@baylibre.com>,
        <davidb@codeaurora.org>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <popcornmix@gmail.com>
Subject: Re: [PATCH v3 3/3] ARM: dts: dra7-evm: Add extcon nodes for USB ID
 pin detection
References: <1377711185-31238-1-git-send-email-george.cherian@ti.com> <1377711185-31238-4-git-send-email-george.cherian@ti.com> <521E394C.3040402@cogentembedded.com>
In-Reply-To: <521E394C.3040402@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/2013 11:24 PM, Sergei Shtylyov wrote:
> On 08/28/2013 09:33 PM, George Cherian wrote:
>
>> Add
>>     -extcon nodes for USB ID pin detection.
>>     -i2c nodes.
>>     -pcf nodes to which USB ID pin is connected.
>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> ---
>>   arch/arm/boot/dts/dra7-evm.dts | 50 
>> +++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 49 insertions(+), 1 deletion(-)
>
>> diff --git a/arch/arm/boot/dts/dra7-evm.dts 
>> b/arch/arm/boot/dts/dra7-evm.dts
>> index acd3c09..8b0738a 100644
>> --- a/arch/arm/boot/dts/dra7-evm.dts
>> +++ b/arch/arm/boot/dts/dra7-evm.dts
> [...]
>> @@ -33,10 +44,47 @@
>>           };
>>   };
>>
>> +&i2c1 {
>> +    clock-frequency = <400000>;
>> +
>> +    gpio20: pcf8575@20 {
>
>     ePAPR was talking about the node naming, not about labelling. Back 
> to the drawing board. ;-)
>
ha..... :-/
>> +        compatible = "ti,pcf8575";
>> +        reg = <0x20>;
>> +        n_latch = <0x4000>;
>> +        gpio-controller;
>> +        #gpio-cells = <2>;
>> +        interrupt-parent = <&gpio6>;
>> +        interrupts = <11 2>;
>> +        interrupt-controller;
>> +        #interrupt-cells = <2>;
>> +    };
>> +
>> +    gpio21: pcf8575@21 {
>> +        compatible = "ti,pcf8575";
>> +        reg = <0x21>;
>> +        n_latch = <0x1408>;
>> +        gpio-controller;
>> +        #gpio-cells = <2>;
>> +        interrupt-parent = <&pcf_20>;
>> +        interrupts = <14 2>;
>> +        interrupt-controller;
>> +        #interrupt-cells = <2>;
>> +    };
>> +
>> +};
>> +
>
> WBR, Sergei
>


-- 
-George

