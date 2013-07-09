Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3GINUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 09:20:42 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:49039 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3GINUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 09:20:38 -0400
Message-ID: <51DC0E26.7080508@atmel.com>
Date: Tue, 9 Jul 2013 15:20:38 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "Bo Shen" <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v3 3/7] Documentation: DT: update atmel SSC with DMA binding
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com> <1373372929-17800-1-git-send-email-richard.genoud@gmail.com> <1373372929-17800-4-git-send-email-richard.genoud@gmail.com> <CACQ1gAg8WQTaz4XkXJCH+-bNU_U3s_1pgmQYoQR3v-KHOzzBTA@mail.gmail.com>
In-Reply-To: <CACQ1gAg8WQTaz4XkXJCH+-bNU_U3s_1pgmQYoQR3v-KHOzzBTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2013 15:19, Richard Genoud :
> 2013/7/9 Richard Genoud <richard.genoud@gmail.com>:
>> As atmel-ssc can be used with DMA, the documentation should be updated.
>> Also, a configuration DMA example is given.
>>
>> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>> ---
>>   .../devicetree/bindings/misc/atmel-ssc.txt         |   24 ++++++++++++++++++--
>>   1 file changed, 22 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/misc/atmel-ssc.txt b/Documentation/devicetree/bindings/misc/atmel-ssc.txt
>> index 38e51ad..96958ca 100644
>> --- a/Documentation/devicetree/bindings/misc/atmel-ssc.txt
>> +++ b/Documentation/devicetree/bindings/misc/atmel-ssc.txt
>> @@ -6,10 +6,30 @@ Required properties:
>>          - atmel,at91sam9g45-ssc: support dma transfer
>>   - reg: Should contain SSC registers location and length
>>   - interrupts: Should contain SSC interrupt
>> +For dma transfer:
>> +- dmas: DMA specifier, consisting of a phandle to DMA controller node,
>> +  the memory interface and SSC DMA channel ID (for tx and rx).
>> +  See Documentation/devicetree/bindings/dma/atmel-dma.txt for details.
>> +- dma-names: Must be "tx", "rx".
>>
>> -Example:
>> +
>> +Examples:
>>   ssc0: ssc@fffbc000 {
>>          compatible = "atmel,at91rm9200-ssc";
>>          reg = <0xfffbc000 0x4000>;
>> -       interrupts = <14 4 5>;
>> +       interrupts = <14 IRQ_TYPE_LEVEL_HIGH 5>;
> maybe I should not use macro in the documentation (not sure if I should or not).

absolutely.

>>   };
>> +
>> +
>> +ssc0: ssc@f0010000 {
>> +      compatible = "atmel,at91sam9g45-ssc";
>> +      reg = <0xf0010000 0x4000>;
>> +      interrupts = <28 IRQ_TYPE_LEVEL_HIGH 5>;
>> +      dmas = <&dma0 1 AT91_DMA_CFG_PER_ID(13)>,
>> +            <&dma0 1 AT91_DMA_CFG_PER_ID(14)>;
> same here
>> +      dma-names = "tx", "rx";
>> +      pinctrl-names = "default";
>> +      pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
>> +      status = "disabled";
>> +};
>> +
>> --
>> 1.7.10.4
>>
>
>
>


-- 
Nicolas Ferre
