Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750989AbaABBzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 20:55:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:48488 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbaABBzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 20:55:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,588,1384329600"; 
   d="scan'208";a="458830234"
Message-ID: <1388627730.3739.67.camel@rzhang1-mobl4>
Subject: Re: [PATCH 23/25] thermal: exynos: fix error return code
From: Zhang Rui <rui.zhang@intel.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 02 Jan 2014 09:55:30 +0800
In-Reply-To: <1388357260-4843-24-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1388357260-4843-24-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-29 at 23:47 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Set the return variable to an error code as done elsewhere in the function.
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

applied.

thanks,
rui
> 
> ---
> Not tested.
> 
>  drivers/thermal/samsung/exynos_tmu.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index 32f38b9..0d96a51 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -205,6 +205,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>  skip_calib_data:
>  	if (pdata->max_trigger_level > MAX_THRESHOLD_LEVS) {
>  		dev_err(&pdev->dev, "Invalid max trigger level\n");
> +		ret = -EINVAL;
>  		goto out;
>  	}
>  
> 


