Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3KTP7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:59:40 -0500
Received: from 15.mo1.mail-out.ovh.net ([188.165.38.232]:45836 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751373Ab3KTP7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:59:37 -0500
Message-ID: <528CD9E4.7060501@overkiz.com>
Date: Wed, 20 Nov 2013 16:48:52 +0100
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
Subject: Re: [PATCH 3/9] ARM: at91/dt: add usb1 vbus and pullup pins
References: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com> <1377687881-10688-1-git-send-email-b.brezillon@overkiz.com> <20131120145730.GD14627@ns203013.ovh.net>
In-Reply-To: <20131120145730.GD14627@ns203013.ovh.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 15715592376665471148
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

On 20/11/2013 15:57, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 13:04 Wed 28 Aug     , Boris BREZILLON wrote:
>> Add vbus and pullup pinctrl definitions.
>> Request the vbus and pullup pins in usb1 node.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>   arch/arm/boot/dts/at91rm9200ek.dts |   15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/at91rm9200ek.dts b/arch/arm/boot/dts/at91rm9200ek.dts
>> index 37b0880..76f3e87 100644
>> --- a/arch/arm/boot/dts/at91rm9200ek.dts
>> +++ b/arch/arm/boot/dts/at91rm9200ek.dts
>> @@ -29,6 +29,18 @@
>>   
>>   	ahb {
>>   		apb {
>> +			pinctrl@fffff400 {
>> +				usb1 {
>> +					pinctrl_usb1_vbus: usb1_vbus-0 {
>> +						atmel,pins = <AT91_PIOD 4 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
>> +					};
> it's a gpio no-need

Okay, noted.

I thought I had to declare gpio configured pins in order to detect pin 
conflicts.
But after taking a closer look at the pinctrl core and at91 pinctrl 
driver, it seems this is automatically done
by means of the pinctrl_request_gpio function.


>> +
>> +					pinctrl_usb1_pullup: usb1_pullup-0 {
>> +						atmel,pins = <AT91_PIOD 5 AT91_PERIPH_GPIO AT91_PINCTRL_MULTI_DRIVE>;
>> +					};
> no-need multidrive

Then why is it configured with multi-drive option in the board file
( 
http://lxr.free-electrons.com/source/arch/arm/mach-at91/board-rm9200ek.c#L166) 
?

>> +				};
>> +			};
>> +
>>   			dbgu: serial@fffff200 {
>>   				status = "okay";
>>   			};
>> @@ -56,6 +68,9 @@
>>   
>>   			usb1: gadget@fffb0000 {
>>   				atmel,vbus-gpio = <&pioD 4 GPIO_ACTIVE_HIGH>;
>> +				pinctrl-names = "default";
>> +				pinctrl-0 = <&pinctrl_usb1_vbus
>> +					     &pinctrl_usb1_pullup>;
>>   				status = "okay";
>>   			};
>>   
>> -- 
>> 1.7.9.5
>>

