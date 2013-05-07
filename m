Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab3EGKDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:03:38 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:46247 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3EGKDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:03:37 -0400
Message-ID: <5188D174.90400@gmail.com>
Date: Tue, 07 May 2013 12:03:32 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Marek Belisko <marek.belisko@gmail.com>
CC: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, daniel@zonque.org,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: Re: [PATCH 1/2] clk: si5351: Fix msynth_recalc_rate return value
 when fOUT is 0.
References: <1367914491-17445-1-git-send-email-marek.belisko@streamunlimited.com>
In-Reply-To: <1367914491-17445-1-git-send-email-marek.belisko@streamunlimited.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 10:14 AM, Marek Belisko wrote:
> When p3 is eual to 0 then result for fOUT is 0. In that case we should
> return 0 not parent_rate;
>
> This issue was causing deadlock in si5351 chip when user set_rate for
> ms0->clk0 and then set_rate for ms1->clk1 (both ms sourced from plla).
> After that clk1 was 0 and it wasn't possible to enable it again (try also
> manually with i2cset commands). Only power cycle helps.

Marek,

does the fix below also affect the behavior above, i.e. not causing
si5351 to hang?

Anyway, your fix looks very sane to me and you get my

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

> Signed-off-by: Marek Belisko<marek.belisko@streamunlimited.com>
> ---
>   drivers/clk/clk-si5351.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
> index fc215ce..a8fc0f4 100644
> --- a/drivers/clk/clk-si5351.c
> +++ b/drivers/clk/clk-si5351.c
> @@ -607,7 +607,7 @@ static unsigned long si5351_msynth_recalc_rate(struct clk_hw *hw,
>   		si5351_read_parameters(hwdata->drvdata, reg,&hwdata->params);
>
>   	if (hwdata->params.p3 == 0)
> -		return parent_rate;
> +		return 0;
>
>   	/*
>   	 * multisync0-5: fOUT = (128 * P3 * fIN) / (P1*P3 + P2 + 512*P3)

