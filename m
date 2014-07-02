Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbaGBGvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 02:51:01 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:55800 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaGBGvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 02:51:00 -0400
Date: Wed, 2 Jul 2014 07:50:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] drivers/mfd/ab8500-debugfs.c: remove unnecessary
 null test before debugfs_remove_recursive
Message-ID: <20140702065053.GA10311@lee--X1>
References: <1403956697-3197-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403956697-3197-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2014, Fabian Frederick wrote:

> Fix checkpatch warning:
> WARNING: debugfs_remove_recursive(NULL) is safe this check is probably not required
> 
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/mfd/ab8500-debugfs.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
> index d1a22aa..7ca8713 100644
> --- a/drivers/mfd/ab8500-debugfs.c
> +++ b/drivers/mfd/ab8500-debugfs.c
> @@ -3192,8 +3192,7 @@ static int ab8500_debug_probe(struct platform_device *plf)
>  	return 0;
>  
>  err:
> -	if (ab8500_dir)
> -		debugfs_remove_recursive(ab8500_dir);
> +	debugfs_remove_recursive(ab8500_dir);
>  	dev_err(&plf->dev, "failed to create debugfs entries.\n");
>  
>  	return -ENOMEM;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
