Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaGaGBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:01:44 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46361 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaGaGBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:01:43 -0400
Date: Wed, 30 Jul 2014 23:01:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pramod Gurav <pramod.gurav.etc@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Lejun Zhu <lejun.zhu@linux.intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH] input: ads7846: Release resources on failure for clean
 exit
Message-ID: <20140731060138.GB4844@core.coreip.homeip.net>
References: <1406699677-1347-1-git-send-email-pramod.gurav.etc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406699677-1347-1-git-send-email-pramod.gurav.etc@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 11:24:37AM +0530, Pramod Gurav wrote:
> From: Pramod Gurav <pramod.gurav@smartplayin.com>
> 
> Input device must be released(input_free_device) when ads7846_probe_dt
> fails. This fixes the same by releasing resources on failure.
> 
> CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> CC: Lejun Zhu <lejun.zhu@linux.intel.com>
> CC: Sachin Kamat <sachin.kamat@linaro.org>
> 
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Applied, thank you.

> ---
>  drivers/input/touchscreen/ads7846.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
> index da201b8..e57ba52 100644
> --- a/drivers/input/touchscreen/ads7846.c
> +++ b/drivers/input/touchscreen/ads7846.c
> @@ -1302,8 +1302,10 @@ static int ads7846_probe(struct spi_device *spi)
>  	pdata = dev_get_platdata(&spi->dev);
>  	if (!pdata) {
>  		pdata = ads7846_probe_dt(&spi->dev);
> -		if (IS_ERR(pdata))
> -			return PTR_ERR(pdata);
> +		if (IS_ERR(pdata)) {
> +			err = PTR_ERR(pdata);
> +			goto err_free_mem;
> +		}
>  	}
>  
>  	ts->model = pdata->model ? : 7846;
> -- 
> 1.7.9.5
> 

-- 
Dmitry
