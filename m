Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbaEIPaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:30:46 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:58367 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172AbaEIPam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:30:42 -0400
Message-ID: <536CF49E.1050708@atmel.com>
Date: Fri, 9 May 2014 17:30:38 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Yang, Wenyou" <Wenyou.Yang@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: dts: at91-sama5d3_xplained: add the regulator device
 node
References: <1398054547-5834-1-git-send-email-wenyou.yang@atmel.com> <20140421095443.GA3461@piout.net> <20140421122205.GB3461@piout.net> <B256D81BAE5131468A838E5D7A24364180A876DA@penmbx01>
In-Reply-To: <B256D81BAE5131468A838E5D7A24364180A876DA@penmbx01>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/04/2014 03:37, Yang, Wenyou :
> Hi,
> 
>> -----Original Message-----
>> From: Alexandre Belloni [mailto:alexandre.belloni@free-electrons.com]
>> Sent: Monday, April 21, 2014 8:22 PM
>> To: Yang, Wenyou
>> Cc: devicetree@vger.kernel.org; Ferre, Nicolas; linux-
>> kernel@vger.kernel.org; robh+dt@kernel.org; broonie@kernel.org; linux-
>> arm-kernel@lists.infradead.org
>> Subject: Re: [PATCH] ARM: dts: at91-sama5d3_xplained: add the regulator
>> device node
>>
>> On 21/04/2014 at 11:54:43 +0200, Alexandre Belloni wrote :
>>> Hi,
>>>
>>> On 21/04/2014 at 12:29:07 +0800, Wenyou Yang wrote :
>>>> +
>>>> +						vddana_reg: LDO_REG2 {
>>>> +							regulator-name = "VDDANA";
>>>> +							regulator-min-microvolt =
>> <3300000>;
>>>> +							regulator-max-microvolt =
>> <3300000>;
>>>> +							regulator-always-on;
>>>
>>> I'm pretty sure that one is not always on as you actually have to
>>> configure it to get any voltage. Are you sure you want to set the
>>> regulator-always-on property here ?
>>>
>>
>> Just to clarify my though, wouldn't it be better to make the ADC driver
>> handle that regulator instead of using regulator-always-on ?
> Yes, you are right. 
> It should not use regulator-always-on property for this regulator.
> It is ADC driver and ISI driver to handle it(The ISI takes PCK for clock).

Hi Wenyou and Alexandre,

After talking to our system engineers, it not usual to avoid to power
the VDDANA rail. In fact it will prevent you to use all the pads that
are powered by VDDANA: PD20-PD31. Moreover, even if you do not activate
the ADC output on these lines you won't be able to use them as plain
GPIO... (Cf. package and pinout section of the datasheet).

As the ADVREF pin of the SoC is connected to the VDDANA on this board
(even if this default configuration can be modified with a soldering
iron), we have to note that we may consume a little bit more power.

But still, I would recommend to keep the "regulator-always-on" property
on this node. Do you agree and allow me to take your first revision of
the patch?


Bye,
-- 
Nicolas Ferre
