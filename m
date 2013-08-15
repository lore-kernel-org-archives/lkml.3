Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab3HOUu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:50:26 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51056 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3HOUuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:50:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130814200549.21626.79779.stgit@bling.home>
References: <20130814200549.21626.79779.stgit@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 15 Aug 2013 14:50:04 -0600
Message-ID: <CAErSpo6zfR2TQViyKTr9mjWHSnp9Veo9wRN_eQCJU2YtabPRTA@mail.gmail.com>
Subject: Re: [PATCH] pci: Add probe functions for bus and slot reset
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 2:06 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> Users of pci_reset_bus() and pci_reset_slot() need a way to probe
> whether the bus or slot supports reset.  Add trivial helper functions
> and export them as vfio-pci will make use of these.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Merged to the PCI "next" branch for v3.12, thanks.

> ---
>
> This is logically patch 10/9 for v5 pci: bus and slot reset interfaces.
> If there's a need to re-spin anything I'll roll this in.
>
>  drivers/pci/pci.c   |   24 ++++++++++++++++++++++++
>  include/linux/pci.h |    2 ++
>  2 files changed, 26 insertions(+)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index ba68451..888d847 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3610,6 +3610,18 @@ static int pci_slot_reset(struct pci_slot *slot, int probe)
>  }
>
>  /**
> + * pci_probe_reset_slot - probe whether a PCI slot can be reset
> + * @slot: PCI slot to probe
> + *
> + * Return 0 if slot can be reset, negative if a slot reset is not supported.
> + */
> +int pci_probe_reset_slot(struct pci_slot *slot)
> +{
> +       return pci_slot_reset(slot, 1);
> +}
> +EXPORT_SYMBOL_GPL(pci_probe_reset_slot);
> +
> +/**
>   * pci_reset_slot - reset a PCI slot
>   * @slot: PCI slot to reset
>   *
> @@ -3662,6 +3674,18 @@ static int pci_bus_reset(struct pci_bus *bus, int probe)
>  }
>
>  /**
> + * pci_probe_reset_bus - probe whether a PCI bus can be reset
> + * @bus: PCI bus to probe
> + *
> + * Return 0 if bus can be reset, negative if a bus reset is not supported.
> + */
> +int pci_probe_reset_bus(struct pci_bus *bus)
> +{
> +       return pci_bus_reset(bus, 1);
> +}
> +EXPORT_SYMBOL_GPL(pci_probe_reset_bus);
> +
> +/**
>   * pci_reset_bus - reset a PCI bus
>   * @bus: top level PCI bus to reset
>   *
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 1a8fd34..daf40cd 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -924,7 +924,9 @@ int pcie_set_mps(struct pci_dev *dev, int mps);
>  int __pci_reset_function(struct pci_dev *dev);
>  int __pci_reset_function_locked(struct pci_dev *dev);
>  int pci_reset_function(struct pci_dev *dev);
> +int pci_probe_reset_slot(struct pci_slot *slot);
>  int pci_reset_slot(struct pci_slot *slot);
> +int pci_probe_reset_bus(struct pci_bus *bus);
>  int pci_reset_bus(struct pci_bus *bus);
>  void pci_reset_bridge_secondary_bus(struct pci_dev *dev);
>  void pci_update_resource(struct pci_dev *dev, int resno);
>
