Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaI2Iw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:52:57 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:41290 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaI2Iwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:52:54 -0400
Message-ID: <54291DE2.2070404@atmel.com>
Date: Mon, 29 Sep 2014 10:52:50 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Olof Johansson <olof@lixom.net>, <arm@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: soc for 3.18 #2
References: <1411391733-28891-1-git-send-email-nicolas.ferre@atmel.com> <201409261250.02565.arnd@arndb.de> <54257C70.50008@atmel.com> <2546543.KtIvf3hIpW@wuerfel>
In-Reply-To: <2546543.KtIvf3hIpW@wuerfel>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/09/2014 20:55, Arnd Bergmann :
> On Friday 26 September 2014 16:47:12 Nicolas Ferre wrote:
>> On 26/09/2014 12:50, Arnd Bergmann :
>>> On Monday 22 September 2014, Nicolas Ferre wrote:
>>>
>>>> Nicolas Ferre (4):
>>>>       ARM: at91: introduce basic SAMA5D4 support
>>>>       ARM: at91: SAMA5D4 SoC detection code and low level routines
>>>
>>> This resulted in build failures both in at91x40_defconfig and some
>>> randconfigs with MMU disabled. I've applied the patch below on top
>>> to fix it.
>>
>> Ok, I see: sorry for the inconvenience.
>> What about taking the patch that I sent about removing completely the
>> at91x40 as it is "Acked" by everybody now? The would prevent from adding
>> these unneeded values.
> 
> I thought about that, but it would still be broken in randconfig builds
> that turn off the MMU on any of the other at91 variants, as I wrote above.

Okay, sorry, I overlooked this part.

> at91 is actually one of the platforms that I'd assume would even work in
> that configuration. We should at one point in the future discuss more
> widely whether we try to fix more of the bugs one hits with this or
> we just outright prevent users from turning off the MMU on platforms
> that have one.

Well, for the moment, it still makes sense to keep this possibility. So
your patch is perfectly fine for me, if needed:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Bye,

>>> I'm not exactly happy about the soc detection code anyway after I
>>> had to look at that. Why do you even hardcode the physical register
>>> location rather than getting it from DT?
>>>
>>> Also, why do you care about which SoC version you have for the
>>> modern SAMA5 chips? All I see is a sama5d4_map_io() callback
>>> that maps a lot of completely unused registers along with
>>> the uart that you normally get from the implicit debug_ll_io_init,
>>> and the SRAM that should probably be turned into a normal driver.
>>
>> Yes, as said by Alexandre, we are aware of the flaws of AT91 SoC
>> initialization, but last time I tried, our code was called too early.
>> Now with the work from Maxime with the timer (in 3.18) it might be
>> possible to reorder all this.
>> But please, I would really like to remove all !DT *and* !CCF material
>> before starting this work, otherwise we will again have a double path
>> for sam9's and I'd like to avoid this.
> 
> I'm not complaining about the use of the early registers on sam9, I know
> you are working hard on cleaning that up. I still don't see why you
> duplicate it for sama5, but it's ok as long as you have a plan.
> 
> 	Arnd
> 


-- 
Nicolas Ferre
