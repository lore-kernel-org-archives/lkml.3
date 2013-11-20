Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab3KTQA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:00:26 -0500
Received: from 4.mo1.mail-out.ovh.net ([46.105.76.26]:35278 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751373Ab3KTQAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:00:22 -0500
Message-ID: <528CDC75.1010404@overkiz.com>
Date: Wed, 20 Nov 2013 16:59:49 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/9] ARM: at91/dt: add rm9200 spi0 chip select pins definitions
References: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com> <1377687742-10618-1-git-send-email-b.brezillon@overkiz.com> <20131120145609.GC14627@ns203013.ovh.net>
In-Reply-To: <20131120145609.GC14627@ns203013.ovh.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 15899395536437278892
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

On 20/11/2013 15:56, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 13:02 Wed 28 Aug     , Boris BREZILLON wrote:
>> Add spi0 cs pinctrl pins definitions.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>   arch/arm/boot/dts/at91rm9200.dtsi |   20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/at91rm9200.dtsi b/arch/arm/boot/dts/at91rm9200.dtsi
>> index f770655..69b76c7 100644
>> --- a/arch/arm/boot/dts/at91rm9200.dtsi
>> +++ b/arch/arm/boot/dts/at91rm9200.dtsi
>> @@ -486,6 +486,26 @@
>>   							 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA1 periph A SPI0_MOSI pin */
>>   							 AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PA2 periph A SPI0_SPCK pin */
>>   					};
>> +
>> +					pinctrl_spi0_cs0: spi0_cs0-0 {
>> +						atmel,pins =
>> +							<AT91_PIOA 3 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PA3 periph A SPI0_NPCS0 pin */
>> +					};
>> +
>> +					pinctrl_spi0_cs1: spi0_cs1-0 {
>> +						atmel,pins =
>> +							<AT91_PIOA 4 AT91_PERIPH_GPIO AT91_PINCTRL_MULTI_DRIVE>;	/* PA4 GPIO SPI0_NPCS1 pin */
>> +					};
>> +
>> +					pinctrl_spi0_cs2: spi0_cs2-0 {
>> +						atmel,pins =
>> +							<AT91_PIOA 5 AT91_PERIPH_GPIO AT91_PINCTRL_MULTI_DRIVE>;	/* PA5 GPIO SPI0_NPCS2 pin */
>> +					};
>> +
>> +					pinctrl_spi0_cs3: spi0_cs3-0 {
>> +						atmel,pins =
>> +							<AT91_PIOA 6 AT91_PERIPH_GPIO AT91_PINCTRL_MULTI_DRIVE>;	/* PA6 GPIO SPI0_NPCS3 pin */
>> +					};
> nack the pin are not multidrive there is only one master
Right, this is a mistake.

But the pins should be configured as OUTPUT with HIGH level
(see 
http://lxr.free-electrons.com/source/arch/arm/mach-at91/at91rm9200_devices.c#L589).

>
> Best Regards,
> J.
>>   				};
>>   
>>   				pioA: gpio@fffff400 {
>> -- 
>> 1.7.9.5
>>

