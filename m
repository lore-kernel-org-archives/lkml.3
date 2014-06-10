Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaFJWvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 18:51:41 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:47417 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaFJWvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 18:51:39 -0400
X-Auth-Info: 8okW4JFuJpL4Al6OvJ81mk6m3kPE4lZPHbH9Hb95p0k=
From: Marek Vasut <marex@denx.de>
To: Robert Hodaszi <robert.hodaszi@digi.com>
Subject: Re: [PATCH 2/2] iio: mxs-lradc: add ADC channel 9 as a copy of channel 8
Date: Wed, 11 Jun 2014 00:51:34 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: jic23@kernel.org, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, alexandre.belloni@free-electrons.com,
        jbe@pengutronix.de, hector.palacios@digi.com,
        fabio.estevam@freescale.com, lars@metafoo.de
References: <1402407695-2984-1-git-send-email-robert.hodaszi@digi.com> <1402407695-2984-3-git-send-email-robert.hodaszi@digi.com>
In-Reply-To: <1402407695-2984-3-git-send-email-robert.hodaszi@digi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201406110051.34455.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 10, 2014 at 03:41:35 PM, Robert Hodaszi wrote:
> Commit c8231a9af8147f8a401fc55931ec44abfb937660 ("iio: mxs-lradc: compute
> temperature from channel 8 and 9") merged channel 8 and channel 9 to create
> an IIO_TEMP channel. It changed the number of LRADC channels, which could
> cause incompatibility with previous device-tree declarations, and also
> makes it illogical (e.g. channel 15 is <&lradc 14>).
> 
> Add channel 9 as a copy of channel 8. Reading channel 9 has the same output
> as reading channel 8.
> 
> Signed-off-by: Robert Hodaszi <robert.hodaszi@digi.com>
> ---

[...]

>  static const struct iio_chan_spec mxs_lradc_chan_spec[] = {
> -	MXS_ADC_CHAN(0, IIO_VOLTAGE),
> -	MXS_ADC_CHAN(1, IIO_VOLTAGE),
> -	MXS_ADC_CHAN(2, IIO_VOLTAGE),
> -	MXS_ADC_CHAN(3, IIO_VOLTAGE),
> -	MXS_ADC_CHAN(4, IIO_VOLTAGE),
> -	MXS_ADC_CHAN(5, IIO_VOLTAGE),
> -	MXS_ADC_CHAN(6, IIO_VOLTAGE),
> -	MXS_ADC_CHAN(7, IIO_VOLTAGE),	/* VBATT */
> +	MXS_ADC_VOLTAGE_CHAN(0),
> +	MXS_ADC_VOLTAGE_CHAN(1),
> +	MXS_ADC_VOLTAGE_CHAN(2),
> +	MXS_ADC_VOLTAGE_CHAN(3),
> +	MXS_ADC_VOLTAGE_CHAN(4),
> +	MXS_ADC_VOLTAGE_CHAN(5),
> +	MXS_ADC_VOLTAGE_CHAN(6),
> +	MXS_ADC_VOLTAGE_CHAN(7),	/* VBATT */
>  	/* Combined Temperature sensors */
> -	{
> -		.type = IIO_TEMP,
> -		.indexed = 1,
> -		.scan_index = 8,
> -		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
> -				      BIT(IIO_CHAN_INFO_OFFSET) |
> -				      BIT(IIO_CHAN_INFO_SCALE),
> -		.channel = 8,
> -		.scan_type = {.sign = 'u', .realbits = 18, .storagebits = 32,},
> -	},

I wonder, shouldn't the IIO framework handle this kind of a "hole" in the 
iio_chan_spec structure, where one entry has .channel = N and the subsequent one 
has .channel = N + 2 somehow ?

> -	MXS_ADC_CHAN(10, IIO_VOLTAGE),	/* VDDIO */
> -	MXS_ADC_CHAN(11, IIO_VOLTAGE),	/* VTH */
> -	MXS_ADC_CHAN(12, IIO_VOLTAGE),	/* VDDA */
> -	MXS_ADC_CHAN(13, IIO_VOLTAGE),	/* VDDD */
> -	MXS_ADC_CHAN(14, IIO_VOLTAGE),	/* VBG */
> -	MXS_ADC_CHAN(15, IIO_VOLTAGE),	/* VDD5V */

[...]
