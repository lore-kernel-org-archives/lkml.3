Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763068Ab3ECKFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 06:05:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44350 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760354Ab3ECKFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 06:05:45 -0400
Message-ID: <51838BF4.9050207@gmail.com>
Date: Fri, 03 May 2013 12:05:40 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Marek Belisko <marek.belisko@gmail.com>
CC: mturquette@linaro.org, zonque@gmail.com,
        vladimir.koutny@streamunlimited.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: Re: [PATCH v2 2/2] clk: si5351: Set initial clkout rate when defined
 in platform data.
References: <1367560403-21685-1-git-send-email-marek.belisko@streamunlimited.com> <1367560403-21685-2-git-send-email-marek.belisko@streamunlimited.com>
In-Reply-To: <1367560403-21685-2-git-send-email-marek.belisko@streamunlimited.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 07:53 AM, Marek Belisko wrote:
> Signed-off-by: Marek Belisko<marek.belisko@streamunlimited.com>
> ---
> Changes v1->v2:
> - update commit message and comment to refer to platform data not DT

Marek,

except that the commit msg itself is very short (there is no!) you can
add my

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Next time sending patches for clk-si5351, please ensure you are using
get_maintainers.pl and add me to the list of people to Cc also.

Sebastian

>   drivers/clk/clk-si5351.c |   10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
> index cf39e53..24f5536 100644
> --- a/drivers/clk/clk-si5351.c
> +++ b/drivers/clk/clk-si5351.c
> @@ -1477,6 +1477,16 @@ static int si5351_i2c_probe(struct i2c_client *client,
>   			return -EINVAL;
>   		}
>   		drvdata->onecell.clks[n] = clk;
> +
> +		/* set initial clkout rate */
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

