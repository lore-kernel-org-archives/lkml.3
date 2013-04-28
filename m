Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3D1I7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 04:59:47 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:35692 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3D1I7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 04:59:46 -0400
Message-ID: <517CE4FD.9010406@gmail.com>
Date: Sun, 28 Apr 2013 10:59:41 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Marek Belisko <marek.belisko@gmail.com>
CC: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, zonque@gmail.com,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: Re: [PATCH 2/2] clk: si5351: Apply rate when clock-frequency is defined
 in devicetree.
References: <1366698170-31346-1-git-send-email-marek.belisko@streamunlimited.com> <1366698170-31346-2-git-send-email-marek.belisko@streamunlimited.com>
In-Reply-To: <1366698170-31346-2-git-send-email-marek.belisko@streamunlimited.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 08:22 AM, Marek Belisko wrote:
> clock-frequency property from devicetree was read but never used. Apply
> defined rate when clock is registered.
>
> Signed-off-by: Marek Belisko<marek.belisko@streamunlimited.com>
> ---
>   drivers/clk/clk-si5351.c |   10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
> index cf39e53..8323c31 100644
> --- a/drivers/clk/clk-si5351.c
> +++ b/drivers/clk/clk-si5351.c
> @@ -1477,6 +1477,16 @@ static int si5351_i2c_probe(struct i2c_client *client,
>   			return -EINVAL;
>   		}
>   		drvdata->onecell.clks[n] = clk;
> +
> +		/* set rate when defined in devicetree */

nit: We also set the rate when it is defined in platform_data
(which is disabled because there is still some CONFIG_OF dependency).

Anyway, the above comment and patch subject should refer to platform
data instead.

If you can send an updated version of this patch you get my
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

> +		if (pdata->clkout[n].rate != 0) {
> +			int ret;
> +			ret = clk_set_rate(clk, pdata->clkout[n].rate);
> +			if (ret != 0) {
> +				dev_err(&client->dev, "Cannot set rate : %d\n",
> +					ret);
> +			}
> +		}
>   	}
>
>   	ret = of_clk_add_provider(client->dev.of_node, of_clk_src_onecell_get,

