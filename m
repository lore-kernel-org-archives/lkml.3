Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760805Ab3GSRGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:06:14 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:35249 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3GSRGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:06:13 -0400
Message-ID: <51E97201.4010508@free-electrons.com>
Date: Fri, 19 Jul 2013 19:06:09 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Hector Palacios <hector.palacios@digi.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, marex@denx.de, jic23@kernel.org,
        lars@metafoo.de, fabio.estevam@freescale.com
Subject: Re: [PATCH v2 3/5] iio: mxs-lradc: add scale attribute to channels
References: <1374225208-28940-1-git-send-email-hector.palacios@digi.com> <1374225208-28940-4-git-send-email-hector.palacios@digi.com>
In-Reply-To: <1374225208-28940-4-git-send-email-hector.palacios@digi.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hector,

On 19/07/2013 11:13, Hector Palacios wrote:
> Some LRADC channels have fixed pre-dividers and all have an optional
> divider by two which allows a maximum input voltage of VDDIO - 50mV.
>
> This patch
>  - adds the scaling info flag to all channels
>  - grabs the max reference voltage per channel from DT
>    (where the fixed pre-dividers apply)
>  - allows to read the scaling attribute (computed from the Vref)
>
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>.
> ---
>  drivers/staging/iio/adc/mxs-lradc.c | 81 ++++++++++++++++++++++++-------------
>  1 file changed, 52 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
> index 91282dc..99e5790 100644
> --- a/drivers/staging/iio/adc/mxs-lradc.c
> +++ b/drivers/staging/iio/adc/mxs-lradc.c
> @@ -141,6 +141,8 @@ struct mxs_lradc {
>  
>  	struct completion	completion;
>  
> +	uint32_t		vref_mv[LRADC_MAX_TOTAL_CHANS];
> +
>  	/*
>  	 * Touchscreen LRADC channels receives a private slot in the CTRL4
>  	 * register, the slot #7. Therefore only 7 slots instead of 8 in the
> @@ -228,39 +230,12 @@ struct mxs_lradc {
>  #define LRADC_RESOLUTION			12
>  #define LRADC_SINGLE_SAMPLE_MASK		((1 << LRADC_RESOLUTION) - 1)
>  
> -/*
> - * Raw I/O operations
> - */
> -static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
> +static int mxs_lradc_read_single(struct iio_dev *iio_dev,
>  			const struct iio_chan_spec *chan,
>  			int *val, int *val2, long m)
You don't need val2 and m in that function, I woud suggest no passing
those. Also, in my patch, I was passing channel->chan as an int but I
don't see any drawbacks of passing a pointer to the struct iio_chan_spec.

As a note, I'm waiting for your patch to get included so that we won't
get any conflicts.

Regards,

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

