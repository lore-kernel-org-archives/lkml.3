Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3IJLUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 07:20:24 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:36574 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3IJLUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 07:20:21 -0400
Date: Tue, 10 Sep 2013 12:20:14 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        Jin Park <jinyoungp@nvidia.com>
Subject: Re: [PATCH 1/1] mfd: aat2870: Fix sparse error
Message-ID: <20130910112014.GE1456@lee--X1>
References: <1378810550-5450-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378810550-5450-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, Sachin Kamat wrote:

> Fixes the following error:
> drivers/mfd/aat2870-core.c:296:20: error:
> incompatible types in comparison expression (different type sizes)
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Jin Park <jinyoungp@nvidia.com>
> ---
>  drivers/mfd/aat2870-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/aat2870-core.c b/drivers/mfd/aat2870-core.c
> index 6f68472..14d9542 100644
> --- a/drivers/mfd/aat2870-core.c
> +++ b/drivers/mfd/aat2870-core.c
> @@ -293,7 +293,7 @@ static ssize_t aat2870_reg_write_file(struct file *file,
>  	unsigned long addr, val;
>  	int ret;
>  
> -	buf_size = min(count, (sizeof(buf)-1));
> +	buf_size = min(count, (size_t)(sizeof(buf)-1));
>  	if (copy_from_user(buf, user_buf, buf_size)) {
>  		dev_err(aat2870->dev, "Failed to copy from user\n");
>  		return -EFAULT;

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
