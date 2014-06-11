Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaFKTyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:54:08 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:37726 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaFKTyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:54:05 -0400
Date: Wed, 11 Jun 2014 13:54:09 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: =?iso-8859-1?B?Suly9G1l?= Carretero <cJ-ko@zougloub.eu>
Cc: linux-pci@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: quirk dma_alias_devfn for HighPoint RocketRaid 642L
 (Marvell 9235)
Message-ID: <20140611195409.GC14357@google.com>
References: <20140603154156.4f1b46c4@Vantage>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140603154156.4f1b46c4@Vantage>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 03:41:56PM -0400, Jérôme Carretero wrote:
> This vendor has similar boards based on the same Marvell 88SE9235 chipset,
> but this patch was only tested with the 642L.
> 
> Tested on ASUS Sabertooth 990FX (AMD).
> 
> If you listen to the vendor support stating:
> 
>   Dear Customer,
>   Sorry about that.
>   Currently all our products' software package don't support IOMMU
>   and we don't have plan to support that.
> 
> ... you'll think you also wasted your money, but it turns out that you
> just lost a few hours of your valuable time talking to their support,
> because the good people from the Internet made their board work,
> with the regular AHCI driver, and even with IOMMU. Nice!
> 
> 
> Signed-off-by: Jérôme Carretero <cJ-ko@zougloub.eu>

Applied with Alex's ack to pci/iommu for v3.16, thanks!

Note that I only have the PCI parts here.  There are several IOMMU patches
required in addition, and I haven't heard the fate of those.

> ---
>  drivers/pci/quirks.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index f6a42bc..43c0ea0 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3380,6 +3380,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x91a0,
>  /* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c49 */
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9230,
>  			 quirk_dma_func1_alias);
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TTI, 0x0642,
> +			 quirk_dma_func1_alias);
>  /* https://bugs.gentoo.org/show_bug.cgi?id=497630 */
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_JMICRON,
>  			 PCI_DEVICE_ID_JMICRON_JMB388_ESD,
> -- 
> 2.0.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
