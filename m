Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3EGWgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 18:36:16 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:65402 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab3EGWgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 18:36:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo635J8+p-0-CtxxTJdTRB70zKVYwOF+fmt3kcj6tpz_0Q@mail.gmail.com>
References: <5AA430FFE4486C448003201AC83BC85E03DEA379@EXHQ.corp.stratus.com>
	<1366940827-15336-1-git-send-email-yinghai@kernel.org>
	<20130507213250.GA22773@google.com>
	<CAErSpo635J8+p-0-CtxxTJdTRB70zKVYwOF+fmt3kcj6tpz_0Q@mail.gmail.com>
Date: Tue, 7 May 2013 15:36:13 -0700
X-Google-Sender-Auth: BwPRbjobFPgFHre9RXUL2A7wXMc
Message-ID: <CAE9FiQW4+6hSXyaupKAJP2vDc2RzuyQFV0P9dZdGpbtX92gYZw@mail.gmail.com>
Subject: Re: [PATCH] PCI: move down pci_fixup_final for hotplug path
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Bulkow <David.Bulkow@stratus.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 2:38 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, May 7, 2013 at 2:32 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>
>>     PCI: Delay final fixups until resources are assigned
>>
>>     Commit 4f535093cf "PCI: Put pci_dev in device tree as early as possible"
>>     moved final fixups from pci_bus_add_device() to pci_device_add().  But
>>     pci_device_add() happens before resource assignment, so BARs may not be
>>     valid yet.
>>
>>     Typical flow for hot-add:
>>
>>         pciehp_configure_device
>>           pci_scan_slot
>>             pci_scan_single_device
>>               pci_device_add
>>                 pci_fixup_device(pci_fixup_final, dev)  # previous location
>>           # resource assignment happens here
>>           pci_bus_add_devices
>>             pci_bus_add_device
>>               pci_fixup_device(pci_fixup_final, dev)    # new location
>>
>>     [bhelgaas: changelog, move fixups to pci_bus_add_device()]

Yes, that is right fix.

Thanks

Yinghai
