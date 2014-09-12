Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaILVfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:35:36 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:59235 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaILVfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:35:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQX3_BiOy5ZaQwDA+XN7Bn-XOtrdGrqAVWuAsuguHa+YYg@mail.gmail.com>
References: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <20140912180300.1630.62966.stgit@bhelgaas-glaptop2.roam.corp.google.com> <CAE9FiQX3_BiOy5ZaQwDA+XN7Bn-XOtrdGrqAVWuAsuguHa+YYg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 12 Sep 2014 15:35:10 -0600
Message-ID: <CAErSpo6dF468YjBdYL3A2=cgsB3bAaqNdOL-Fs-EVnz=cJ0MUA@mail.gmail.com>
Subject: Re: [PATCH v1 02/13] PCI: Move pci_configure_slot() to drivers/pci/probe.c
To: Yinghai Lu <yinghai@kernel.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rajat Jain <rajatxjain@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 3:31 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Sep 12, 2014 at 11:03 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> Move pci_configure_slot() and related functions from
>> drivers/pci/hotplug/pcihp_slot to drivers/pci/probe.c.
>>
>> This is to prepare for doing device configuration during the normal
>> enumeration process instead of just after hot-add.
>>
>> ...

> Would be better if those acpi related code could be moved to
> drivers/pci/pci-acpi.c. and should put pci_configure_device() from
> next patch to pci-acpi.c.

Good point.  I just moved a bunch of the stuff from
drivers/pci/hotplug/acpi_pcihp.c to pci-acpi.h, because acpi_pcihp.c
is not compiled unless CONFIG_PCI_HOTPLUG is set.  And this stuff
probably should go there, too.

> Other that,  for the whole patchset,
>
> Acked-by: Yinghai Lu <yinghai@kernel.org>
