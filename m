Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaARUdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 15:33:22 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:57314 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaARUdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 15:33:18 -0500
X-Auth-Info: jPNvxySUVBEIMq7ISOHu+xKB+u0+TzoJkm4oIpZHYu4=
From: Marek Vasut <marex@denx.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH v2] iio: mxs-lradc: remove useless check
Date: Sat, 18 Jan 2014 21:33:15 +0100
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
Cc: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1390071918-10622-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1390071918-10622-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201401182133.15839.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 18, 2014 at 08:05:18 PM, Alexandre Belloni wrote:
> Checking the channel number is useless since mxs_lradc_read_raw() is called
> from a controlled environment and the driver is responsible for filing the
> struct iio_chan_spec.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  drivers/staging/iio/adc/mxs-lradc.c | 4 ----
>  1 file changed, 4 deletions(-)

Changelog's missing ;-)

Acked-by: Marek Vasut <marex@denx.de>
 
> diff --git a/drivers/staging/iio/adc/mxs-lradc.c
> b/drivers/staging/iio/adc/mxs-lradc.c index 7fc66a6a6e36..d304156ca2f7
> 100644
> --- a/drivers/staging/iio/adc/mxs-lradc.c
> +++ b/drivers/staging/iio/adc/mxs-lradc.c
> @@ -897,10 +897,6 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
>  {
>  	struct mxs_lradc *lradc = iio_priv(iio_dev);
> 
> -	/* Check for invalid channel */
> -	if (chan->channel > LRADC_MAX_TOTAL_CHANS)
> -		return -EINVAL;
> -
>  	switch (m) {
>  	case IIO_CHAN_INFO_RAW:
>  		if (chan->type == IIO_TEMP)

Best regards,
Marek Vasut
