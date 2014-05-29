Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbaE2UFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 16:05:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50041 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbaE2UFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 16:05:31 -0400
Message-ID: <538792E1.3020500@ti.com>
Date: Thu, 29 May 2014 16:04:49 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com> <CACRpkdaD6ZLFu7-tOeDRvKCAC6X6_W84Vsqs1o-xUzUZOjyvFQ@mail.gmail.com> <53873F4A.9030303@ti.com> <4755790.VgRQTHz3K1@wuerfel>
In-Reply-To: <4755790.VgRQTHz3K1@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 May 2014 03:24 PM, Arnd Bergmann wrote:
> On Thursday 29 May 2014 10:08:10 Santosh Shilimkar wrote:
>> On Thursday 29 May 2014 10:01 AM, Linus Walleij wrote:
>>> On Wed, May 28, 2014 at 4:04 PM, Santosh Shilimkar
>>> <santosh.shilimkar@ti.com> wrote:
>>>> On Wednesday 28 May 2014 09:32 AM, Linus Walleij wrote:
>>>
>>>>>> I suspect what you want is
>>>>>>
>>>>>>         dma-ranges = <0x80000000 0 0x80000000>;
>>>>>>
>>>>>> to translate dma_addr_t 0x80000000-0xffffffff to phys_addr_t 0x0-0x7fffffff
>>>>>> rather than phys_addr_t 0x800000000-0x87fffffff.
>>>>>
>>>> Interesting. Where does the ROM address space resides on integrator then considering
>>>> address 0 is used for DMA.
>>>
>>> The ROM is at physical address 0x20000000, don't ask me
>>> why 
>>>
>>> The RAM is typically at 0x00000000-0x0fffffff, on up to four parallell
>>> tiles, i.e. up to four completely independent CPUs are booted off the
>>> same ROM and using a set of shared peripherals.
>>>
>> The reason I asked the question because most of the ARM SOC I came across
>> aren't using the RAM phys address 0 and thought was because of boot architecture
>> with ROM occupying that address with reset vector starting at address 0.
>>
>> That was one of the main reason we had description on max_*pfn on ARM w.r.t
>> to other acrhes.
>>
>> Will corner ARM guys to understand bit more about it in some conference 
> 
> If this is anything like the versatile express, the reason it works is probably
> because there is another microcontroller in the system that does the bootstrap
> and is able to load code into RAM before turning on the main CPU.
> 
That make sense now. Thanks for those extra bits.

Regards,
Santosh

