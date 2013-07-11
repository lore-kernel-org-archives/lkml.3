Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3GKBXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 21:23:36 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:8083 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab3GKBXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 21:23:33 -0400
Message-ID: <51DE07C0.7060304@atmel.com>
Date: Thu, 11 Jul 2013 09:17:52 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 1/3] arm: atmel: at91sam9n12: add pinctrl of TWI
References: <1373449869-5083-1-git-send-email-voice.shen@atmel.com> <1373449869-5083-2-git-send-email-voice.shen@atmel.com> <20130710143923.GH18012@ns203013.ovh.net>
In-Reply-To: <20130710143923.GH18012@ns203013.ovh.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi J,

On 7/10/2013 22:39, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 17:51 Wed 10 Jul     , Bo Shen wrote:
>> add pinctrl of TWI for at91sam9n12 SoC
>>
>> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>> ---
>>   arch/arm/boot/dts/at91sam9n12.dtsi |   20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
>> index bb7f564..3db62f6 100644
>> --- a/arch/arm/boot/dts/at91sam9n12.dtsi
>> +++ b/arch/arm/boot/dts/at91sam9n12.dtsi
>> @@ -291,6 +291,22 @@
>>   					};
>>   				};
>>
>> +				i2c0 {
>> +					pinctrl_i2c0: i2c0-0 {
>> +						atmel,pins =
>> +							<AT91_PIOA 30 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA30 periph A I2C0 data */
>> +							 AT91_PIOA 31 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PA31 periph A I2C0 clock */
>> +					};
>> +				};
>> +
>> +				i2c1 {
>> +					pinctrl_i2c1: i2c1-0 {
>> +						atmel,pins =
>> +							<AT91_PIOC 0 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC0 periph C I2C1 data */
>> +							 AT91_PIOC 1 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PC1 periph C I2C1 clock */
> drop  the comment as we use macro

Thanks, I will drop the comment.

>> +					};
>> +				};
>> +
>>   				tcb0 {
>>   					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
>>   						atmel,pins = <AT91_PIOA 24 AT91_PERIPH_A AT91_PINCTRL_NONE>;
>> @@ -471,6 +487,8 @@
>>   				dma-names = "tx", "rx";
>>   				#address-cells = <1>;
>>   				#size-cells = <0>;
>> +				pinctrl-names = "default";
>> +				pinctrl-0 = <&pinctrl_i2c0>;
>>   				status = "disabled";
>>   			};
>>
>> @@ -483,6 +501,8 @@
>>   				dma-names = "tx", "rx";
>>   				#address-cells = <1>;
>>   				#size-cells = <0>;
>> +				pinctrl-names = "default";
>> +				pinctrl-0 = <&pinctrl_i2c1>;
>>   				status = "disabled";
>>   			};
>>
>> --
>> 1.7.9.5
>>

Best Regards,
Bo Shen

