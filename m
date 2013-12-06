Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab3LFNz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:55:27 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49829 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab3LFNzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:55:24 -0500
Message-ID: <52A1E4C2.6020004@ti.com>
Date: Fri, 6 Dec 2013 16:52:50 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 08/23] mm/memblock: Add memblock memory allocation
 apis
References: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com> <1386037658-3161-9-git-send-email-santosh.shilimkar@ti.com> <20131203232445.GX8277@htj.dyndns.org> <52A0AB34.2030703@ti.com>,<20131205165325.GA24062@mtj.dyndns.org> <902E09E6452B0E43903E4F2D568737AB097B26B2@DNCE04.ent.ti.com> <52A0E357.7090008@ti.com>
In-Reply-To: <52A0E357.7090008@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 10:34 PM, Santosh Shilimkar wrote:
> Grygorii,
>
> On Thursday 05 December 2013 01:48 PM, Strashko, Grygorii wrote:
>> Hi Tejun,
>>
>>> On Thu, Dec 05, 2013 at 06:35:00PM +0200, Grygorii Strashko wrote:
>>>>>> +#define memblock_virt_alloc_align(x, align) \
>>>>>> +  memblock_virt_alloc_try_nid(x, align, BOOTMEM_LOW_LIMIT, \
>>>>>> +                               BOOTMEM_ALLOC_ACCESSIBLE, MAX_NUMNODES)
>>>>>
>>>>> Also, do we really need this align variant separate when the caller
>>>>> can simply specify 0 for the default?
>>>>
>>>> Unfortunately Yes.
>>>> We need it to keep compatibility with bootmem/nobootmem
>>>> which don't handle 0 as default align value.
>>>
>>> Hmm... why wouldn't just interpreting 0 to SMP_CACHE_BYTES in the
>>> memblock_virt*() function work?
>>>
>>
>> Problem is not with memblock_virt*(). The issue will happen in case if
>> memblock or nobootmem are disabled in below code (memblock_virt*() is disabled).
>>
>> +/* Fall back to all the existing bootmem APIs */
>> +#define memblock_virt_alloc(x) \
>> +       __alloc_bootmem(x, SMP_CACHE_BYTES, BOOTMEM_LOW_LIMIT)
>>
>> which will be transformed to
>> +/* Fall back to all the existing bootmem APIs */
>> +#define memblock_virt_alloc(x, align) \
>> +       __alloc_bootmem(x, align, BOOTMEM_LOW_LIMIT)
>>
>> and used as
>>
>> memblock_virt_alloc(size, 0);
>>
>> so, by default bootmem code will use 0 as default alignment and not SMP_CACHE_BYTES
>> and that is wrong.
>>
> Looks like you didn't understood the suggestion completely.
> The fall back inline will look like below .....
>
> static inline memblock_virt_alloc(x, align)
> {
> 	if (align == 0)
> 		align = SMP_CACHE_BYTES
> 	__alloc_bootmem(x, align, BOOTMEM_LOW_LIMIT);
> }
>

I understand. thanks.

Regards,
-grygorii
