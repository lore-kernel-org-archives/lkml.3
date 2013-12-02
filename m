Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3LBMrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:47:41 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:4920 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab3LBMri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:47:38 -0500
Message-ID: <529C8161.5050005@atmel.com>
Date: Mon, 2 Dec 2013 13:47:29 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: boris brezillon <b.brezillon@overkiz.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <jiri.prchal@aksignal.cz>
Subject: Re: [PATCH] ARM: at91: add usart3 alias to dtsi
References: <1385979186-29447-1-git-send-email-nicolas.ferre@atmel.com> <529C70C7.9050707@overkiz.com>
In-Reply-To: <529C70C7.9050707@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 12:36, boris brezillon :
> Hi Nicolas,
>
> Le 02/12/2013 11:13, Nicolas Ferre a écrit :
>> Alias was missing for SoC of the at91sam9x5 familly that embed USART3.
>> Preripheral node and pinctrl declarations are already in the
>> at91sam9x5_usart3.dtsi file.
>>
>> Reported-by: Jiri Prchal <jiri.prchal@aksignal.cz>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>    arch/arm/boot/dts/at91sam9g25.dtsi | 4 ++++
>>    arch/arm/boot/dts/at91sam9x25.dtsi | 4 ++++
>>    2 files changed, 8 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/at91sam9g25.dtsi b/arch/arm/boot/dts/at91sam9g25.dtsi
>> index 17b879990914..d4650b4e9ebb 100644
>> --- a/arch/arm/boot/dts/at91sam9g25.dtsi
>> +++ b/arch/arm/boot/dts/at91sam9g25.dtsi
>> @@ -14,6 +14,10 @@
>>    	model = "Atmel AT91SAM9G25 SoC";
>>    	compatible = "atmel,at91sam9g25", "atmel,at91sam9x5";
>>
>> +	aliases {
>> +		serial4 = &usart3;
>> +	};
>> +
>
> Shouldn't this go into at91sam9x5_usart3.dtsi ?
> This way you would have the same alias for all the SoCs supporting usart3.

Indeed, I was focused on the product itself but it definitively makes 
sense to move it in the at91sam9x5_usart3.dtsi

Thanks, bye,


>>    	ahb {
>>    		apb {
>>    			pinctrl@fffff400 {
>> diff --git a/arch/arm/boot/dts/at91sam9x25.dtsi b/arch/arm/boot/dts/at91sam9x25.dtsi
>> index c2554219f7a4..aceee86f60eb 100644
>> --- a/arch/arm/boot/dts/at91sam9x25.dtsi
>> +++ b/arch/arm/boot/dts/at91sam9x25.dtsi
>> @@ -15,6 +15,10 @@
>>    	model = "Atmel AT91SAM9X25 SoC";
>>    	compatible = "atmel,at91sam9x25", "atmel,at91sam9x5";
>>
>> +	aliases {
>> +		serial4 = &usart3;
>> +	};
>> +
>>    	ahb {
>>    		apb {
>>    			pinctrl@fffff400 {
>
>
>


-- 
Nicolas Ferre
