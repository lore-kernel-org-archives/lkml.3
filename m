Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaBNJhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:37:42 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61646 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaBNJhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:37:39 -0500
Date: Fri, 14 Feb 2014 09:37:33 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: wm8400-core: Remove unnecessary goto
Message-ID: <20140214093733.GJ3403@lee--X1>
References: <1392196213-20576-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392196213-20576-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Return directly to avoid redundant lines of code.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/wm8400-core.c |   22 +++++-----------------
>  1 file changed, 5 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
> index d66d256551fb..8788fd1f0a83 100644
> --- a/drivers/mfd/wm8400-core.c
> +++ b/drivers/mfd/wm8400-core.c
> @@ -161,31 +161,19 @@ static int wm8400_i2c_probe(struct i2c_client *i2c,
>  			    const struct i2c_device_id *id)
>  {
>  	struct wm8400 *wm8400;
> -	int ret;
>  
>  	wm8400 = devm_kzalloc(&i2c->dev, sizeof(struct wm8400), GFP_KERNEL);
> -	if (wm8400 == NULL) {
> -		ret = -ENOMEM;
> -		goto err;
> -	}
> +	if (wm8400 == NULL)

While you're here please change this to the preferred 'if (!wm8400)'.

<snip>

Otherwise nice clean-up.

When you fix the above and resubmit, do so with my:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
