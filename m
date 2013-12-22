Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab3LVSFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 13:05:53 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48057 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab3LVSFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 13:05:51 -0500
Message-ID: <52B729FD.7020507@kernel.org>
Date: Sun, 22 Dec 2013 18:05:49 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Rob Landley <rob@landley.net>
CC: Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org
Subject: Re: [PATCH] iio: at91: document ADC clock properties
References: <1387296973-7779-1-git-send-email-b.brezillon@overkiz.com> <52B316A9.1060407@atmel.com>
In-Reply-To: <52B316A9.1060407@atmel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/13 15:54, Nicolas Ferre wrote:
> On 17/12/2013 17:16, Boris BREZILLON :
>> Document the clock properties required by the at91 ADC driver.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Looks fine to me.  I'm just waiting on an ack from a device tree maintainer
(or the 3 weeks to pass so I can pick it up anyway ;)

> 
>> ---
>>  .../devicetree/bindings/arm/atmel-adc.txt          |    5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/atmel-adc.txt b/Documentation/devicetree/bindings/arm/atmel-adc.txt
>> index d106146..9a1175b 100644
>> --- a/Documentation/devicetree/bindings/arm/atmel-adc.txt
>> +++ b/Documentation/devicetree/bindings/arm/atmel-adc.txt
>> @@ -5,6 +5,9 @@ Required properties:
>>      <chip> can be "at91sam9260", "at91sam9g45" or "at91sam9x5"
>>    - reg: Should contain ADC registers location and length
>>    - interrupts: Should contain the IRQ line for the ADC
>> +  - clock-names: tuple listing input clock names.
>> +	Required elements: "adc_clk", "adc_op_clk".
>> +  - clocks: phandles to input clocks.
>>    - atmel,adc-channels-used: Bitmask of the channels muxed and enable for this
>>      device
>>    - atmel,adc-startup-time: Startup Time of the ADC in microseconds as
>> @@ -44,6 +47,8 @@ adc0: adc@fffb0000 {
>>  	compatible = "atmel,at91sam9260-adc";
>>  	reg = <0xfffb0000 0x100>;
>>  	interrupts = <20 4>;
>> +	clocks = <&adc_clk>, <&adc_op_clk>;
>> +	clock-names = "adc_clk", "adc_op_clk";
>>  	atmel,adc-channel-base = <0x30>;
>>  	atmel,adc-channels-used = <0xff>;
>>  	atmel,adc-drdy-mask = <0x10000>;
>>
> 
> 
