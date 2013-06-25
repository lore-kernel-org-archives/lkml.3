Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab3FYIQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:16:11 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:40929 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab3FYIQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:16:08 -0400
Message-ID: <51C951C2.8090901@atmel.com>
Date: Tue, 25 Jun 2013 10:16:02 +0200
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
Subject: Re: [PATCH v2 4/4] at91/avr32/atmel_lcdfb: prepare clk before calling
 enable
References: <1372147702-4074-1-git-send-email-b.brezillon@overkiz.com> <1372148053-4477-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1372148053-4477-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/2013 10:14, Boris BREZILLON :
> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
> avoid common clk framework warnings.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Jean-Christophe, can you take this one?

Thanks, best regards,

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
