Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3IVRDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 13:03:38 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:42561 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3IVRDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 13:03:37 -0400
Message-ID: <523F3109.8000600@kernel.org>
Date: Sun, 22 Sep 2013 19:03:53 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/3] iio: ti_am335x_adc: fix static in function header
References: <1379838005-15158-1-git-send-email-zubair.lutfullah@gmail.com> <1379838005-15158-2-git-send-email-zubair.lutfullah@gmail.com>
In-Reply-To: <1379838005-15158-2-git-send-email-zubair.lutfullah@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/13 09:20, Zubair Lutfullah wrote:
> Static is missing in function header. Corrected.
> 
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Applied to the togreg branch of iio.git

As you've probably gathered, a run of sparse on your code before posting is a
great way to pick up on little things like this.  Also, coccinelle and
smatch if you want to do a thorough job - each gets a slightly different
set of common bugs.  I tend to run some combination of those, but wasn't
set up to build this driver so didn't pick up on this.

Another one clocked up to the autobuilders.  Note it is normal to give
a reported-by line to give them some credit. I've added one.

Jonathan
> ---
>  drivers/iio/adc/ti_am335x_adc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index 5287bff..91dce1f 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -226,7 +226,7 @@ static const struct iio_buffer_setup_ops tiadc_buffer_setup_ops = {
>  	.postdisable = &tiadc_buffer_postdisable,
>  };
>  
> -int tiadc_iio_buffered_hardware_setup(struct iio_dev *indio_dev,
> +static int tiadc_iio_buffered_hardware_setup(struct iio_dev *indio_dev,
>  	irqreturn_t (*pollfunc_bh)(int irq, void *p),
>  	irqreturn_t (*pollfunc_th)(int irq, void *p),
>  	int irq,
> 
