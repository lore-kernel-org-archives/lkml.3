Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab3LCMLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:11:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:29102 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab3LCMLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:11:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,817,1378882800"; 
   d="scan'208";a="437699013"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
Subject: Re: [PATCH 06/39] dma: remove DEFINE_PCI_DEVICE_TABLE macro
Thread-Topic: [PATCH 06/39] dma: remove DEFINE_PCI_DEVICE_TABLE macro
Thread-Index: AQHO8CC/NAqACFd7PEqF7MSlwvbprA==
Date: Tue, 3 Dec 2013 12:11:08 +0000
Message-ID: <1386072642.1871.46.camel@smile>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
	 <001b01ceefb2$ffd995f0$ff8cc1d0$%han@samsung.com>
In-Reply-To: <001b01ceefb2$ffd995f0$ff8cc1d0$%han@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.173]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFBB01FF96A04C4EAB530624F54A55B2@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB3CBTVH024385

On Tue, 2013-12-03 at 08:05 +0900, Jingoo Han wrote:
> Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> is not preferred.

I'm sorry, but Documentation/PCI/pci.txt still says "is the preferred
method".

Is there any link to patch for Documentation and discussion why change
is established?

> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/dma/dw/pci.c  |    2 +-
>  drivers/dma/pch_dma.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/dw/pci.c b/drivers/dma/dw/pci.c
> index e89fc24..fc3aea1 100644
> --- a/drivers/dma/dw/pci.c
> +++ b/drivers/dma/dw/pci.c
> @@ -75,7 +75,7 @@ static void dw_pci_remove(struct pci_dev *pdev)
>  		dev_warn(&pdev->dev, "can't remove device properly: %d\n", ret);
>  }
>  
> -static DEFINE_PCI_DEVICE_TABLE(dw_pci_id_table) = {
> +static const struct pci_device_id dw_pci_id_table[] = {
>  	/* Medfield */
>  	{ PCI_VDEVICE(INTEL, 0x0827), (kernel_ulong_t)&dw_pci_pdata },
>  	{ PCI_VDEVICE(INTEL, 0x0830), (kernel_ulong_t)&dw_pci_pdata },
> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> index 61fdc54..9f0cdb1 100644
> --- a/drivers/dma/pch_dma.c
> +++ b/drivers/dma/pch_dma.c
> @@ -996,7 +996,7 @@ static void pch_dma_remove(struct pci_dev *pdev)
>  #define PCI_DEVICE_ID_ML7831_DMA1_8CH	0x8810
>  #define PCI_DEVICE_ID_ML7831_DMA2_4CH	0x8815
>  
> -DEFINE_PCI_DEVICE_TABLE(pch_dma_id_table) = {
> +const struct pci_device_id pch_dma_id_table[] = {
>  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_8CH), 8 },
>  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_4CH), 4 },
>  	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_DMA1_8CH), 8}, /* UART Video */

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
