Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3JYPU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:20:58 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4144 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab3JYPU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:20:56 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Dmitry Kravkov" <dmitry@broadcom.com>
To: "Thierry Reding" <thierry.reding@gmail.com>,
        "Russell King" <rmk@arm.linux.org.uk>,
        "Merav Sicron" <meravs@broadcom.com>,
        "David Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: manual merge of the arm tree
Thread-Topic: linux-next: manual merge of the arm tree
Thread-Index: AQHOzzknBPxlf8xjmU+VwcIpa+lrJ5oFi33Q
Date: Fri, 25 Oct 2013 15:20:40 +0000
Message-ID: <504C9EFCA2D0054393414C9CB605C37F20DDD3E1@SJEXCHMB06.corp.ad.broadcom.com>
References: <1382454517-4074-1-git-send-email-treding@nvidia.com>
 <1382454517-4074-2-git-send-email-treding@nvidia.com>
In-Reply-To: <1382454517-4074-2-git-send-email-treding@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E7453BC1SC1544201-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of Thierry Reding
> Sent: Tuesday, October 22, 2013 6:09 PM
> To: Russell King; Merav Sicron; David Miller; netdev@vger.kernel.org
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: linux-next: manual merge of the arm tree
> 
> Today's linux-next merge of the arm tree got a conflict in
> 
> 	drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> 
> caused by commits 1bfa2c4 (DMA-API: net: broadcom/bnx2x: replace
> dma_set_mask()+dma_set_coherent_mask() with new helper) and edd3147
> (bnx2x: Set NETIF_F_HIGHDMA unconditionally).
> 
> I fixed it up (see below). Please verify that the resolution looks good.
> 
> Thanks,
> Thierry
> ---
> diff --cc drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> index b42f89c,38bf998..767aafb
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> @@@ -12117,12 -12079,9 +12117,8 @@@ static int
> bnx2x_set_coherency_mask(str
>   {
>   	struct device *dev = &bp->pdev->dev;
> 
> - 	if (dma_set_mask(dev, DMA_BIT_MASK(64)) == 0) {
> - 		if (dma_set_coherent_mask(dev, DMA_BIT_MASK(64)) != 0) {
> - 			dev_err(dev, "dma_set_coherent_mask failed,
> aborting\n");
> - 			return -EIO;
> - 		}
> - 	} else if (dma_set_mask(dev, DMA_BIT_MASK(32)) != 0) {
>  -	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)) == 0) {
>  -		bp->flags |= USING_DAC_FLAG;
>  -	} else if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32)) !=
> 0) {
> ++	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)) != 0 &&
> ++	    dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32)) != 0) {
>   		dev_err(dev, "System does not support DMA, aborting\n");
>   		return -EIO;
>   	}

The fix is correct. Thanks, Thierry.
Acked-by: Dmitry Kravkov <dmitry@broadcom.com>
 

