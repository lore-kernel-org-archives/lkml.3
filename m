Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab3BMCUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 21:20:35 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:53903 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab3BMCUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 21:20:34 -0500
Message-ID: <1360722010.3604.3.camel@thor.lan>
Subject: Re: [PATCH] ACPI, PCI: Get PRT entry during acpi_pci_enable_irq()
From: Peter Hurley <peter@hurleysoftware.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2013 21:20:10 -0500
In-Reply-To: <1360696283-20313-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQUkmnV_On5+ZpH2pF4Li1HxLpkO8bp4TnYB46=pc9Safg@mail.gmail.com>
	 <1360696283-20313-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 11:11 -0800, Yinghai Lu wrote:
> Peter Hurley found "irq 18 nobody cared" with pci-next, and dmesg has
> 
> [    8.983246] pci 0000:00:1e.0: can't derive routing for PCI INT A
> [    8.983600] snd_ctxfi 0000:09:02.0: PCI INT A: no GSI - using ISA IRQ 5
> 
> bisect to
> | commit 4f535093cf8f6da8cfda7c36c2c1ecd2e9586ee4
> |     PCI: Put pci_dev in device tree as early as possible
> 
> It turns out we need to call acpi_pci_irq_add_prt() after the pci bridges
> are scanned.
> 
> Bjorn said:
>  The bus number binding means acpi_pci_irq_add_prt() has to happen
>  after enumerating everything below a bridge, and it will prevent us
>  from doing any bus number reassignment for hotplug.
> 
>  I think we should remove the bus numbers from the cached _PRT (or
>  maybe even remove the _PRT caching completely).  When we enable a PCI
>  device's IRQ, we should search up the PCI device tree looking for a
>  _PRT associated with each node, and applying normal PCI bridge
>  swizzling when we don't find a _PRT.  I think this can be done without
>  using PCI bus numbers at all.
> 
> So here we try to remove _PRT caching completely.
> 
> -v2: check !handle early.
> 
> Reported-and-tested-by: Peter Hurley <peter@hurleysoftware.com>

Actually true now :)

Reported-and-tested-by: Peter Hurley <peter@hurleysoftware.com>

Regards and thanks again,
Peter Hurley

PS - I just happened to see this version on the list. Would you please
cc me on any future versions?


