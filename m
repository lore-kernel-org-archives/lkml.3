Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaKEM4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:56:16 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:36796 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbaKEM4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:56:12 -0500
MIME-Version: 1.0
In-Reply-To: <4B098F57-E202-412C-B54D-085A46792EDC@codeaurora.org>
References: <1413871011-4101-1-git-send-email-ankit.jindal@linaro.org>
 <1413871011-4101-3-git-send-email-ankit.jindal@linaro.org>
 <6D33D50E-2DD1-482C-B05E-45B237F3B779@codeaurora.org> <CAPTm99W0J-Q6CwCDVaYe4eyEWrruWuY5pzpHoESyVu9N3cFA=g@mail.gmail.com>
 <4B098F57-E202-412C-B54D-085A46792EDC@codeaurora.org>
From: Ankit Jindal <ankit.jindal@linaro.org>
Date: Wed, 5 Nov 2014 18:25:51 +0530
Message-ID: <CAPTm99UUA0Oe40uH73Rj8_hvyMYwuxcKhFvU_KVZxmKpR1jn2Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] uio: Add new UIO_MEM_PHYS_CACHE type for mem regions
To: Kumar Gala <galak@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "patches@apm.com" <patches@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Varka Bhadram <varkabhadram@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

On 31 October 2014 19:09, Kumar Gala <galak@codeaurora.org> wrote:
>
> On Oct 31, 2014, at 4:30 AM, Ankit Jindal <ankit.jindal@linaro.org> wrote:
>
>> Hi Kumar,
>>
>> On 21 October 2014 12:08, Kumar Gala <galak@codeaurora.org> wrote:
>>>
>>> On Oct 21, 2014, at 7:56 AM, Ankit Jindal <ankit.jindal@linaro.org> wrote:
>>>
>>>> Currently, three types of mem regions are supported: UIO_MEM_PHYS,
>>>> UIO_MEM_LOGICAL and UIO_MEM_VIRTUAL. Among these UIO_MEM_PHYS helps
>>>> UIO driver export physcial memory to user space as non-cacheable
>>>> user memory. Typcially memory-mapped registers of a device are exported
>>>> to user space as UIO_MEM_PHYS type mem region. The UIO_MEM_PHYS type
>>>> is not efficient if dma-capable devices are capable of maintaining coherency
>>>> with CPU caches.
>>>>
>>>> This patch adds new type UIO_MEM_PHYS_CACHE for mem regions to enable
>>>> cacheable access to physical memory from user space.
>>>>
>>>> Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
>>>> Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
>>>> ---
>>>> drivers/uio/uio.c          |   11 ++++++++---
>>>> include/linux/uio_driver.h |    1 +
>>>> 2 files changed, 9 insertions(+), 3 deletions(-)
>>>
>>> Rather than adding a new type, why not allow the driver to set the pgprot value, this way one has full control and we don’t need to keep adding types for various different cache attributions in the future.
>>
>> Do you mean to add a new field pgprot_t in the memtype structure and
>> uio_mmap_physical will set vma->vm_page_prot to this value provided by
>> driver ? If this is the case then we will need to change all the
>> current uio based drivers which was the reason I preferred to have a
>> new mem type.
>>
>> Please let me know if I have misunderstood anything.
>
> I’m suggeting in uio_mmap_physical to do something like:
>
> if (idev->info->set_pgprot)
>         idev->info->set_pgprot(vma->vm_page_prot)
> else
>         vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>
> And add a set_prprot callback to 'struct uio_info’.
>
> Here’s patch from several years ago:
>
> http://patchwork.ozlabs.org/patch/119224/

The suggested solution looks okey but not sure whether there is any
available drivers using different combinations. Also, I looked at the
available pgprot routines, looks like only pgprot_noncached and
pgprot_writecombine are the available ones. So if we are not going to
use these pgprot routines then driver might have architecture
dependent switches, which we should avoid.

Thanks,
Ankit
>
> - k
>
> --
> Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
