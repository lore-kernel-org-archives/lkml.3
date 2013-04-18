Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab3DRJBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:01:45 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:27033 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab3DRJBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:01:42 -0400
Message-ID: <516FB671.2030706@atmel.com>
Date: Thu, 18 Apr 2013 11:01:37 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: <dgilbert@interlog.com>
CC: <linux-arm-kernel@lists.infradead.org>, <jhovold@gmail.com>,
        <robertcnelson@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] ARM: at91: add Acme Systems Aria G25 board
References: <20130402184947.GA8015@quad.lixom.net> <1365090153-1807-1-git-send-email-nicolas.ferre@atmel.com> <515DB248.6070105@interlog.com>
In-Reply-To: <515DB248.6070105@interlog.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 07:03 PM, Douglas Gilbert :
> On 13-04-04 11:42 AM, Nicolas Ferre wrote:
>> From: Douglas Gilbert <dgilbert@interlog.com>
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>> Hi all,
>>
>> Here is the third revision of this patch. I plan to include it in a
>> pull-request real-soon-now!
>>
>> v3: - move to "at91-" prefix for .dts[i] files
>>      - remove the rtc activation code because of the ongoing discussions
>>        about this IP and its DT binding.
>>
> 
> Nicolas,
> It's a pity that the rtc activation code is removed.
> At worst:
>                         rtc@fffffeb0 {
>                                 status = "okay";
>                         };

I try to re-enalbe it when the at91sam9x5.dtsi exposes a compatibility
sting != at91rm9200-rtc

will soon appear on mailing-list.

> does nothing. Also it is unlikely to be changed by any
> movement on the rtc-at91rm9200 front.
> 
> 
> The lack of use of uart1 is for my own, private reasons.
> I think it would be more generally useful to show uart1's
> definition and disable it as shown in the attached patch
> fragment.

Well, if uart1 is available on Aria board, I should enable it! If you do
not want it on your own design, you must modify the .dts yourself. So I
plan to have an "okay" status on it (and move the definition itself to
the generic .dtsi).


> I also note that my date line was removed. I like dates,
> so when I add comments like "the i2c-at91 driver is broken
> for the SAM9G20 ** and use the i2c-gpio driver instead" then
> this is not taken as an eternal truth.

Yep, I see, but I try to cleanup the patch as much as I can. If you want
it untouched, provide me a standard formated patch.

> It worked in the
> past and hopefully it will work again in the future.
> 
> While on the subject of I2C, I'm getting tired of seeing
> this oft-copied line:
>    i2c-gpio,delay-us = <2>;        /* ~100 kHz */
> 
> It is the clock half period in microseconds and for the 100 kHz
> (standard) I2C clock speed, it should be 5. Due to rounding
> (up) that gives a measured clock speed of around 88 kHz on
> my equipment. Crappy I2C devices *** seem to cope better
> with 12% below the standard clock frequency than 80% above
> it.

Makes sense: I keep it in mind. In parallel, it can be interesting if
you can send me a patch with all these mistakes corrected ;-)

Bye,
-- 
Nicolas Ferre
