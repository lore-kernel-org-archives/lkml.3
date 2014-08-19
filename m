Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaHSWBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 18:01:36 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:29226 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaHSWBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 18:01:35 -0400
X-IronPort-AV: E=Sophos;i="5.01,897,1400050800"; 
   d="scan'208";a="43275294"
Subject: Re: [PATCH 1/3] tg3: Limit minimum tx queue wakeup threshold
From: Michael Chan <mchan@broadcom.com>
To: Benjamin Poirier <bpoirier@suse.de>
CC: Prashant Sreedharan <prashant@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <1408474371-19509-1-git-send-email-bpoirier@suse.de>
References: <1408474371-19509-1-git-send-email-bpoirier@suse.de>
Content-Type: text/plain; charset="cp1252"
Date: Tue, 19 Aug 2014 15:00:47 -0700
Message-ID: <1408485647.7404.3.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-19 at 11:52 -0700, Benjamin Poirier wrote: 
> diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
> index 3ac5d23..b11c0fd 100644
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -202,7 +202,8 @@ static inline void _tg3_flag_clear(enum TG3_FLAGS flag, unsigned long *bits)
>  #endif
>  
>  /* minimum number of free TX descriptors required to wake up TX process */
> -#define TG3_TX_WAKEUP_THRESH(tnapi)            ((tnapi)->tx_pending / 4)
> +#define TG3_TX_WAKEUP_THRESH(tnapi)    max_t(u32, (tnapi)->tx_pending / 4, \
> +                                             MAX_SKB_FRAGS + 1)

I think we should precompute this and store it in something like
tp->tx_wake_thresh.

>  #define TG3_TX_BD_DMA_MAX_2K           2048
>  #define TG3_TX_BD_DMA_MAX_4K           4096
>   

