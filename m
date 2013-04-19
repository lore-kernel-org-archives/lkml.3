Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030920Ab3DSPFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 11:05:45 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:15996 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030601Ab3DSPFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:05:44 -0400
Message-ID: <51715D42.5040706@atmel.com>
Date: Fri, 19 Apr 2013 17:05:38 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>, <tanzilli@acmesystems.it>,
        <dgilbert@interlog.com>, <robertcnelson@gmail.com>
Subject: Re: [PATCH 1/5] ARM: at91: at91sam9x5 RTC is not compatible with
 at91rm9200 one
References: <cover.1366289869.git.nicolas.ferre@atmel.com> <864f10566b35864d469f6ff2913b9afaa0c69350.1366289869.git.nicolas.ferre@atmel.com> <51714C74.2030907@cogentembedded.com> <51714F47.5040006@atmel.com> <51715988.9060606@cogentembedded.com>
In-Reply-To: <51715988.9060606@cogentembedded.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 04:49 PM, Sergei Shtylyov :
> On 19-04-2013 18:05, Nicolas Ferre wrote:
> 
>>>> Due to a bug with RTC IMR, we cannot consider at91sam9x5 RTC compatible
>>>> with the previous one. Modify DT compatibility string, even if the
>>>> driver
>>>> is not yet modified to take it into account.
> 
>>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>>> ---
>>>>    arch/arm/boot/dts/at91sam9x5.dtsi | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
> 
>>>> diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi
>>>> b/arch/arm/boot/dts/at91sam9x5.dtsi
>>>> index a3d4464..58747f3 100644
>>>> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
>>>> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
>>>> @@ -564,7 +564,7 @@
>>>>                };
>>>>
>>>>                rtc@fffffeb0 {
>>>> -                compatible = "atmel,at91rm9200-rtc";
>>>> +                compatible = "atmel,at91sam9x5-rtc";
> 
>>>     Do not use wildcards in the "compatible" prop values (I guess 'x' is
>>> a wildcard).
> 
>> Well, it is for naming a series of hardware, not for giving a generic
>> name that could cover different hardware.
> 
>> In the sense of Atmel it is our way to call the at91sam9x5 series of
>> SoC: you will see that the code that covers these SoCs is always named
>> like this.
>> In fact, the hardware contained in these SoC cannot be different from
>> one flavor of the family to the other.
> 
>    Nevertheless, the wildcards shouldn't be used. Use the name of e.g.
> the first member of the family.

There is not "first" there is no "last" they are all the same from a
hardware perspective. The only difference is activation of peripherals.

So, no, we will not change this.

Cf:
find arch/arm/boot/dts/ | xargs grep compatible | grep at91sam9x5

Best regards,
-- 
Nicolas Ferre
