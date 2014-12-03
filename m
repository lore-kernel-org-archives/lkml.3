Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaLCXty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:49:54 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:34019 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbaLCXtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:49:51 -0500
MIME-Version: 1.0
In-Reply-To: <1417642834-20350-7-git-send-email-konrad.wilk@oracle.com>
References: <1417642834-20350-1-git-send-email-konrad.wilk@oracle.com> <1417642834-20350-7-git-send-email-konrad.wilk@oracle.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 3 Dec 2014 16:49:30 -0700
Message-ID: <CAErSpo62D02fh-AmLC4N7OUK0yYN89X_FuZNqXsv4AfYUTj5eg@mail.gmail.com>
Subject: Re: [PATCH v5 6/9] PCI: Expose pci_load_saved_state for public consumption.
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 2:40 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> We have the pci_load_and_free_saved_state, and pci_store_saved_state
> but are missing the functionality to just load the state
> multiple times in the PCI device without having to free/save
> the state.
>
> This patch makes it possible to use this function.
>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

I assume you'll merge this whole series through your tree.  Let me
know if you want me to do anything else.

> ---
>  drivers/pci/pci.c   | 5 +++--
>  include/linux/pci.h | 2 ++
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 625a4ac..f00a9d6 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1142,8 +1142,8 @@ EXPORT_SYMBOL_GPL(pci_store_saved_state);
>   * @dev: PCI device that we're dealing with
>   * @state: Saved state returned from pci_store_saved_state()
>   */
> -static int pci_load_saved_state(struct pci_dev *dev,
> -                               struct pci_saved_state *state)
> +int pci_load_saved_state(struct pci_dev *dev,
> +                        struct pci_saved_state *state)
>  {
>         struct pci_cap_saved_data *cap;
>
> @@ -1171,6 +1171,7 @@ static int pci_load_saved_state(struct pci_dev *dev,
>         dev->state_saved = true;
>         return 0;
>  }
> +EXPORT_SYMBOL_GPL(pci_load_saved_state);
>
>  /**
>   * pci_load_and_free_saved_state - Reload the save state pointed to by state,
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 5be8db4..08088cb1 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1003,6 +1003,8 @@ void __iomem __must_check *pci_platform_rom(struct pci_dev *pdev, size_t *size);
>  int pci_save_state(struct pci_dev *dev);
>  void pci_restore_state(struct pci_dev *dev);
>  struct pci_saved_state *pci_store_saved_state(struct pci_dev *dev);
> +int pci_load_saved_state(struct pci_dev *dev,
> +                        struct pci_saved_state *state);
>  int pci_load_and_free_saved_state(struct pci_dev *dev,
>                                   struct pci_saved_state **state);
>  struct pci_cap_saved_state *pci_find_saved_cap(struct pci_dev *dev, char cap);
> --
> 1.9.3
>
