Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679Ab3JPNYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:24:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53863 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760554Ab3JPNYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:24:49 -0400
Message-ID: <525E9380.7090905@ti.com>
Date: Wed, 16 Oct 2013 08:24:16 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <khilman@kernel.org>, <anton@enomsg.org>, <dwmw2@infradead.org>
Subject: Re: [PATCH] PM/AVS: SmartReflex: fix fake probe success on debugfs
 fail
References: <1381923650-7556-1-git-send-email-manishv.b@ti.com>
In-Reply-To: <1381923650-7556-1-git-send-email-manishv.b@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 06:40 AM, Vishwanathrao Badarkhe, Manish wrote:
> From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
> 
> Currently, probe returns success(0) on "debugfs_create_dir"
> function call failed. Return proper error on "debugfs_create_dir"
> call failed.
> 
> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> ---
> Not tested on any EVM. Bug has been found while doing static review.
> Please confirm.


IMHO, fail of creation of debugfs is not reason enough to fail the
probe - further, this code needs a major revamp to work with device tree.

> 
> :100644 100644 db9973b... 7b101c1... M	drivers/power/avs/smartreflex.c
>  drivers/power/avs/smartreflex.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
> index db9973b..7b101c1 100644
> --- a/drivers/power/avs/smartreflex.c
> +++ b/drivers/power/avs/smartreflex.c
> @@ -921,7 +921,7 @@ static int __init omap_sr_probe(struct platform_device *pdev)
>  	if (!sr_dbg_dir) {
>  		sr_dbg_dir = debugfs_create_dir("smartreflex", NULL);
>  		if (IS_ERR_OR_NULL(sr_dbg_dir)) {
> -			ret = PTR_ERR(sr_dbg_dir);
> +			ret = sr_dbg_dir ? PTR_ERR(sr_dbg_dir) : -EIO;
>  			pr_err("%s:sr debugfs dir creation failed(%d)\n",
>  				__func__, ret);
>  			goto err_list_del;
> @@ -932,7 +932,7 @@ static int __init omap_sr_probe(struct platform_device *pdev)
>  	if (IS_ERR_OR_NULL(sr_info->dbg_dir)) {
>  		dev_err(&pdev->dev, "%s: Unable to create debugfs directory\n",
>  			__func__);
> -		ret = PTR_ERR(sr_info->dbg_dir);
> +		ret = sr_info->dbg_dir ? PTR_ERR(sr_info->dbg_dir) : -EIO;
>  		goto err_debugfs;
>  	}
>  
> @@ -947,7 +947,7 @@ static int __init omap_sr_probe(struct platform_device *pdev)
>  	if (IS_ERR_OR_NULL(nvalue_dir)) {
>  		dev_err(&pdev->dev, "%s: Unable to create debugfs directory"
>  			"for n-values\n", __func__);
> -		ret = PTR_ERR(nvalue_dir);
> +		ret = nvalue_dir ? PTR_ERR(nvalue_dir) : -EIO;
>  		goto err_debugfs;
>  	}
>  
> 

-- 
Regards,
Nishanth Menon
