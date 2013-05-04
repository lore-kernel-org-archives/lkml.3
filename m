Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541Ab3EDPTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 11:19:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55965 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760438Ab3EDPT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 11:19:29 -0400
Date: Sat, 4 May 2013 10:19:23 -0500
From: Nishanth Menon <nm@ti.com>
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@kernel.org>,
        "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: ti-abb: Fix off-by-one valid range checking
 for abb->current_info_idx
Message-ID: <20130504151752.GA2801@snafu>
References: <1367676147.5124.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1367676147.5124.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change in Liam's email ID.
On 22:02-20130504, Axel Lin wrote:
> abb->current_info_idx is used as array subscript to access volt_table,
> thus the valid value range should be 0 ... desc->n_voltages - 1.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/ti-abb-regulator.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
> index c1870ea..870d209 100644
> --- a/drivers/regulator/ti-abb-regulator.c
> +++ b/drivers/regulator/ti-abb-regulator.c
> @@ -387,8 +387,8 @@ static int ti_abb_get_voltage_sel(struct regulator_dev *rdev)
>  		return -EINVAL;
>  	}
>  
> -	if (abb->current_info_idx > (int)desc->n_voltages) {
> -		dev_err(dev, "%s: Corrupted data? idx(%d) > n_voltages(%d)\n",
> +	if (abb->current_info_idx >= (int)desc->n_voltages) {
> +		dev_err(dev, "%s: Corrupted data? idx(%d) >= n_voltages(%d)\n",
>  			__func__, abb->current_info_idx, desc->n_voltages);
>  		return -EINVAL;
>  	}
> -- 
> 1.8.1.2

Thanks for the same.
Acked-by: Nishanth Menon <nm@ti.com>

-- 
Regards,
Nishanth Menon
