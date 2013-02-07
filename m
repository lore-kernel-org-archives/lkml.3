Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030228Ab3BGA2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:28:13 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:48203 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579Ab3BGA2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:28:05 -0500
Message-ID: <5112F4EE.5090601@huawei.com>
Date: Thu, 7 Feb 2013 08:27:26 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>,
        Myron Stowe <myron.stowe@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-pci@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/22] PCI: Iterate pci host bridge instead of pci
 root bus
References: <CAE9FiQXHG01NjnYNDbC-KEpbcvY-q4pBe97CxTOGS7W4vZQBYQ@mail.gmail.com> <52330506.F9m0tMYuG1@vostro.rjw.lan> <CAE9FiQXTRaP08ZeHWTJHt50DZO800BMigmo=q65-RLzZWkTvoQ@mail.gmail.com> <3459136.QID0qrXQHt@vostro.rjw.lan> <CAErSpo4vd+GhTVpoLb=sFTqBZMG=xva1QUUhyJrO4o0ytPXmqg@mail.gmail.com>
In-Reply-To: <CAErSpo4vd+GhTVpoLb=sFTqBZMG=xva1QUUhyJrO4o0ytPXmqg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-2-7 7:02, Bjorn Helgaas wrote:
> On Wed, Feb 6, 2013 at 3:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Wednesday, February 06, 2013 01:53:50 PM Yinghai Lu wrote:
>>> On Wed, Feb 6, 2013 at 1:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>> On Wednesday, February 06, 2013 01:28:27 PM Yinghai Lu wrote:
>>>>> so you still did not answer you want 1 or 2 yet:
>>>>>
>>>>> for sgi_hotplug,
>>>>>
>>>>> 1. still keep the module support, and register acpi_pci_driver later.
>>>>> 2. built-in support only, and need to register acpi_pci_driver early.
>>>>
>>>> Please work with the assumption that acpi_pci_driver is not going to be there
>>>> any more.
>>>>
>>>
>>> I think I could change ioapic and iommu hotplug to weak add/remove because they
>>> should be built-in by nature.
>>>
>>> but how about others like sgi_hotplug etc?
> 
> I think that could be handled with pcibios_root_bridge_prepare() or
> something similar -- something that happens in the "add host bridge"
> path.  I'm not saying we necessarily have all the right hooks in place
> yet.  It's just that I'd rather figure out what the right hooks *are*
> and add them if necessary, than just convert pci_root_buses to
> for_each_pci_host_bridge().
> 
>> I'd really prefer to wait for the patchset removing acpi_pci_driver (from
>> Myron) before proceeding with more changes in that area.
>>
>> Myron, do you have a prototype based on the current linux-next?
> 
> I think it's really the acpiphp/pciehp issue that's holding up the
> removal of acpi_pci_driver.  I'm not sure if anybody's working on
> that.
Hi Bjorn,
	I'm working on this topic, but a little busy with other stuff
in last few days. I guess I could should out a version in coming days.
	Thanks!

> 
> .
> 


