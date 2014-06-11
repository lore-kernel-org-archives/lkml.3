Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaFKTZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:25:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbaFKTZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:25:03 -0400
Message-ID: <1402514702.14174.163.camel@ul30vt.home>
Subject: Re: [PATCH] PCI: quirk dma_alias_devfn for HighPoint RocketRaid
 642L (Marvell 9235)
From: Alex Williamson <alex.williamson@redhat.com>
To: =?ISO-8859-1?Q?J=E9r=F4me?= Carretero <cJ-ko@zougloub.eu>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 11 Jun 2014 13:25:02 -0600
In-Reply-To: <20140603154156.4f1b46c4@Vantage>
References: <20140603154156.4f1b46c4@Vantage>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-03 at 15:41 -0400, Jérôme Carretero wrote:
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

Acked-by: Alex Williamson <alex.williamson@redhat.com>

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



