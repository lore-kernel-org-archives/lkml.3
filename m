Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab3FDR25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:28:57 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:51073 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3FDR24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:28:56 -0400
Message-ID: <51AE23D7.8030507@kernel.org>
Date: Tue, 04 Jun 2013 18:28:55 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 2/4] inkern: iio_device_put after incorrect return/goto
References: <60123fd3175b7cceadf6c335b12e58b797e18f65.1370356776.git.joe@perches.com> <d0f7d0eef677250c457c08c8f8ca7e125811f754.1370356776.git.joe@perches.com>
In-Reply-To: <d0f7d0eef677250c457c08c8f8ca7e125811f754.1370356776.git.joe@perches.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 03:44 PM, Joe Perches wrote:
> The code uses
> 
>     return foo;
>     goto err_type;
> 
> when instead the form should have been
> 
>     ret = foo;
>     goto err_type;
> 
> Here this causes a useful iio_device_put to be skipped.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
Applied to fixes-togreg branch of iio.git

Thanks,
> ---
>  drivers/iio/inkern.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> index 795d100..dca4eed 100644
> --- a/drivers/iio/inkern.c
> +++ b/drivers/iio/inkern.c
> @@ -124,7 +124,7 @@ static int __of_iio_channel_get(struct iio_channel *channel,
>  	channel->indio_dev = indio_dev;
>  	index = iiospec.args_count ? iiospec.args[0] : 0;
>  	if (index >= indio_dev->num_channels) {
> -		return -EINVAL;
> +		err = -EINVAL;
>  		goto err_put;
>  	}
>  	channel->channel = &indio_dev->channels[index];
> 
