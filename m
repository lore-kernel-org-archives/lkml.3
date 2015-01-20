Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbbATOU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:20:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:8193 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbbATOU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:20:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442727667"
Message-ID: <1421763532.31903.71.camel@linux.intel.com>
Subject: Re: [PATCH] dmaengine: dw: support for clockless platforms
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Date: Tue, 20 Jan 2015 16:18:52 +0200
In-Reply-To: <1421758677-183443-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1421758677-183443-1-git-send-email-heikki.krogerus@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 14:57 +0200, Heikki Krogerus wrote:
> When requesting clock in the platform driver, leaving
> chip->clk value as NULL if -ENOENT is returned, and
> continue. With other errors returning failure. It makes the
> driver usable on platforms that do not provide the clock.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> ---
>  drivers/dma/dw/platform.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/dw/platform.c b/drivers/dma/dw/platform.c
> index 32ea1ac..b183bc0 100644
> --- a/drivers/dma/dw/platform.c
> +++ b/drivers/dma/dw/platform.c
> @@ -180,8 +180,12 @@ static int dw_probe(struct platform_device *pdev)
>  	chip->dev = dev;
>  
>  	chip->clk = devm_clk_get(chip->dev, "hclk");
> -	if (IS_ERR(chip->clk))
> -		return PTR_ERR(chip->clk);
> +	if (IS_ERR(chip->clk)) {
> +		if (PTR_ERR(chip->clk) == -ENOENT)
> +			chip->clk = NULL;
> +		else
> +			return PTR_ERR(chip->clk);
> +	}
>  	err = clk_prepare_enable(chip->clk);
>  	if (err)
>  		return err;


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

