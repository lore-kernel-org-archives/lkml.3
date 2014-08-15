Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaHOQwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:52:08 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:43960 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaHOQwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:52:03 -0400
Date: Fri, 15 Aug 2014 09:51:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjun Sreedharan <arjun024@gmail.com>
Cc: lejun.zhu@linux.intel.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove explicit devm_kfree
Message-ID: <20140815165158.GA25225@core.coreip.homeip.net>
References: <1408116365-3013-1-git-send-email-arjun024@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408116365-3013-1-git-send-email-arjun024@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 08:56:05PM +0530, Arjun Sreedharan wrote:
> Memory allocated with devm_kzalloc() is freed automatically when device
> out of scope.

But in this case the device does not necessarily goes "out of scope" and we
still want to release memory.

Thanks.

> 
> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
> ---
>  drivers/input/misc/soc_button_array.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/input/misc/soc_button_array.c b/drivers/input/misc/soc_button_array.c
> index 5a6334b..123e59f 100644
> --- a/drivers/input/misc/soc_button_array.c
> +++ b/drivers/input/misc/soc_button_array.c
> @@ -131,7 +131,6 @@ soc_button_device_create(struct pnp_dev *pdev,
>  err_free_pdev:
>  	platform_device_put(pd);
>  err_free_mem:
> -	devm_kfree(&pdev->dev, gpio_keys_pdata);
>  	return ERR_PTR(error);
>  }
>  
> -- 
> 1.7.11.7
> 

-- 
Dmitry
