Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbbAHWrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:47:23 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49941 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636AbbAHWrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:47:21 -0500
Message-ID: <54AF08C7.2010100@ti.com>
Date: Thu, 8 Jan 2015 17:46:31 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <bhelgaas@google.com>, <linux-arm-kernel@lists.infradead.org>,
        <joro@8bytes.org>, <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <will.deacon@arm.com>, <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 0/4] PCI: get DMA configuration from parent device
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com> <54ADBB89.8070503@ti.com> <1934001.D0JfDRp1gF@wuerfel> <2785994.gTZ9chGdKf@wuerfel>
In-Reply-To: <2785994.gTZ9chGdKf@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 05:27 PM, Arnd Bergmann wrote:
> On Thursday 08 January 2015 09:56:39 Arnd Bergmann wrote:
>> There is another interesting case, which is a USB host controller or
>> something similar behind a PCI bus. These are quite common and also
>> need to be handled in some form. Let's do just PCI first for now, but
>> be aware that this will come next. Should we assume that the ID that
>> is required for a device is either known from the device node, or
>> that it comes from a PCI device? That means for the USB case, we will
>> likely need to have some custom logic. There seems to be an implicit
>> assumption all over the kernel that all devices have the same IOMMU
>> instance, but we can't really rely on that here.
>>
>
> Update: I've checked the USB implementation and we are lucky because
> these interactions are all done by the USB host controller, and a
> USB device is not itself DMA capable. We don't have to do anything
> for USB.

Ok Thanks.

Murali
>
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
