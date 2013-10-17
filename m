Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762286Ab3JQRqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:46:18 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:15504 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259Ab3JQRqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:46:13 -0400
X-AuditID: cbfec372-b7fe76d000003347-2b-526022640654
Date: Thu, 17 Oct 2013 14:46:04 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, David Airlie <airlied@linux.ie>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 2/8] [media] exynos4-is: Don't use i2c_client->driver
Message-id: <20131017144604.1d649988@samsung.com>
In-reply-to: <1380444666-12019-3-git-send-email-lars@metafoo.de>
References: <1380444666-12019-1-git-send-email-lars@metafoo.de>
 <1380444666-12019-3-git-send-email-lars@metafoo.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t/hIN0UpYQgg6YHUha9504yWVy5eIjJ
	YurDJ2wWV76+Z7M42/SG3WLJ5PmsFt+udDBZdPz9wmhxedccNoueDVtZLTp39bNaHH7Tzmrx
	cvMbJouVJ2YxO/B5bPjcxOaxc9Zddo9NqzrZPLZ/e8Dqcb/7OJPHkjeHWD32vV3G5tG3ZRWj
	x+bT1R4nTz1h8fi8SS6AO4rLJiU1J7MstUjfLoEr49XXfUwFLbwVzW1trA2Mn7m6GDk5JARM
	JNq/72GEsMUkLtxbz9bFyMUhJLCEUeL2xEtQTjeTxJrnDWBVLAKqEm8nn2YDsdkEjCReNbaw
	gtgiAhoS/99MYgdpYBY4zCzx408fWIOwgKfEz7e/wIp4BQwl3u16yA5icwo4SLS+WAc0iANo
	Q6nE243aIKaEgJPE1qm+ENWCEj8m32MBsZkFtCQ2b2tihbDlJTavecs8gVFgFpKyWUjKZiEp
	W8DIvIpRtLQ4uaA4KT3XUK84Mbe4NC9dLzk/dxMjJMqKdjA+22B1iFGAg1GJh1fiZ3yQEGti
	WXFl7iFGCQ5mJRHeVuGEICHelMTKqtSi/Pii0pzU4kOMTBycUg2Mi0ouFB4VnJAzbUtm2RMn
	XdPZhix9QTWH/kUn7jpRdixwudOT9NjGS25hIVZLFs5ZN7lp4r118lzxKSvPKe9z2cHRrhme
	yriv4WqKclqb5YUpc/5wMzPOZA+ay8DKf8NQue7i2R0yzu+TSm9NCTG12+UVZWvpl/175s87
	l6XPG74Q/Saz9PlCJZbijERDLeai4kQAeJOrhJACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, 29 Sep 2013 10:51:00 +0200
Lars-Peter Clausen <lars@metafoo.de> escreveu:

> The 'driver' field of the i2c_client struct is redundant and is going to be
> removed. The results of the expressions 'client->driver.driver->field' and
> 'client->dev.driver->field' are identical, so replace all occurrences of the
> former with the later.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>

Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

> ---
>  drivers/media/platform/exynos4-is/media-dev.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
> index a835112..7a4ee4c 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -411,8 +411,8 @@ static int fimc_md_of_add_sensor(struct fimc_md *fmd,
>  
>  	device_lock(&client->dev);
>  
> -	if (!client->driver ||
> -	    !try_module_get(client->driver->driver.owner)) {
> +	if (!client->dev.driver ||
> +	    !try_module_get(client->dev.driver->owner)) {
>  		ret = -EPROBE_DEFER;
>  		v4l2_info(&fmd->v4l2_dev, "No driver found for %s\n",
>  						node->full_name);
> @@ -442,7 +442,7 @@ static int fimc_md_of_add_sensor(struct fimc_md *fmd,
>  	fmd->num_sensors++;
>  
>  mod_put:
> -	module_put(client->driver->driver.owner);
> +	module_put(client->dev.driver->owner);
>  dev_put:
>  	device_unlock(&client->dev);
>  	put_device(&client->dev);


-- 

Cheers,
Mauro
