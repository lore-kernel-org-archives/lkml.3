Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab3FYXO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:14:58 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51000 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab3FYXO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:14:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, john.ronciak@intel.com,
        miles.j.penner@intel.com, bruce.w.allan@intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 0/6] Thunderbolt workarounds take 2
Date: Wed, 26 Jun 2013 01:24:25 +0200
Message-ID: <12066786.EK0Z2aX1JA@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 25, 2013 07:22:04 PM Mika Westerberg wrote:
> Hi all,
> 
> This is the second iteration of the patches first posted here quite a while
> ago:
> 
> 	https://lkml.org/lkml/2012/12/13/589
> 
> With Thunderbolt devices we might see pretty complex PCIe hierarchies that
> the current ACPI hotplug code was not able to handle properly but instead
> failed to scan the whole hierarchy. This series tries to address these
> problems. In addition to that there's a possibility that only part of the
> chain is disconnected so we don't want to leave behind stale PCI devices.
> 
> We have tested this on Acer Aspire S5 with the largest chain looking like
> this:
> 
>   PC +--+ eSata Hub #0 +--+ eSata Hub #1 +--+ Apple Thunderbolt display +--+ Apple ethernet dongle
> 
> There are still problems with different device drivers because of the
> surprise hotplug nature of Thunderbolt, causing occasional hangs and
> failures that should be fixed per-driver later on (not addressed in this
> series).
> 
> Currently Thunderbolt on Apple hardware like Macbooks is not yet supported
> as they use some different mechanism than ACPI events to trigger hotplug
> events.
> 
> The series is based on linux-pm.git/linux-next.
> 
> Kirill A. Shutemov (4):
>   PCI: acpiphp: do not check for SLOT_ENABLED in enable_device()
>   PCI: acpiphp: enable_device(): rescan even if no new devices on slot
>   PCI: introduce pci_trim_stale_devices()
>   PCI: acpiphp: check for new devices on enabled host
> 
> Mika Westerberg (2):
>   PCI: acpiphp: look _RMV method a bit deeper in the hierarhcy
>   x86/PCI: quirk Thunderbolt PCI-to-PCI bridges
> 
>  arch/x86/pci/fixup.c               | 51 ++++++++++++++++++++++++
>  drivers/pci/hotplug/acpi_pcihp.c   | 53 ++++++++++++++++++++++---
>  drivers/pci/hotplug/acpiphp_glue.c | 79 +++++++++++++++++---------------------
>  drivers/pci/remove.c               | 20 ++++++++++
>  include/linux/pci.h                |  1 +
>  5 files changed, 156 insertions(+), 48 deletions(-)

Would you please CC things touching ACPIPHP to linux-acpi?

Rafael

