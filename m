Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab3LBXLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:11:36 -0500
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:49880 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753496Ab3LBXLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:11:32 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:857:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2915:3138:3139:3140:3141:3142:3352:3622:3865:3868:3871:3872:3873:4321:4605:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12114:12296:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shoes30_815af98020e50
X-Filterd-Recvd-Size: 2020
Message-ID: <1386025887.15309.6.camel@joe-AO722>
Subject: Re: [PATCH 06/39] dma: remove DEFINE_PCI_DEVICE_TABLE macro
From: Joe Perches <joe@perches.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, "'Vinod Koul'" <vinod.koul@intel.com>,
        "'Dan Williams'" <dan.j.williams@intel.com>, dmaengine@vger.kernel.org
Date: Mon, 02 Dec 2013 15:11:27 -0800
In-Reply-To: <001b01ceefb2$ffd995f0$ff8cc1d0$%han@samsung.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
	 <001b01ceefb2$ffd995f0$ff8cc1d0$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-03 at 08:05 +0900, Jingoo Han wrote:
> Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> is not preferred.
[]
> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
[]
> @@ -996,7 +996,7 @@ static void pch_dma_remove(struct pci_dev *pdev)
>  #define PCI_DEVICE_ID_ML7831_DMA1_8CH	0x8810
>  #define PCI_DEVICE_ID_ML7831_DMA2_4CH	0x8815
>  
> -DEFINE_PCI_DEVICE_TABLE(pch_dma_id_table) = {
> +const struct pci_device_id pch_dma_id_table[] = {
>  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_8CH), 8 },
>  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_4CH), 4 },
>  	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_DMA1_8CH), 8}, /* UART Video */

As you do these, please check/verify if the converted
table should also be static and add it where appropriate.

$ git grep -w pch_dma_id_table 
drivers/dma/pch_dma.c:DEFINE_PCI_DEVICE_TABLE(pch_dma_id_table) = {
drivers/dma/pch_dma.c:  .id_table       = pch_dma_id_table,
drivers/dma/pch_dma.c:MODULE_DEVICE_TABLE(pci, pch_dma_id_table);


