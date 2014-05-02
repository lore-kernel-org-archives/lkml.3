Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaEBNOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:14:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33469 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaEBNO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:14:29 -0400
Message-ID: <53639A0C.8070306@ti.com>
Date: Fri, 2 May 2014 09:13:48 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com> <53610663.7070305@ti.com> <20140501131210.CCC13C409DA@trevor.secretlab.ca> <5279118.J5305KQNjB@wuerfel>
In-Reply-To: <5279118.J5305KQNjB@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2014 05:58 AM, Arnd Bergmann wrote:
> On Thursday 01 May 2014 14:12:10 Grant Likely wrote:
>>>> I've got two concerns here. of_dma_get_range() retrieves only the first
>>>> tuple from the dma-ranges property, but it is perfectly valid for
>>>> dma-ranges to contain multiple tuples. How should we handle it if a
>>>> device has multiple ranges it can DMA from?
>>>>
>>>
>>> We've not found any cases in current Linux where more than one dma-ranges
>>> would be used. Moreover, The MM (definitely for ARM) isn't supported such
>>> cases at all (if i understand everything right).
>>> - there are only one arm_dma_pfn_limit
>>> - there is only one MM zone is used for ARM
>>> - some arches like x86,mips can support 2 zones (per arch - not per device or bus)
>>>   DMA & DMA32, but they configured once and forever per arch.
>>
>> Okay. If anyone ever does implement multiple ranges then this code will
>> need to be revisited.
> 
> I wonder if it's needed for platforms implementing the standard "ARM memory map" [1].
> The document only talks about addresses as seen from the CPU, and I can see
> two logical interpretations how the RAM is supposed to be visible from a device:
> either all RAM would be visible contiguously at DMA address zero, or everything
> would be visible at the same physical address as the CPU sees it.
> 
> If anyone picks the first interpretation, we will have to implement that
> in Linux. We can of course hope that all hardware designs follow the second
> interpretation, which would be more convenient for us here.
>
not sure if I got your point correctly but DMA address 0 isn't used as DRAM start in
any of the ARM SOC today, mainly because of the boot architecture where address 0 is
typically used by ROM code. RAM start will be at some offset always and hence I
believe ARM SOCs will follow second interpretation. This was one of the main reason
we ended up fixing the max*pfn stuff. 
26ba47b {ARM: 7805/1: mm: change max*pfn to include the physical offset of memory}

> 
> [1] http://infocenter.arm.com/help/topic/com.arm.doc.den0001c/DEN0001C_principles_of_arm_memory_maps.pdf
> 
 
Regards,
Santosh
