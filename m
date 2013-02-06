Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab3BFXbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 18:31:41 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:49114 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab3BFXbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 18:31:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo4vd+GhTVpoLb=sFTqBZMG=xva1QUUhyJrO4o0ytPXmqg@mail.gmail.com>
References: <CAE9FiQXHG01NjnYNDbC-KEpbcvY-q4pBe97CxTOGS7W4vZQBYQ@mail.gmail.com>
	<52330506.F9m0tMYuG1@vostro.rjw.lan>
	<CAE9FiQXTRaP08ZeHWTJHt50DZO800BMigmo=q65-RLzZWkTvoQ@mail.gmail.com>
	<3459136.QID0qrXQHt@vostro.rjw.lan>
	<CAErSpo4vd+GhTVpoLb=sFTqBZMG=xva1QUUhyJrO4o0ytPXmqg@mail.gmail.com>
Date: Wed, 6 Feb 2013 15:31:39 -0800
X-Google-Sender-Auth: aqyKiCsKOYuI09cpiie0G8tYBtk
Message-ID: <CAE9FiQViHem1OBWEb-6_J1kzK-zUgiA4DZVH3_vagCNK_pkn6g@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] PCI: Iterate pci host bridge instead of pci root bus
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Myron Stowe <myron.stowe@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 3:02 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Feb 6, 2013 at 3:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Wednesday, February 06, 2013 01:53:50 PM Yinghai Lu wrote:
>>> On Wed, Feb 6, 2013 at 1:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> > On Wednesday, February 06, 2013 01:28:27 PM Yinghai Lu wrote:
>>> >> so you still did not answer you want 1 or 2 yet:
>>> >>
>>> >> for sgi_hotplug,
>>> >>
>>> >> 1. still keep the module support, and register acpi_pci_driver later.
>>> >> 2. built-in support only, and need to register acpi_pci_driver early.
>>> >
>>> > Please work with the assumption that acpi_pci_driver is not going to be there
>>> > any more.
>>> >
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

so we will have all built-in for apci_pci_driver and call add/remove directly?

BTW, looks like sgi_hotplug may need some time to convert ...
Also not sure who can test it.

>
>> I'd really prefer to wait for the patchset removing acpi_pci_driver (from
>> Myron) before proceeding with more changes in that area.
>>
>> Myron, do you have a prototype based on the current linux-next?
>
> I think it's really the acpiphp/pciehp issue that's holding up the
> removal of acpi_pci_driver.  I'm not sure if anybody's working on
> that.

Myron's last Dec's version would split all acpi_pci_driver's
add/remove into acpi_pci_root_add/remove.

other way is use host-bridge nodifier, looks like that is not favorable.

BTW, looks like I could put add/remove calling directly in
acpi_pci_root_add/remove
for ioapic and iommu.

Thanks

Yinghai
