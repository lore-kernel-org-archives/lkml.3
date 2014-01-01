Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaAAMf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 07:35:58 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45917 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbaAAMf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 07:35:56 -0500
Message-ID: <52C40BAB.4060703@kernel.org>
Date: Wed, 01 Jan 2014 12:35:55 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:iio: correct error check
References: <1388581641-26782-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1388581641-26782-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/01/14 13:07, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> iio_kfifo_allocate returns NULL in case of error.
>
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression *x;
> identifier f;
> statement S1,S2;
> @@
>
> *x = f(...);
>   if (x) { <+... when != if (...) S1 else S2
>       -ENOMEM ...+> }
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Thanks. Certainly an 'interesting' bit of code :(

Applied to the fixes-togreg branch of iio.git. Giving timing in the 
current cycle and that it isn't a recent regression, this won't go
in now until after 3.13 is released.

I've marked it for stable as well

Jonathan
>
> ---
>   drivers/staging/iio/impedance-analyzer/ad5933.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/iio/impedance-analyzer/ad5933.c b/drivers/staging/iio/impedance-analyzer/ad5933.c
> index 0a4298b..2b96665 100644
> --- a/drivers/staging/iio/impedance-analyzer/ad5933.c
> +++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
> @@ -629,7 +629,7 @@ static int ad5933_register_ring_funcs_and_init(struct iio_dev *indio_dev)
>   	struct iio_buffer *buffer;
>
>   	buffer = iio_kfifo_allocate(indio_dev);
> -	if (buffer)
> +	if (!buffer)
>   		return -ENOMEM;
>
>   	iio_device_attach_buffer(indio_dev, buffer);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
