Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaA1Sgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:36:51 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:55080 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbaA1Sgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:36:49 -0500
Message-ID: <52E7F8AC.9090909@ti.com>
Date: Tue, 28 Jan 2014 13:36:28 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Yinghai Lu <yinghai@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: Re: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org> <1390590670-25901-4-git-send-email-yinghai@kernel.org> <CAOesGMh7+SzLTfyPomnB_Q_wft+RC+F3tx-Ow1TdSmHiSwrKcw@mail.gmail.com> <CAGa+x87jJep_TSG70wAr5M-Ce7soPyr4SBdPqyo2ENZ2DYcqkA@mail.gmail.com> <CAE9FiQU_vZo40cje_XJXSxuKW-JL6H-8rAazwOw1O-ewcV+C5g@mail.gmail.com> <52E7E776.30909@ti.com> <20140128182230.GO15937@n2100.arm.linux.org.uk>
In-Reply-To: <20140128182230.GO15937@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Gryagorii,
On Tuesday 28 January 2014 01:22 PM, Russell King - ARM Linux wrote:
> On Tue, Jan 28, 2014 at 12:23:02PM -0500, Santosh Shilimkar wrote:
>> On Tuesday 28 January 2014 12:12 PM, Yinghai Lu wrote:
>>> Index: linux-2.6/include/linux/bootmem.h
>>> ===================================================================
>>> --- linux-2.6.orig/include/linux/bootmem.h
>>> +++ linux-2.6/include/linux/bootmem.h
>>> @@ -179,6 +179,9 @@ static inline void * __init memblock_vir
>>>                                                     NUMA_NO_NODE);
>>>  }
>>>
>>> +/* Take arch's ARCH_LOW_ADDRESS_LIMIT at first*/
>>> +#include <asm/processor.h>
>>> +
>>>  #ifndef ARCH_LOW_ADDRESS_LIMIT
>>>  #define ARCH_LOW_ADDRESS_LIMIT  0xffffffffUL
>>>  #endif
>>
>> This won't help mostly since the ARM 32 arch don't set ARCH_LOW_ADDRESS_LIMIT.
>> Sorry i couldn't respond to the thread earlier because of travel and
>> don't have access to my board to try out the patches.
> 
> Let's think about this for a moment, shall we...
> 
> What does memblock_alloc_virt*() return?  It returns a virtual address.
> 
> How is that virtual address obtained?  ptr = phys_to_virt(alloc);
> 
> What is the valid address range for passing into phys_to_virt() ?  Only
> lowmem addresses.
> 
> Hence, having ARCH_LOW_ADDRESS_LIMIT set to 4GB-1 by default seems to be
> completely rediculous - and presumably this also fails on x86_32 if it
> returns memory up at 4GB.
> 
> So... yes, I think reverting the arch/arm part of this patch is the right
> solution, whether the rest of it should be reverted is something I can't
> comment on.
> 
Grygorri mentioned an alternate to update the memblock_find_in_range_node() so
that it takes into account the limit.

Regards,
Santosh 
