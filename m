Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbaFIUE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:04:57 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:37093 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326AbaFIUEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:04:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140609184157.17500.84469.stgit@bling.home>
References: <20140609184157.17500.84469.stgit@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 9 Jun 2014 14:04:30 -0600
Message-ID: <CAErSpo5XNcw4sKdYrmg26N=qkvA9ysspy2kKf+bCv0KfKEGY8Q@mail.gmail.com>
Subject: Re: [PATCH] PCI: Add bridge DMA alias quirk for ITE bridge
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rwarsow@gmx.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 12:43 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=73551
> Reported-by: rwarsow@gmx.de
> Tested-by: rwarsow@gmx.de
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Added to pci/iommu for v3.16, thanks!

> ---
>
> One more for the pci/iommu branch
>
>  drivers/pci/quirks.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index ab620ac..533cd0d 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3407,6 +3407,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ASMEDIA, 0x1080,
>                          quirk_use_pcie_bridge_dma_alias);
>  /* Tundra 8113, https://bugzilla.kernel.org/show_bug.cgi?id=44881#c43 */
>  DECLARE_PCI_FIXUP_HEADER(0x10e3, 0x8113, quirk_use_pcie_bridge_dma_alias);
> +/* ITE 8892, https://bugzilla.kernel.org/show_bug.cgi?id=73551 */
> +DECLARE_PCI_FIXUP_HEADER(0x1283, 0x8892, quirk_use_pcie_bridge_dma_alias);
>
>  static struct pci_dev *pci_func_0_dma_source(struct pci_dev *dev)
>  {
>
