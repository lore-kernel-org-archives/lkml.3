Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaKRLqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:46:36 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:22840 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaKRLqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:46:34 -0500
Message-ID: <546B317E.4090800@huawei.com>
Date: Tue, 18 Nov 2014 19:46:06 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Liviu Dudau <liviu@dudau.co.uk>, Tony Luck <tony.luck@intel.com>,
        "Russell King" <linux@arm.linux.org.uk>, <linux-pci@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        <Suravee.Suthikulpanit@amd.com>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>, <linux-ia64@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Wuyun <wuyun.wu@huawei.com>,
        <linuxppc-dev@lists.ozlabs.org>,
        Yijing Wang <wangyijing0307@gmail.com>
Subject: Re: [RFC PATCH 01/16] PCI: Enhance pci_scan_root_bus() to support
 default IO/MEM resources
References: <1416219710-26088-1-git-send-email-wangyijing@huawei.com> <2732970.7HG94QvVBv@wuerfel> <546AF8D7.9010103@huawei.com> <2447172.ADYWdCTnMP@wuerfel>
In-Reply-To: <2447172.ADYWdCTnMP@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/18 17:36, Arnd Bergmann wrote:
> On Tuesday 18 November 2014 15:44:23 Yijing Wang wrote:
>> On 2014/11/17 18:08, Arnd Bergmann wrote:
>>> On Monday 17 November 2014 18:21:35 Yijing Wang wrote:
>>>> -       list_for_each_entry(window, resources, list)
>>>> -               if (window->res->flags & IORESOURCE_BUS) {
>>>> -                       found = true;
>>>> -                       break;
>>>> -               }
>>>> +       if (!resources) {
>>>> +               pci_add_resource(&default_res, &ioport_resource);
>>>> +               pci_add_resource(&default_res, &iomem_resource);
>>>> +               pci_add_resource(&default_res, &busn_resource);
>>>> +       } else {
>>>>
>>>
>>> Isn't it almost always wrong to do this? You are adding all of the
>>> I/O ports and memory to the host bridge, which will prevent you from
>>> adding another host bridge, and the iomem_resource normally
>>> includes a lot of addresses that are not accessible by the PCI host.
>>
>> Hi Arnd, pci host bridge windows are the ranges allow child devices to setup
>> from. Add all of IO/MEM here just a limit to child devices, no request for these
>> resources, so it won't hurt another host bridge. Some platforms have no dts or ACPI
>> report host bridge resources, in this case, we directly assign ioport/iomem_resources
>> as the root resources of PCI devices.
> 
> But it would be wrong to allow hosts to allocate a device BAR that is not
> visible through the host bridge. I think we need to keep these separate
> from the general case: if you call any of the modern interfaces you have
> to provide the resources and a device. I notice that there is only one
> caller of pci_scan_bus_parented(), we should probably change that over to
> pci_scan_root_bus() or your new interface and remove the old one, but
> keep pci_scan_bus() as the only entry point for all of the legacy users
> that do not know about the resources.

Ok, I will move this out of the generic interface.

Thanks!
Yijing.

> 
> 	Arnd
> 
> .
> 


-- 
Thanks!
Yijing

