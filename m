Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaBTSQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:16:56 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:63829 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbaBTSQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:16:53 -0500
MIME-Version: 1.0
In-Reply-To: <1392918366-19079-1-git-send-email-paul.gortmaker@windriver.com>
References: <1392918366-19079-1-git-send-email-paul.gortmaker@windriver.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 20 Feb 2014 11:16:32 -0700
Message-ID: <CAErSpo4wgVmz5N5nO38LuNBrf7pJ5BkRfy80pY=sJpjneVdnmw@mail.gmail.com>
Subject: Re: [PATCH] frv: replace now removed pci_bus_b() causing build failure
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: David Howells <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci]

On Thu, Feb 20, 2014 at 10:46 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> In commit 94e6a9b93064b49024b8701d2d81fcb4a821fa09 ("PCI: Remove
> pci_bus_b() and use list_for_each_entry() directly") the function
> pci_bus_b() was removed, but one instance of its usage was missed.
>
> Replace it in the same fashion that the original commit did.
>
> Cc: Yijing Wang <wangyijing@huawei.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Crap, sorry about that.  I added this to my pci/list-for-each-entry
branch for v3.15.

> ---
>
> [Note: commit ID referenced above is from linux-next and will
>  be invalid if the PCI-next content is ever rebased.]
>
>  arch/frv/mb93090-mb00/pci-frv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/frv/mb93090-mb00/pci-frv.c b/arch/frv/mb93090-mb00/pci-frv.c
> index c28121765448..67b1d1685759 100644
> --- a/arch/frv/mb93090-mb00/pci-frv.c
> +++ b/arch/frv/mb93090-mb00/pci-frv.c
> @@ -88,7 +88,7 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
>
>         /* Depth-First Search on bus tree */
>         for (ln=bus_list->next; ln != bus_list; ln=ln->next) {
> -               bus = pci_bus_b(ln);
> +               bus = list_entry(ln, struct pci_bus, node);
>                 if ((dev = bus->self)) {
>                         for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_NUM_RESOURCES; idx++) {
>                                 r = &dev->resource[idx];
> --
> 1.8.5.2
>
