Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3D1I4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 04:56:43 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:61387 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3D1I4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 04:56:41 -0400
Message-ID: <517CE43C.3080003@gmail.com>
Date: Sun, 28 Apr 2013 10:56:28 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Marek Belisko <marek.belisko@gmail.com>
CC: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, zonque@gmail.com,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: Re: [PATCH 1/2] clk: si5351: Fix clkout rate computation.
References: <1366698170-31346-1-git-send-email-marek.belisko@streamunlimited.com>
In-Reply-To: <1366698170-31346-1-git-send-email-marek.belisko@streamunlimited.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 08:22 AM, Marek Belisko wrote:
> Rate was incorrectly computed because we read from wrong divider register.
>
> Signed-off-by: Marek Belisko<marek.belisko@streamunlimited.com>

Marek,

sorry for the late reply and very good catch!

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

> ---
>   drivers/clk/clk-si5351.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
> index 8927284..cf39e53 100644
> --- a/drivers/clk/clk-si5351.c
> +++ b/drivers/clk/clk-si5351.c
> @@ -932,7 +932,7 @@ static unsigned long si5351_clkout_recalc_rate(struct clk_hw *hw,
>   	unsigned char reg;
>   	unsigned char rdiv;
>
> -	if (hwdata->num>  5)
> +	if (hwdata->num<= 5)
>   		reg = si5351_msynth_params_address(hwdata->num) + 2;
>   	else
>   		reg = SI5351_CLK6_7_OUTPUT_DIVIDER;

