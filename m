Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaFDSqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:46:31 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:47296 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaFDSq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:46:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140604175145.GD20812@kroah.com>
References: <1401869506-48129-1-git-send-email-ritesh.harjani@gmail.com>
	<1401869506-48129-2-git-send-email-ritesh.harjani@gmail.com>
	<20140604175145.GD20812@kroah.com>
Date: Thu, 5 Jun 2014 00:16:28 +0530
Message-ID: <CAD15agbiuXiiAp62R-NeLeX3rgNftmyb+wGiSVx-FgtcXzxpHA@mail.gmail.com>
Subject: Re: [PATCH 1/1] device.h: arm,dma-iommu: Move out dma_iommu_mapping struct
From: Ritesh Harjani <ritesh.harjani@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Thanks for reviewing.

On Wed, Jun 4, 2014 at 11:21 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Jun 04, 2014 at 01:41:46PM +0530, ritesh.harjani@gmail.com wrote:
>> From: Ritesh Harjani <ritesh.harjani@gmail.com>
>>
>> This patch moves out *mapping pointer of dma_iommu_mapping
>> from arch/arm/include/asm/device.h to include/liunux/device.h
>
> Why?  Who else can use this becides arm devices?

Currently only arm and arm64 are the archs at this very moment but
later other archs can make use of this, as its an arch independent
code. (Similar to as some arch make use of iommu_area_alloc in
iommu-helper.c)

>
>>
>> Also, it moves out complete structre definition of dma_iommu_mapping
>> to include/linux/iommu-helper.h
>>
>> This is done since arm iommu's dma-mapping arch independent code,
>> needs to be moved out to lib/iommu-helper.c, this means
>> dma_iommu_mapping will be arch independent and later other archs
>> can make use of it.
>
> Will that really happen?  Do you have patches that do that?  I'd prefer
> to not do stuff like this until you have a patch series that needs it,
> otherwise this is just unneeded churn.

Yes, foll link has the patch series, (under review)
http://www.spinics.net/lists/arm-kernel/msg336896.html

>
>> --- a/include/linux/device.h
>> +++ b/include/linux/device.h
>> @@ -705,6 +705,10 @@ struct device {
>>       /* arch specific additions */
>>       struct dev_archdata     archdata;
>>
>> +#ifdef CONFIG_DMA_USE_IOMMU_HELPER_MAPPING
>> +     struct dma_iommu_mapping        *mapping;
>> +#endif
>> +
>>       struct device_node      *of_node; /* associated device tree node */
>>       struct acpi_dev_node    acpi_node; /* associated ACPI device node */
>>
>
> Are you sure this will not break the build on systems that enable that
> option, yet do not include iommu-helper.h?

They need to include iommu-helper.h wherever they are using this
structure members. Until then no this should
not break the build I think for the case you mentioned. That's how it
was done in arch/arm/include/asm/device.h

Do I need to do this in diff way ?

>
> thanks,
>
> greg k-h



Thanks
Ritesh
