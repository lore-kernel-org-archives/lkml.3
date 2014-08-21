Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaHUIU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:20:57 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:57965 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbaHUIUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:20:54 -0400
Date: Thu, 21 Aug 2014 09:20:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Samuel Ortiz <sameo@linux.intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mfd: twl6040: fix error return code
Message-ID: <20140821082049.GR4266@lee--X1>
References: <1407355938-10932-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407355938-10932-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug 2014, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Convert a zero return value on error to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> 
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/mfd/twl6040.c |    1 +
>  1 file changed, 1 insertion(+)

Applied, thanks.

> diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
> index f9c06c5..9687645 100644
> --- a/drivers/mfd/twl6040.c
> +++ b/drivers/mfd/twl6040.c
> @@ -679,6 +679,7 @@ static int twl6040_probe(struct i2c_client *client,
>  	if (twl6040->rev < 0) {
>  		dev_err(&client->dev, "Failed to read revision register: %d\n",
>  			twl6040->rev);
> +		ret = twl6040->rev;
>  		goto gpio_err;
>  	}
>  
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
