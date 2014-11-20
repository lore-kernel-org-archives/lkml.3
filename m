Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbaKTMBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:01:15 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:33297 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737AbaKTMBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:01:13 -0500
Message-ID: <546DD804.4010105@linaro.org>
Date: Thu, 20 Nov 2014 13:01:08 +0100
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Yijing Wang <wangyijing@huawei.com>
CC: Liviu Dudau <liviu@dudau.co.uk>, Tony Luck <tony.luck@intel.com>,
        Russell King <linux@arm.linux.org.uk>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Xinwei Hu <huxinwei@huawei.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Suravee.Suthikulpanit@amd.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-ia64@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Wuyun <wuyun.wu@huawei.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 00/16] Refine PCI host bridge scan interfaces
References: <1416219710-26088-1-git-send-email-wangyijing@huawei.com> <20535707.3sA6NjSINh@wuerfel> <546B38F5.6050708@huawei.com> <1534030.bkpIToWlHq@wuerfel>
In-Reply-To: <1534030.bkpIToWlHq@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.11.2014 13:27, Arnd Bergmann wrote:
> On Tuesday 18 November 2014 20:17:57 Yijing Wang wrote:
>>
>>>>
>>>> I hope platforms with ACPI or DT could both use pci_create_host_bridge().
>>>> Why we need to use two different ways to process it ?
>>>
>>> These are completely different use cases:
>>>
>>> a) For DT, we want loadable device drivers that start by probing a host
>>>     bridge device which was added through the DT platform code. The
>>>     driver is self-contained, and eventually we want to be able to unload
>>>     it. We have lots of different per-soc drivers that require different
>>>     quirks
>>>
>>> b) For ACPI, the interface is defined in the ACPI spec across architectures
>>>     and SoCs, we don't have host bridge drivers and the code that initializes
>>>     the PCI is required early during boot and called from architecture
>>>     code. There is no parent device, as ACPI sees PCI as a fundamental building
>>>     block by itself, and there are no drivers because the firmware does
>>>     the initial hardware setup, so we only have to access the config space.
>>
>> Hmmm, I'm a little confused, so why you think ACPI host driver should not use
>> pci_create_host_bridge(), because ACPI PCI driver has no parent device ?
>
> It's one of the difference. Having a parent device can certainly make your
> life simpler, since you have devm_kzalloc(), dev_info(), etc. Coming from
> the other end, I think ACPI needs PCI to be available during early boot,
> at a time where we might not want pci_create_host_bridge() to do the
> right thing.

Device pointer is not required for ACPI, struct acpi_device is all we 
need to get all that info. If pci_create_host_bridge() would be DT 
specific, it would be nice to have sth similar for ACPI but that is out 
of this patch set scope.

Tomasz
