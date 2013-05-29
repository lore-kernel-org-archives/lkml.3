Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967019Ab3E2Uvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:51:38 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:56530 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966896Ab3E2Uvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:51:32 -0400
MIME-Version: 1.0
In-Reply-To: <51A6113302000078000D99A3@nat28.tlf.novell.com>
References: <51A6113302000078000D99A3@nat28.tlf.novell.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 29 May 2013 14:51:11 -0600
Message-ID: <CAErSpo53UtV2bHVEMYWaHk-j5cVWxhYfX76qP=m1Q4gxsc8mUA@mail.gmail.com>
Subject: Re: [PATCH] xen-pciback: more uses of cached MSI-X capability offset
To: Jan Beulich <JBeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 6:31 AM, Jan Beulich <JBeulich@suse.com> wrote:
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>
> ---
>  drivers/xen/xen-pciback/pci_stub.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

I assume you'll take this, Konrad.  Let me know if you need me to do anything.

> --- 3.10-rc3/drivers/xen/xen-pciback/pci_stub.c
> +++ 3.10-rc3-xen-pciback-MSI-X-cap/drivers/xen/xen-pciback/pci_stub.c
> @@ -106,7 +106,7 @@ static void pcistub_device_release(struc
>         else
>                 pci_restore_state(dev);
>
> -       if (pci_find_capability(dev, PCI_CAP_ID_MSIX)) {
> +       if (dev->msix_cap) {
>                 struct physdev_pci_device ppdev = {
>                         .seg = pci_domain_nr(dev->bus),
>                         .bus = dev->bus->number,
> @@ -371,7 +371,7 @@ static int pcistub_init_device(struct pc
>         if (err)
>                 goto config_release;
>
> -       if (pci_find_capability(dev, PCI_CAP_ID_MSIX)) {
> +       if (dev->msix_cap) {
>                 struct physdev_pci_device ppdev = {
>                         .seg = pci_domain_nr(dev->bus),
>                         .bus = dev->bus->number,
>
>
>
