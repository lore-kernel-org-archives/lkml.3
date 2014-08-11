Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaHKKZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 06:25:38 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:37378 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaHKKZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:25:36 -0400
Message-ID: <53E89A1A.2060600@atmel.com>
Date: Mon, 11 Aug 2014 12:25:30 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: <kernel-janitors@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] drivers: video: fbdev: atmel_lcdfb.c: fix error return
 code
References: <1407355938-10932-4-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1407355938-10932-4-git-send-email-Julia.Lawall@lip6.fr>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2014 22:12, Julia Lawall :
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

Okay, seems good patch:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks, best regards,

> ---
> The error codes chosen are the ones that are commonly used elsewhere or
> these functions.  Perhaps something else is wanted.
> 
>  drivers/video/fbdev/atmel_lcdfb.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/video/fbdev/atmel_lcdfb.c b/drivers/video/fbdev/atmel_lcdfb.c
> index 92640d4..1d8bdb9 100644
> --- a/drivers/video/fbdev/atmel_lcdfb.c
> +++ b/drivers/video/fbdev/atmel_lcdfb.c
> @@ -1102,12 +1102,14 @@ static int atmel_lcdfb_of_init(struct atmel_lcdfb_info *sinfo)
>  	timings = of_get_display_timings(display_np);
>  	if (!timings) {
>  		dev_err(dev, "failed to get display timings\n");
> +		ret = -EINVAL;
>  		goto put_display_node;
>  	}
>  
>  	timings_np = of_find_node_by_name(display_np, "display-timings");
>  	if (!timings_np) {
>  		dev_err(dev, "failed to find display-timings node\n");
> +		ret = -ENODEV;
>  		goto put_display_node;
>  	}
>  
> 
> 


-- 
Nicolas Ferre
