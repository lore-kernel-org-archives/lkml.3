Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaLHMnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:43:51 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:62725 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbaLHMnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:43:49 -0500
MIME-Version: 1.0
In-Reply-To: <20141127000147.GC5313@kroah.com>
References: <1416220572-13381-1-git-send-email-ankit.jindal@linaro.org>
 <1416220572-13381-3-git-send-email-ankit.jindal@linaro.org> <20141127000147.GC5313@kroah.com>
From: Ankit Jindal <ankit.jindal@linaro.org>
Date: Mon, 8 Dec 2014 18:13:28 +0530
Message-ID: <CAPTm99WWk6XZnEjwjiDoxxGZdR6WccFXZBAjOfpWNq1dWrBfjw@mail.gmail.com>
Subject: Re: [PATCH v5 2/6] uio: Add new UIO_MEM_PHYS_CACHE type for mem regions
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, "patches@apm.com" <patches@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Kumar Gala <galak@codeaurora.org>, Anup Patel <anup@brainfault.org>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2014 at 05:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Nov 17, 2014 at 04:06:08PM +0530, Ankit Jindal wrote:
>> Currently, three types of mem regions are supported: UIO_MEM_PHYS,
>> UIO_MEM_LOGICAL and UIO_MEM_VIRTUAL. Among these UIO_MEM_PHYS helps
>> UIO driver export physcial memory to user space as non-cacheable
>> user memory. Typcially memory-mapped registers of a device are exported
>> to user space as UIO_MEM_PHYS type mem region. The UIO_MEM_PHYS type
>> is not efficient if dma-capable devices are capable of maintaining coherency
>> with CPU caches.
>
> Not efficient in what way?
Sorry, I will rephrase this.
>
>> This patch adds new type UIO_MEM_PHYS_CACHE for mem regions to enable
>> cacheable access to physical memory from user space.
>>
>> Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
>> Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
>> ---
>>  drivers/uio/uio.c          |   11 ++++++++---
>>  include/linux/uio_driver.h |    1 +
>>  2 files changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
>> index 97e6444..120a84b 100644
>> --- a/drivers/uio/uio.c
>> +++ b/drivers/uio/uio.c
>> @@ -644,7 +644,7 @@ static const struct vm_operations_struct uio_physical_vm_ops = {
>>  #endif
>>  };
>>
>> -static int uio_mmap_physical(struct vm_area_struct *vma)
>> +static int uio_mmap_physical(struct vm_area_struct *vma, bool cacheable)
>
> I despise "bool" flags in a function, as they don't give any idea of
> what is going on when you see the function being called.  Please create
> a new function that does this properly, with a correct name, if it's
> needed.
Sure, will take care of this in next revision.
>
> thanks,
>
> greg k-h
Thanks,
Ankit
