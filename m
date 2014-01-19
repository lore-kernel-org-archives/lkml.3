Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaASUEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 15:04:55 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:48086 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaASUEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 15:04:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: i2c: mt9v032: Check return value of clk_prepare_enable/clk_set_rate
Date: Sun, 19 Jan 2014 21:05:34 +0100
Message-ID: <2157121.3izth3cqlo@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.25-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1389950567-32577-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1389950567-32577-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thank you for the patch.

On Friday 17 January 2014 14:52:47 Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> clk_set_rate(), clk_prepare_enable() functions can fail, so check the return
> values to avoid surprises.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've applied the patch to my tree and will send a pull request.

> ---
>  drivers/media/i2c/mt9v032.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 36c504b..40172b8 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -317,8 +317,14 @@ static int mt9v032_power_on(struct mt9v032 *mt9v032)
>  	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
>  	int ret;
> 
> -	clk_set_rate(mt9v032->clk, mt9v032->sysclk);
> -	clk_prepare_enable(mt9v032->clk);
> +	ret = clk_set_rate(mt9v032->clk, mt9v032->sysclk);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = clk_prepare_enable(mt9v032->clk);
> +	if (ret)
> +		return ret;
> +
>  	udelay(1);
> 
>  	/* Reset the chip and stop data read out */
-- 
Regards,

Laurent Pinchart

