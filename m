Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab3IHMsq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 08:48:46 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:37474 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab3IHMsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 08:48:45 -0400
Message-ID: <522C8044.6090502@kernel.org>
Date: Sun, 08 Sep 2013 14:48:52 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Derek Basehore <dbasehore@chromium.org>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>, Bryan Freed <bfreed@chromium.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: isl29018: Fix uninitialized value
References: <1377807250-30150-1-git-send-email-dbasehore@chromium.org>
In-Reply-To: <1377807250-30150-1-git-send-email-dbasehore@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/13 21:14, Derek Basehore wrote:
> The lux_uscale value is not initialized at probe. The value will be
> uninitialized unless a value is written to it through the iio channel interface.
> This fixes that.
> 
> Signed-off-by: Derek Basehore <dbasehore@chromium.org>
> Reviewed-on: https://gerrit.chromium.org/gerrit/65998
Thanks,
Applied to the fixes-togreg branch of iio.git

I'll send this onwards in a few days.

Jonathan
> ---
>  drivers/staging/iio/light/isl29018.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
> index 82478a5..28c6386 100644
> --- a/drivers/staging/iio/light/isl29018.c
> +++ b/drivers/staging/iio/light/isl29018.c
> @@ -564,6 +564,7 @@ static int isl29018_probe(struct i2c_client *client,
>  	mutex_init(&chip->lock);
>  
>  	chip->lux_scale = 1;
> +	chip->lux_uscale = 0;
>  	chip->range = 1000;
>  	chip->adc_bit = 16;
>  	chip->suspended = false;
> 
