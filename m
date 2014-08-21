Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaHUIhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:37:25 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:52813 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbaHUIhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:37:21 -0400
Date: Thu, 21 Aug 2014 09:37:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] mfd: menelaus: remove null pointer dereference
Message-ID: <20140821083716.GU4266@lee--X1>
References: <20140809164027.GA20561@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140809164027.GA20561@himangi-Dell>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 Aug 2014, Himangi Saraogi wrote:

> If vtg is NULL, it is not possible to access its mode_reg field. At all
> sites where the static function menelaus_set_voltage is called, the first
> argument is the address of a structure defined in the file. So, the null
> test is unnecessary and is removed. Also, a label is done away with.
> 
> This problem was found using the following Coccinelle semantic match:
> 
> // <smpl>
> @@
> expression E, E1;
> identifier f;
> statement S1,S2,S3;
> @@
> 
> * if (E == NULL)
> {
>   ... when != if (E == NULL) S1 else S2
>       when != E = E1
> * E->f
>   ... when any
>   return ...;
> }
> else S3
> // </smpl>
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> Not compile tested.
>  drivers/mfd/menelaus.c | 3 ---
>  1 file changed, 3 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
> index 5e2667a..18ff56f 100644
> --- a/drivers/mfd/menelaus.c
> +++ b/drivers/mfd/menelaus.c
> @@ -466,8 +466,6 @@ static int menelaus_set_voltage(const struct menelaus_vtg *vtg, int mV,
>  	struct i2c_client *c = the_menelaus->client;
>  
>  	mutex_lock(&the_menelaus->lock);
> -	if (!vtg)
> -		goto set_voltage;
>  
>  	ret = menelaus_read_reg(vtg->vtg_reg);
>  	if (ret < 0)
> @@ -482,7 +480,6 @@ static int menelaus_set_voltage(const struct menelaus_vtg *vtg, int mV,
>  	ret = menelaus_write_reg(vtg->vtg_reg, val);
>  	if (ret < 0)
>  		goto out;
> -set_voltage:
>  	ret = menelaus_write_reg(vtg->mode_reg, mode);
>  out:
>  	mutex_unlock(&the_menelaus->lock);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
