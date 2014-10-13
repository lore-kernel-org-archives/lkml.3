Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaJMONp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:13:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33811 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbaJMONo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:13:44 -0400
Message-ID: <543BDDF3.6010306@ti.com>
Date: Mon, 13 Oct 2014 10:13:07 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: keystone: add bus notifier to set dma_pfn_offset
 for pci devices
References: <1412954137-4567-1-git-send-email-m-karicheri2@ti.com> <54385187.6030002@ti.com> <54387429.2030605@ti.com> <7696162.dApA5zbMp7@wuerfel>
In-Reply-To: <7696162.dApA5zbMp7@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2014 04:37 PM, Arnd Bergmann wrote:
> On Friday 10 October 2014 20:04:57 Santosh Shilimkar wrote:
>> On 10/10/14 5:37 PM, Murali Karicheri wrote:
>>> Based on this, dma configuration parameters get set for the device which
>>> is probed through DT.
>>>
>>> As PCI devices are attached to the PCI bus during scan, and we don't
>>> have DT nodes, we could use similar mechanism to pass the dma-range info
>>> from parent host platform device to the PCI devices by adding an
>>> of_pci_dma_configure() API and hook it to the PCI probe path some where?
>>> Please comment on this so that I can work on the right solution to
>>> address this issue for Keystone.
>>>
>> Adding the DT node parsing code in PCI bus probe path is the right way
>> to go about it. You could re-use some of the helpers from dma parsing
>> code.
>>
>> I let Arnd comment if he disagrees, otherwise I suggest to create an
>> RFC patch and post it on the list. We can take it from there.
>
> Yes, I think that is the correct way forward, we need this anyway to
> handle IOMMUs correctly, following the patches that Will Deacon did
> for platform device IOMMU configuration.
Arnd,

Could you point me to a thread/link for Will Deacon's IOMMU work? Is it 
part of the kernel already?

Murali
>
>> That also reminded me xhci host code issue with dma-ranges since the
>> devices are manually created there. I will review that thread as
>> well after this merge window.
>
> Right, manually created devices are always problematic, you should
> try to avoid those.
>
> 	Arnd


-- 
Murali Karicheri
Linux Kernel, Texas Instruments
