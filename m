Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbbAHT11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 14:27:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43198 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbbAHT1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 14:27:25 -0500
Message-ID: <54AED9EC.1020703@ti.com>
Date: Thu, 8 Jan 2015 14:26:36 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robherring2@gmail.com>, Joerg Roedel <joro@8bytes.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 2/4] of: move of_dma_configure() to device,c to help
 re-use
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com> <1420656594-8908-3-git-send-email-m-karicheri2@ti.com> <CAL_Jsq+pKeXuGnZV_NYHn6iZgeOs404OPhcUb0FJs=-7j2P1Ug@mail.gmail.com> <3861625.CJ6m15sZMh@wuerfel>
In-Reply-To: <3861625.CJ6m15sZMh@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 03:40 AM, Arnd Bergmann wrote:
> On Wednesday 07 January 2015 17:37:56 Rob Herring wrote:
>> On Wed, Jan 7, 2015 at 12:49 PM, Murali Karicheri<m-karicheri2@ti.com>  wrote:
>>
>>> +       ret = of_dma_get_range(np,&dma_addr,&paddr,&size);
>>> +       if (ret<  0) {
>>> +               dma_addr = offset = 0;
>>> +               size = dev->coherent_dma_mask + 1;
>>
>> If coherent_dma_mask is DMA_BIT_MASK(64), then you will overflow and
>> have a size of 0. There may also be a problem when the mask is only
>> 32-bit type.
>
> The mask is always a 64-bit type, it's not optional. But you are right,
> the 64-bit mask case is broken, so I guess we have to fix it differently
> by always passing the smaller value into arch_setup_dma_ops and
> adapting that function instead.
Arnd,

What is the smaller value you are referring to in the below code? 
between *dev->dma_mask and size from DT? But overflow can still happen 
when size is to be calculated in arch_setup_dma_ops() for Non DT case or 
when DT size is configured to be equivalent of DMA_BIT_MASK(64) + 1. Can 
we discuss the code change you have in mind when you get a chance?

Murali
>
> 	Arnd


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
