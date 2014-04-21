Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaDUPOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 11:14:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46715 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbaDUPOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 11:14:14 -0400
Message-ID: <535535A1.4020501@ti.com>
Date: Mon, 21 Apr 2014 11:13:37 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v2 0/7] of: setup dma parameters using dma-ranges and
 dma-coherent
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com> <CAL_JsqLogKfqHyw4zYBkPrYh=f6tVibtmX25oYB1Q2hO11Whcw@mail.gmail.com>
In-Reply-To: <CAL_JsqLogKfqHyw4zYBkPrYh=f6tVibtmX25oYB1Q2hO11Whcw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Monday 21 April 2014 10:37 AM, Rob Herring wrote:
> On Sat, Apr 19, 2014 at 9:32 AM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>> Here is an updated version of [2] based on discussion. Series introduces
>> support for setting up dma parameters based on device tree properties
>> like 'dma-ranges' and 'dma-coherent' and also update to ARM 32 bit port.
>> Earlier version of the same series is here [1].
>>
>> The 'dma-ranges' helps to take care of few DMAable system memory restrictions
>> by use of dma_pfn_offset which we maintain now per device. Arch code then
>> uses it for dma address translations for such cases. We update the
>> dma_pfn_offset accordingly during DT the device creation process.The
>> 'dma-coherent' property is used to setup arch's coherent dma_ops.
>>
>> After some off-list discussion with RMK and Arnd, I have now dropped the
>> controversial dma_mask setup code from the series which actually isn't blocking
>> me as such. Considering rest of the parts of the series are already aligned,
>> am hoping to get this version merged for 3.16 merge window.
> 
> Can you briefly describe what the h/w looks like in terms of addresses
> for the problem you are trying to solve? Something like: Cpu view of
> RAM is X to Y address, X corresponds to DMA address Z. Max DMA address
> is ?
> 
Let me try with say 8 GB RAM example

CPU view of memory : 0x0000 0008 0000 0000 to 0x0000 000a 0000 0000

>From above memory range, first 2 GB of memory has an alias 32 bit
view in the hardware. Hardware internally map the address issued within
that first 2 GB to same memory. 

DMA view of first 2 GB [ 0x0000 0008 0000 0000 to 0x0000 0008 7fff ffff]
is : 0x8000 0000 to 0xffff fffff.

Regards,
Santosh 


