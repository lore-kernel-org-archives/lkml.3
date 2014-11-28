Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaK1JgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:36:21 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:2617 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaK1JgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:36:18 -0500
Message-ID: <54784209.6070003@atmel.com>
Date: Fri, 28 Nov 2014 10:36:09 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 00/11] ARM: at91: remove !DT support for at91rm9200
References: <cover.1417103399.git.nicolas.ferre@atmel.com> <3550407.q87bWB4Jdt@wuerfel> <20141127171243.GL4508@piout.net> <27354361.uIQEXGDqXb@wuerfel>
In-Reply-To: <27354361.uIQEXGDqXb@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/11/2014 18:38, Arnd Bergmann wrote:
> On Thursday 27 November 2014 18:12:43 Alexandre Belloni wrote:
>> On 27/11/2014 at 17:49:50 +0100, Arnd Bergmann wrote :
>>> On Thursday 27 November 2014 17:06:28 Nicolas Ferre wrote:
>>>> This is the last series of patches that removes the non-Device-Tree board
>>>> support for older Atmel SoCs.
>>>> Again, for the record, it was announced here
>>>> https://lkml.org/lkml/2014/9/10/293 ([ANNOUNCE] ARM: at91: removal of board
>>>> files) two months ago.
>>>> Several files beyond at91rm9200 are touched this time as I tried to remove the
>>>> biggest parts that were related to !DT SoC initializations. More cleanup is
>>>> certainly needed to remove dead code.
>>>>
>>>> The diffstat is also pretty big as a lot of at91rm9200 boards were remaining.
>>>>
>>>
>>> Awesome stuff!
>>>
>>> Two questions:
>>>
>>> - is anything holding this up from getting merged in 3.19?
>>>
>>
>> If you think this is not too late in the cycle, I would say go ahead 
> 
> I'd say we should do it, unless there are last-minute regressions.

Arnd,

I am totally in favor for a merge into 3.19.
I wanted to wait one day or two but given that the official announce had
been made several months ago, I don't think it makes a big difference.

So, what do you prefer:

1/ I wait today and send you the pull-request this evening (our time)
2/ I send you the pull-request at the beginning of next week but still
can make it for 3.19?

(BTW, in the meantime, there is a pending pull-request (at91-cleanup3)
but it is true that you needn't pulling it in if you plan to take this
one which will be named at91-cleanup4 and that will obviously contain
the 3rd one).

>>> - Are there any remaining issues that keep us from using multiplatform?
>>>   I know you all have been working on those a lot, but I haven't
>>>   checked what is still missing.
>>>
>>
>> As discussed some weeks ago, I prepared patches to switch sama5d[3-4] to
>> multiplatform. We are still missing the SMC and matrix drivers to switch
>> sam9 and rm9200.
>>
>> The currently affected drivers are:
>>  - drivers/ata/pata_at91.c (SMC)
>>  - drivers/pcmcia/at91_cf.c (SMC)
>>  - drivers/usb/gadget/udc/at91_udc.c (Matrix, this is the only one
>>    for sam9)
>>  - sound/atmel/ac97c.c (that one is still not converted to DT anyway...)
>>  - drivers/watchdog/at91rm9200_wdt.c (WIP, will be converted properly to
>>    an MFD)
>>
>> I'll resume working on that in December.
> 
> Ok, sounds great.
> 
>> Do you want me to submit the sama5d[3-4] switch for 3.19? I'll have to
>> rebase on that series. The main remaining issue is that I couldn't work
>> out a way not breaking the defconfigs, even after talking with the
>> Kconfig maintainer so doing first sama5 then sam9/rm9200 will break the
>> defconfigs for sam9/rm9200 twice.
> 
> Probably better to do all of mach-at91 at once for 3.20 so we don't break
> anything trying to make both aproaches work together.

Ok, let's schedule it for 3.20.

Bye,
-- 
Nicolas Ferre
