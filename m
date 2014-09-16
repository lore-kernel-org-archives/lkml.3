Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaIPXC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:02:26 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:59045 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaIPXCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:02:24 -0400
Date: Tue, 16 Sep 2014 16:01:41 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND] mfd: max14577: Don't pass IRQ domain to mfd_add_devices
Message-ID: <20140916230141.GT25162@lee--X1>
References: <1409912110-18120-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409912110-18120-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Sep 2014, Krzysztof Kozlowski wrote:

> The max14577 MFD cells do not have any resources so the IRQ domain
> passed to mfd_add_devices is not used.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/max14577.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> index 4a5e885383f8..ba2ac9c10b12 100644
> --- a/drivers/mfd/max14577.c
> +++ b/drivers/mfd/max14577.c
> @@ -372,8 +372,7 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
>  	}
>  
>  	ret = mfd_add_devices(max14577->dev, -1, mfd_devs,
> -			mfd_devs_size, NULL, 0,
> -			regmap_irq_get_domain(max14577->irq_data));
> +			mfd_devs_size, NULL, 0, NULL);
>  	if (ret < 0)
>  		goto err_mfd;
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
