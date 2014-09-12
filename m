Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaILOxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:53:07 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:52394 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaILOxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:53:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140911222022.16809.57079.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20140911222022.16809.57079.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Date: Fri, 12 Sep 2014 10:52:59 -0400
Message-ID: <CADnq5_NEH52W++SOFJ8NPhKKvESLnt3ZS9RXXGA9Ch9R3aRnjg@mail.gmail.com>
Subject: Re: [PATCH 0/2] PCI: Ignore hotplug events for dual GPU systems
From: Alex Deucher <alexdeucher@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linux PCI <linux-pci@vger.kernel.org>, SpacemanSpiff <a818958@trbvm.com>,
        Rajat Jain <rajatxjain@gmail.com>, Dave Airlie <airlied@linux.ie>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        "Jose P." <lbdkmjdf@sharklasers.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 6:23 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> These are intended to resolve problems on dual GPU systems where the radeon
> driver becomes unusable because of problems suspending or resuming a GPU.
> When the GPU is powered off, we may get hotplug remove events, and we
> would normally unbind the driver and destroy the pci_dev.  But in this
> case, the radeon and nouveau drivers expect to remain bound to the device
> because it isn't really removable, and they may power it back on later.
>
> Links to the bug reports in the patch changelogs.
>
> I would like to get these into v3.17 if they seem reasonable.

Looks good to me.

Acked-by: Alex Deucher <alexander.deucher@amd.com>

>
> ---
>
> Bjorn Helgaas (2):
>       PCI: Add pci_ignore_hotplug() to ignore hotplug events for a device
>       ACPIPHP / radeon / nouveau: Remove acpi_bus_no_hotplug()
>
>
>  drivers/acpi/bus.c                           |   10 ----------
>  drivers/gpu/drm/nouveau/nouveau_acpi.c       |   16 ++--------------
>  drivers/gpu/drm/nouveau/nouveau_drm.c        |    1 +
>  drivers/gpu/drm/radeon/radeon_atpx_handler.c |   16 ++--------------
>  drivers/gpu/drm/radeon/radeon_drv.c          |    1 +
>  drivers/pci/hotplug/acpiphp_glue.c           |   16 ++++++----------
>  drivers/pci/hotplug/pciehp_hpc.c             |   12 ++++++++++++
>  include/acpi/acpi_bus.h                      |    4 +---
>  include/linux/pci.h                          |    6 ++++++
>  9 files changed, 31 insertions(+), 51 deletions(-)
