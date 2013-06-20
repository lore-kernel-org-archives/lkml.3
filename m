Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3FTHtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:49:32 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:30895 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3FTHta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:49:30 -0400
Message-ID: <51C2B406.10604@atmel.com>
Date: Thu, 20 Jun 2013 09:49:26 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 8/8] at91/avr32/atmel_lcdfb: prepare clk before calling
 enable
References: <1371640263-9268-1-git-send-email-b.brezillon@overkiz.com> <1371640930-9771-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1371640930-9771-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/06/2013 13:22, Boris BREZILLON :
> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
> avoid common clk framework warnings.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   drivers/video/atmel_lcdfb.c |    8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
> index 540909d..8525457 100644
> --- a/drivers/video/atmel_lcdfb.c
> +++ b/drivers/video/atmel_lcdfb.c
> @@ -893,14 +893,14 @@ static int __init atmel_lcdfb_init_fbinfo(struct atmel_lcdfb_info *sinfo)
>
>   static void atmel_lcdfb_start_clock(struct atmel_lcdfb_info *sinfo)
>   {
> -	clk_enable(sinfo->bus_clk);
> -	clk_enable(sinfo->lcdc_clk);
> +	clk_prepare_enable(sinfo->bus_clk);
> +	clk_prepare_enable(sinfo->lcdc_clk);
>   }
>
>   static void atmel_lcdfb_stop_clock(struct atmel_lcdfb_info *sinfo)
>   {
> -	clk_disable(sinfo->bus_clk);
> -	clk_disable(sinfo->lcdc_clk);
> +	clk_disable_unprepare(sinfo->bus_clk);
> +	clk_disable_unprepare(sinfo->lcdc_clk);
>   }
>
>
>


-- 
Nicolas Ferre
