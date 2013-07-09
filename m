Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3GIQCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:02:25 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:39976 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab3GIQCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:02:23 -0400
Message-ID: <51DC340F.2060402@atmel.com>
Date: Tue, 9 Jul 2013 18:02:23 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jongsung Kim <neidhard.kim@lge.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] net/cadence/macb: fix bug/typo in extracting gem_irq_read_clear
 bit
References: <1373358960-10900-1-git-send-email-neidhard.kim@lge.com>
In-Reply-To: <1373358960-10900-1-git-send-email-neidhard.kim@lge.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2013 10:36, Jongsung Kim :
> Signed-off-by: Jongsung Kim <neidhard.kim@lge.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: stable <stable@vger.kernel.org> # 3.10+

Thanks for having spotted that.

Best regards,

> ---
>   drivers/net/ethernet/cadence/macb.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index c89aa41..b4e0dc8 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -1070,7 +1070,7 @@ static void macb_configure_dma(struct macb *bp)
>   static void macb_configure_caps(struct macb *bp)
>   {
>   	if (macb_is_gem(bp)) {
> -		if (GEM_BF(IRQCOR, gem_readl(bp, DCFG1)) == 0)
> +		if (GEM_BFEXT(IRQCOR, gem_readl(bp, DCFG1)) == 0)
>   			bp->caps |= MACB_CAPS_ISR_CLEAR_ON_WRITE;
>   	}
>   }
>


-- 
Nicolas Ferre
