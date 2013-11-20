Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3KTQPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:15:43 -0500
Received: from mo1.mail-out.ovh.net ([178.32.228.1]:34152 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KTQPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:15:42 -0500
Message-ID: <528CDFFB.1020601@overkiz.com>
Date: Wed, 20 Nov 2013 17:14:51 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/9] ARM: at91/dt: add mmc0 slot0 support to at91rm9200ek
 board
References: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com> <1377687995-10758-1-git-send-email-b.brezillon@overkiz.com> <20131120145926.GE14627@ns203013.ovh.net>
In-Reply-To: <20131120145926.GE14627@ns203013.ovh.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 16153567438868019372
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/11/2013 15:59, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 13:06 Wed 28 Aug     , Boris BREZILLON wrote:
>> Add slot0 of mmc0 pinctrl pins definitions:
>>   - detect pin
>>   - write protect pin
>>   - enable slot0 pin: this pin is connected to an external switch which
>>     enable mmc0 slot0 or spi dataflash connected to cs3
>>
>> The mmc0 device is not enabled, as it depends on the choosen functionnality
>> (spi cs3 or mmc0 slot0).
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>   arch/arm/boot/dts/at91rm9200ek.dts |   35 +++++++++++++++++++++++++++++++++++
>>   1 file changed, 35 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/at91rm9200ek.dts b/arch/arm/boot/dts/at91rm9200ek.dts
>> index f2d6d79..2bad423 100644
>> --- a/arch/arm/boot/dts/at91rm9200ek.dts
>> +++ b/arch/arm/boot/dts/at91rm9200ek.dts
>> @@ -39,6 +39,23 @@
>>   						atmel,pins = <AT91_PIOD 5 AT91_PERIPH_GPIO AT91_PINCTRL_MULTI_DRIVE>;
>>   					};
>>   				};
>> +
>> +				mmc0 {
>> +					pinctrl_mmc0_slot0_detect: mmc0_slot0_detect-0 {
>> +						atmel,pins =
>> +							<AT91_PIOB 27 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
>> +					};
>> +
>> +					pinctrl_mmc0_slot0_write_protect: mmc0_slot0_write_protect-0 {
>> +						atmel,pins =
>> +							<AT91_PIOA 17 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP>;
>> +					};
>> +
>> +					pinctrl_mmc0_slot0_switch: mmc0_slot0_switch-0 {
>> +						atmel,pins =
>> +							<AT91_PIOB 22 AT91_PERIPH_GPIO (AT91_PINCTRL_OUTPUT | AT91_PINCTRL_OUTPUT_VAL(1))>;
>> +					};
> nack this is a regulator the pinctrl API is not done for gpio default value

I know this can be represented as a regulator, but looking at the 
datasheet, this looks more
like a switch than a regulator.

Anyway, why didn't you told me that when I proposed the OUTPUT support 
for at91 pinctrl driver ?
And BTW pinctrl OUTPUT config is already supported by some pinctrl drivers
( 
http://lxr.free-electrons.com/source/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt#L159).

>> +				};
>>   			};
>>   
>>   			dbgu: serial@fffff200 {
>> @@ -84,6 +101,24 @@
>>   					reg = <0>;
>>   				};
>>   			};
>> +
>> +			mmc0: mmc@fffb4000 {
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +				pinctrl-0 = <&pinctrl_mmc0_clk
>> +					     &pinctrl_mmc0_slot0_cmd_dat0
>> +					     &pinctrl_mmc0_slot0_dat1_3
>> +					     &pinctrl_mmc0_slot0_detect
>> +					     &pinctrl_mmc0_slot0_write_protect
>> +					     &pinctrl_mmc0_slot0_switch>;
>> +
>> +				slot0: slot@0 {
>> +					reg = <0>;
>> +					bus-width = <4>;
>> +					cd-gpios = <&pioB 27 GPIO_ACTIVE_HIGH>;
>> +					wp-gpios = <&pioA 17 GPIO_ACTIVE_HIGH>;
>> +				};
>> +			};
>>   		};
>>   
>>   		usb0: ohci@00300000 {
>> -- 
>> 1.7.9.5
>>

