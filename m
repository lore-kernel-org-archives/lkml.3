Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163134Ab3DFB7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 21:59:35 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:54732 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab3DFB7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 21:59:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5w=uJ2sXzXhyS0AyPFTbxPM44djdEMb6bR2SQu1O+u2A@mail.gmail.com>
References: <CAErSpo5w=uJ2sXzXhyS0AyPFTbxPM44djdEMb6bR2SQu1O+u2A@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 5 Apr 2013 19:59:13 -0600
Message-ID: <CAErSpo68qt+5oJ2u96z5TQsGpnvm5wmA+=CVzkwnYKZMNf0+mg@mail.gmail.com>
Subject: Re: [GIT PULL] PCI updates for v3.9
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-kernel]

On Fri, Apr 5, 2013 at 7:31 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> Hi Linus,
>
> Here are some fixes for v3.9.  They include fixes for an ASPM problem
> that affects pre-1.1 PCIe devices, a kexec problem, the platform ROM
> image problem, a couple hotplug issues related to PM, and a fix for
> PCI-EISA bridges that have been broken for a long time.
>
> Bjorn
>
>
> The following changes since commit 8bb9660418e05bb1845ac1a2428444d78e322cc7:
>
>   Linux 3.9-rc4 (2013-03-23 16:52:44 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git
> tags/pci-v3.9-fixes-1
>
> for you to fetch changes up to de7d5f729c72638f41d7c17487bccb1c570ff144:
>
>   PCI/PM: Disable runtime PM of PCIe ports (2013-04-03 15:54:59 -0600)
>
> ----------------------------------------------------------------
> PCI updates for v3.9:
>
>   ASPM
>       Revert "PCI/ACPI: Request _OSC control before scanning PCI root bus"
>   kexec
>       PCI: Don't try to disable Bus Master on disconnected PCI devices
>   Platform ROM images
>       PCI: Add PCI ROM helper for platform-provided ROM images
>       nouveau: Attempt to use platform-provided ROM image
>       radeon: Attempt to use platform-provided ROM image
>   Hotplug
>       PCI/ACPI: Always resume devices on ACPI wakeup notifications
>       PCI/PM: Disable runtime PM of PCIe ports
>   EISA
>       EISA/PCI: Fix bus res reference
>       EISA/PCI: Init EISA early, before PNP
>
> ----------------------------------------------------------------
> Bjorn Helgaas (3):
>       Merge branch 'pci/mjg-rom' into for-linus
>       Merge branch 'pci/yinghai-eisa' into for-linus
>       Revert "PCI/ACPI: Request _OSC control before scanning PCI root bus"
>
> Konstantin Khlebnikov (1):
>       PCI: Don't try to disable Bus Master on disconnected PCI devices
>
> Matthew Garrett (3):
>       PCI: Add PCI ROM helper for platform-provided ROM images
>       nouveau: Attempt to use platform-provided ROM image
>       radeon: Attempt to use platform-provided ROM image
>
> Rafael J. Wysocki (2):
>       PCI/ACPI: Always resume devices on ACPI wakeup notifications
>       PCI/PM: Disable runtime PM of PCIe ports
>
> Yinghai Lu (2):
>       EISA/PCI: Fix bus res reference
>       EISA/PCI: Init EISA early, before PNP
>
>  drivers/acpi/pci_root.c                         | 76 ++++++++++++-------------
>  drivers/eisa/pci_eisa.c                         | 67 +++++++++++++++-------
>  drivers/gpu/drm/nouveau/core/subdev/bios/base.c | 17 ++++++
>  drivers/gpu/drm/radeon/radeon_bios.c            | 26 +++++++++
>  drivers/pci/pci-acpi.c                          | 15 ++---
>  drivers/pci/pci-driver.c                        |  5 +-
>  drivers/pci/pcie/portdrv_pci.c                  | 13 -----
>  drivers/pci/rom.c                               | 67 ++++++++++------------
>  include/linux/pci.h                             |  1 +
>  9 files changed, 169 insertions(+), 118 deletions(-)
