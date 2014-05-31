Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbaEaKMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 06:12:47 -0400
Received: from mail.kernel.org ([198.145.19.201]:45925 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbaEaKMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 06:12:46 -0400
Message-ID: <5389AB89.9080305@kernel.org>
Date: Sat, 31 May 2014 11:14:33 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Reyad Attiyat <reyad.attiyat@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, srinivas.pandruvada@linux.intel.com,
        linux-input@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH 2/3] IIO: Add iio_chan modifier for True/Magnetic North
 HID usages
References: <1401311175-12784-1-git-send-email-reyad.attiyat@gmail.com> <1401311175-12784-3-git-send-email-reyad.attiyat@gmail.com>
In-Reply-To: <1401311175-12784-3-git-send-email-reyad.attiyat@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/05/14 22:06, Reyad Attiyat wrote:
> Updated iio_chan_info_enum for compass north sensor usages,
> including magnetic/true north and tilt compensation.
>
> Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
> ---
>   drivers/iio/industrialio-core.c | 4 ++++
>   include/linux/iio/types.h       | 4 ++++
>   2 files changed, 8 insertions(+)
>
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index ede16aec..41bd377 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -84,6 +84,10 @@ static const char * const iio_modifier_names[] = {
>   	[IIO_MOD_LIGHT_RED] = "red",
>   	[IIO_MOD_LIGHT_GREEN] = "green",
>   	[IIO_MOD_LIGHT_BLUE] = "blue",
> +	[IIO_MOD_MAGN_NORTH] = "north",
> +	[IIO_MOD_MAGN_NORTH_TRUE] = "north_true",
> +	[IIO_MOD_MAGN_NORTH_TILT_COMP] = "north_tilt_comp",
> +	[IIO_MOD_MAGN_NORTH_TRUE_TILT_COMP] = "north_true_tilt_comp",
>   };
I think we need the naming to explicitly mention north_magnetic instead
of just north.  Whilst it is obvious what north means when you have north
true alongside it, it won't be so obvious if one just has the north attribute
to see in a particular driver - if anything I'd have the true as the one
that was simply called north (as it might not be coming from a magnetometer
thought obviously that's the most common source)   I'd also rather the enum entries
were
IIO_MOD_NORTH_MAGN
IIO_MOD_NORTH_TRUE
IIO_MOD_NORTH_MAGN_TILT_COMP
IIO_MOD_NORTH_TRUE_TILT_COMP

It is definitely feasible that they will not come from magnetometers -
a differential bearing is common on GPS units.

>
>   /* relies on pairs of these shared then separate */
> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
> index 084d882..f1e8be6 100644
> --- a/include/linux/iio/types.h
> +++ b/include/linux/iio/types.h
> @@ -53,6 +53,10 @@ enum iio_modifier {
>   	IIO_MOD_LIGHT_RED,
>   	IIO_MOD_LIGHT_GREEN,
>   	IIO_MOD_LIGHT_BLUE,
> +	IIO_MOD_MAGN_NORTH,
> +	IIO_MOD_MAGN_NORTH_TRUE,
> +	IIO_MOD_MAGN_NORTH_TILT_COMP,
> +	IIO_MOD_MAGN_NORTH_TRUE_TILT_COMP
>   };
>
>   enum iio_event_type {
>

