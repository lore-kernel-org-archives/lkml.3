Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab3BFXC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 18:02:57 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:52731 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221Ab3BFXCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 18:02:55 -0500
MIME-Version: 1.0
In-Reply-To: <3459136.QID0qrXQHt@vostro.rjw.lan>
References: <CAE9FiQXHG01NjnYNDbC-KEpbcvY-q4pBe97CxTOGS7W4vZQBYQ@mail.gmail.com>
 <52330506.F9m0tMYuG1@vostro.rjw.lan> <CAE9FiQXTRaP08ZeHWTJHt50DZO800BMigmo=q65-RLzZWkTvoQ@mail.gmail.com>
 <3459136.QID0qrXQHt@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 6 Feb 2013 16:02:33 -0700
Message-ID: <CAErSpo4vd+GhTVpoLb=sFTqBZMG=xva1QUUhyJrO4o0ytPXmqg@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] PCI: Iterate pci host bridge instead of pci root bus
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@gmail.com>,
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

On Wed, Feb 6, 2013 at 3:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, February 06, 2013 01:53:50 PM Yinghai Lu wrote:
>> On Wed, Feb 6, 2013 at 1:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Wednesday, February 06, 2013 01:28:27 PM Yinghai Lu wrote:
>> >> so you still did not answer you want 1 or 2 yet:
>> >>
>> >> for sgi_hotplug,
>> >>
>> >> 1. still keep the module support, and register acpi_pci_driver later.
>> >> 2. built-in support only, and need to register acpi_pci_driver early.
>> >
>> > Please work with the assumption that acpi_pci_driver is not going to be there
>> > any more.
>> >
>>
>> I think I could change ioapic and iommu hotplug to weak add/remove because they
>> should be built-in by nature.
>>
>> but how about others like sgi_hotplug etc?

I think that could be handled with pcibios_root_bridge_prepare() or
something similar -- something that happens in the "add host bridge"
path.  I'm not saying we necessarily have all the right hooks in place
yet.  It's just that I'd rather figure out what the right hooks *are*
and add them if necessary, than just convert pci_root_buses to
for_each_pci_host_bridge().

> I'd really prefer to wait for the patchset removing acpi_pci_driver (from
> Myron) before proceeding with more changes in that area.
>
> Myron, do you have a prototype based on the current linux-next?

I think it's really the acpiphp/pciehp issue that's holding up the
removal of acpi_pci_driver.  I'm not sure if anybody's working on
that.
