Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaLQWP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 17:15:57 -0500
Received: from mout.gmx.net ([212.227.17.22]:54555 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbaLQWP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 17:15:56 -0500
Message-ID: <54920096.5000409@gmx.de>
Date: Wed, 17 Dec 2014 23:15:50 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, Jonathan Cameron <jic23@kernel.org>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [PATCH v3 3/5] iio: common: ssp_sensors: Add sensorhub iio commons
References: <1417809290-9662-1-git-send-email-k.wrona@samsung.com> <1417809290-9662-4-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1417809290-9662-4-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:XV3nifd98XQGasYcCLZblZHnc0IL2U2MC6d2BJROdSfJgvcI7Fv
 wvOvGvffzjzXfzpx0S3J6eDc6uDgFMxQruvubKk8VCuPeJunX9EGU/XNttybYJzSdYGM5XN
 Y0V8RjAFmpegB28WQ2R4ytGWBhMmHQ778hxif1Sx6BkweCPhVkhG4Q3svmkFl5Vkyux+7tX
 qaTi39Hu1jHrk/FURHUpA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karol Wrona schrieb am 05.12.2014 um 20:54:
> This patch adds common library for sensorhub iio drivers.
> 
Looks good to me, overall. Just one very small nitpick.
> Change-Id: I1038cb31c051f7e8ffde696a4121518daa5af081
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/iio/common/ssp_sensors/ssp_iio.c        |   82 +++++++++++++++++++++++
>  drivers/iio/common/ssp_sensors/ssp_iio_sensor.h |   56 ++++++++++++++++
>  2 files changed, 138 insertions(+)
>  create mode 100644 drivers/iio/common/ssp_sensors/ssp_iio.c
>  create mode 100644 drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
> 

> +/* Converts time in ms to frequency */
> +static inline void ssp_convert_to_freq(u32 time, int *integer_part,
> +				       int *fractional)
> +{
> +	if (time == 0) {
> +		*fractional = 0;
> +		*integer_part = 0;
> +		return;
> +	}
> +
> +	*integer_part = SSP_DIVIDEND / time;
> +	*fractional = do_div(*integer_part, SSP_DIVISOR);
> +}
> +
> +/* Converts frequency to time in ms*/
Missing whitespace at end of comment.
> +static inline int ssp_convert_to_time(int integer_part, int fractional)
> +{
> +	u64 value;
> +
> +	value = integer_part * SSP_DIVISOR + fractional;
> +	if (value == 0)
> +		return 0;
> +
> +	return div_u64(SSP_DIVIDEND, value);
> +}
> +#endif /* __SSP_IIO_SENSOR_H__ */
> 

