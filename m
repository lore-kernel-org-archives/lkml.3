Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab3BMCmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 21:42:42 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34191 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab3BMCmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 21:42:40 -0500
MIME-Version: 1.0
In-Reply-To: <1360722010.3604.3.camel@thor.lan>
References: <CAE9FiQUkmnV_On5+ZpH2pF4Li1HxLpkO8bp4TnYB46=pc9Safg@mail.gmail.com>
	<1360696283-20313-1-git-send-email-yinghai@kernel.org>
	<1360722010.3604.3.camel@thor.lan>
Date: Tue, 12 Feb 2013 18:42:40 -0800
X-Google-Sender-Auth: 6ezcYeWyNfjAfz6KCZbQy19ej30
Message-ID: <CAE9FiQUp4oKSpZ8Y-M-+n_y=mBs_t4cdKLhgG8xZSPgteZcgkQ@mail.gmail.com>
Subject: Re: [PATCH] ACPI, PCI: Get PRT entry during acpi_pci_enable_irq()
From: Yinghai Lu <yinghai@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 6:20 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On Tue, 2013-02-12 at 11:11 -0800, Yinghai Lu wrote:
>> Peter Hurley found "irq 18 nobody cared" with pci-next, and dmesg has
>>
>> [    8.983246] pci 0000:00:1e.0: can't derive routing for PCI INT A
>> [    8.983600] snd_ctxfi 0000:09:02.0: PCI INT A: no GSI - using ISA IRQ 5
>>
>> bisect to
>> | commit 4f535093cf8f6da8cfda7c36c2c1ecd2e9586ee4
>> |     PCI: Put pci_dev in device tree as early as possible
>>
>> It turns out we need to call acpi_pci_irq_add_prt() after the pci bridges
>> are scanned.
>>
>> Bjorn said:
>>  The bus number binding means acpi_pci_irq_add_prt() has to happen
>>  after enumerating everything below a bridge, and it will prevent us
>>  from doing any bus number reassignment for hotplug.
>>
>>  I think we should remove the bus numbers from the cached _PRT (or
>>  maybe even remove the _PRT caching completely).  When we enable a PCI
>>  device's IRQ, we should search up the PCI device tree looking for a
>>  _PRT associated with each node, and applying normal PCI bridge
>>  swizzling when we don't find a _PRT.  I think this can be done without
>>  using PCI bus numbers at all.
>>
>> So here we try to remove _PRT caching completely.
>>
>> -v2: check !handle early.
>>
>> Reported-and-tested-by: Peter Hurley <peter@hurleysoftware.com>
>
> Actually true now :)
>
> Reported-and-tested-by: Peter Hurley <peter@hurleysoftware.com>

Thanks.

> PS - I just happened to see this version on the list. Would you please
> cc me on any future versions?

oh, my fault. I take it for granted that "git send-email" will pick
that email from
patch just like Cc.

Yinghai
