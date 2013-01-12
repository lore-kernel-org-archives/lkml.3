Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab3ALV3Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 16:29:16 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39056 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab3ALV3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 16:29:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 00/22] PCI, ACPI: pci root bus hotplug support / pci match_driver
Date: Sat, 12 Jan 2013 22:35:01 +0100
Message-ID: <1754034.2pZM4AiYYe@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 02:40:27 PM Yinghai Lu wrote:
> It includes
> 1. preparing patches for pci root bus hotadd/hotremove support
> 2. move root bus hotadd from acpiphp to pci_root.c
> 3. add hot-remove support
> 4. clean up hotadd/remove with common functions
> 5. add acpi_hp_work to be shared with acpiphp and root-bus hotplug
> 6. add match_driver to add pci device to device tree early but
>    not attach driver for hotplug path.
> 
> based on pci/next
> 
> could get from
>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-root-bus-hotplug
> 
> After this patchset, will send out
> 	 for_each_host_bridge support
> 	 for_each_dev_addon_res
> 
> Jiang Liu (4):
>   PCI: Fix a device reference count leakage issue in pci_dev_present()
>   PCI: make PCI device create/destroy logic symmetric
>   PCI: split registration of PCI bus devices into two stages
>   PCI: correctly detect ACPI PCI host bridge objects
> 
> Tang Chen (2):
>   ACPI: Introduce a new acpi handle to determine HID match.
>   PCI, ACPI: debug print for installation of acpi root bridge's notifier
> 
> Yinghai Lu (16):
>   PCI, acpiphp: Add is_hotplug_bridge detection
>   PCI: Add root bus children dev's res to fail list
>   PCI: Set dev_node early for pci_dev
>   ACPI: Separate acpi_bus_trim to support two steps.
>   PCI, acpiphp: Separate out hot-add support of pci host bridge
>   PCI, ACPI: Add pci_root_hp hot removal notification support.
>   PCI, ACPI: remove acpi_root_bridge in pci_root_hp
>   ACPI: update ej_event interface to take acpi_device
>   ACPI, PCI: Simplify handle_root_bridge_removal()
>   PCI, acpiphp: Don't bailout even no slots found yet.
>   PCI, ACPI: Add alloc_acpi_hp_work()
>   PCI, acpiphp: Use acpi_hp_work
>   PCI, pci_root_hp: Use acpi_hp_work
>   PCI, ACPI: Make kacpi_hotplug_wq static
>   PCI: add match_driver in struct pci_dev
>   PCI: move device_add out of pci_bus_add_device()

It looks good overall, but I have a few questions and comments.

I'll reply to the individual patches where applicable.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
