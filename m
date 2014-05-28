Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaE1OFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:05:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42569 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaE1OFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:05:03 -0400
Message-ID: <5385ECE0.7040703@ti.com>
Date: Wed, 28 May 2014 10:04:16 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>
CC: Grant Likely <grant.likely@linaro.org>,
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
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>	<5840140.8yGnd4Ycx3@wuerfel>	<CACRpkdZjEVYgq7tKEfmZC0Fu4n=JuUues=pAAtquLahkex=pkA@mail.gmail.com>	<4960549.viM91iY2g2@wuerfel> <CACRpkda5x-fJWTN40ze17woMWuWoVbuhbNu5nkm1sFcdJchRfA@mail.gmail.com>
In-Reply-To: <CACRpkda5x-fJWTN40ze17woMWuWoVbuhbNu5nkm1sFcdJchRfA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 May 2014 09:32 AM, Linus Walleij wrote:
> On Wed, May 28, 2014 at 3:29 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Wednesday 28 May 2014 10:23:09 Linus Walleij wrote:
> 
>>>         model = "ARM Integrator/AP";
>>>         compatible = "arm,integrator-ap";
>>> +       dma-ranges = <0x80000000 0x8 0x00000000 0x80000000>;
>>>
>>>         aliases {
>>>                 arm,timer-primary = &timer2;
>>>
>>
>> It looks like you accidentally copied the ranges from keystone, even
>> though that has a 64-bit root bus and you only have 32-bit.
> 
> Nah it was no accident, just good old incompetence ;-)
> 
>> I suspect what you want is
>>
>>         dma-ranges = <0x80000000 0 0x80000000>;
>>
>> to translate dma_addr_t 0x80000000-0xffffffff to phys_addr_t 0x0-0x7fffffff
>> rather than phys_addr_t 0x800000000-0x87fffffff.
>
Interesting. Where does the ROM address space resides on integrator then considering
address 0 is used for DMA.
 
> Thanks, I'll fix up my patch.
> 
Feel free to add my ack after the fixup if you need one.

regards,
Santosh

