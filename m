Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024Ab3CLQKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:10:45 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:44416 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755465Ab3CLQKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:10:44 -0400
Message-ID: <513F5382.8080708@slimlogic.co.uk>
Date: Tue, 12 Mar 2013 16:10:42 +0000
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: palmas: Use of_property_read_bool to read
 "ti,warm-reset" DT property
References: <1363102819.3160.1.camel@phoenix>
In-Reply-To: <1363102819.3160.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for catching that typo

Acked-by: Graeme Gregory <gg@slimlogic.co.uk>

On 12/03/13 15:40, Axel Lin wrote:
> It does not make sense to assign return value of of_property_read_u32() to
> pdata->reg_init[idx]->warm_reset. Use of_property_read_bool() to read
> "ti,warm-reset" DT property instead which will return correct setting
> for pdata->reg_init[idx]->warm_reset.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/palmas-regulator.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index b2b1baa..a9b558e 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -554,8 +554,8 @@ static void palmas_dt_to_pdata(struct device *dev,
>  				sizeof(struct palmas_reg_init), GFP_KERNEL);
>  
>  		pdata->reg_init[idx]->warm_reset =
> -			of_property_read_u32(palmas_matches[idx].of_node,
> -					     "ti,warm-reset", &prop);
> +			of_property_read_bool(palmas_matches[idx].of_node,
> +					     "ti,warm-reset");
>  
>  		pdata->reg_init[idx]->roof_floor =
>  			of_property_read_bool(palmas_matches[idx].of_node,

