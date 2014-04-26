Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaDZKSE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 06:18:04 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:54907 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaDZKQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 06:16:57 -0400
Message-ID: <535B87F1.2030005@kernel.org>
Date: Sat, 26 Apr 2014 11:18:25 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Atilla Filiz <atilla.filiz@essensium.com>, jic23@cam.ac.uk
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed segfault in Invensens MPU driver
References: <XH2U0J49.1398421120.2347610.filiza@localhost>
In-Reply-To: <XH2U0J49.1398421120.2347610.filiza@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/14 11:18, Atilla Filiz wrote:
>
> Hello
>
> I found the Invensense MPU6050 driver is not Device-Tree compatible, so I
> fixed it. I willl appreciate if you CC your comments to myself.
>
> Regards
> Atilla
Hi Atilla,

Please send patches 'bare'.  If you want to add comments then they
go below the --- as then git am will ignore them.  If the comments are more
involved (or apply to a set of patches) then add a cover letter.  That way
you save me (or whoever else) 30 seconds of editing the patch before applying
it!
>
>  From 69995b31f67727e3b9605c494beaeeefd1aa1cd4 Mon Sep 17 00:00:00 2001
> From: Atilla Filiz <atilla.filiz@essensium.com>
> Date: Fri, 11 Apr 2014 16:51:23 +0200
> Subject: [PATCH] Fixed segfault in Invensens MPU driver
Please match the naming convention used in the area of the kernel to which
the patch is being applied.
>
> The driver used to segfault when the kernel boots
> vith device tree
>
> Signed-off-by: Atilla Filiz <atilla.filiz@essensium.com>
Applied with some edits to the patch description to the fixes-togreg branch of
iio.git.  I'll send this on to Greg fairly shortly.  I've also marked it for
stable so that we get this fix out to slightly older kernels.

Good find, thanks.

Jonathan
> ---
>   drivers/iio/imu/inv_mpu6050/inv_mpu_core.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
> b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
> index 37ca05b..3c2ef2e 100644
> --- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
> +++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
> @@ -660,6 +660,7 @@ static int inv_mpu_probe(struct i2c_client *client,
>   {
>   	struct inv_mpu6050_state *st;
>   	struct iio_dev *indio_dev;
> +	struct inv_mpu6050_platform_data *pdata;
>   	int result;
>
>   	if (!i2c_check_functionality(client->adapter,
> @@ -675,8 +676,10 @@ static int inv_mpu_probe(struct i2c_client *client,
>   	}
>   	st = iio_priv(indio_dev);
>   	st->client = client;
> -	st->plat_data = *(struct inv_mpu6050_platform_data
> -				*)dev_get_platdata(&client->dev);
> +	pdata = (struct inv_mpu6050_platform_data
> +			*)dev_get_platdata(&client->dev);
> +	if (pdata)
> +		st->plat_data = *pdata;
>   	/* power is turned on inside check chip type*/
>   	result = inv_check_and_setup_chip(st, id);
>   	if (result)
> --
> 1.8.1.2
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

