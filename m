Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935039AbaGYTrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:47:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:54368 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934189AbaGYTrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:47:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,732,1400050800"; 
   d="scan'208";a="549137084"
Message-ID: <53D2B587.7080506@linux.intel.com>
Date: Fri, 25 Jul 2014 12:52:39 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Reyad Attiyat <reyad.attiyat@gmail.com>
CC: jic23@kernel.org, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: hid-sensor-magn-3d: Fix build warning
References: <1406316745-3351-1-git-send-email-reyad.attiyat@gmail.com>
In-Reply-To: <1406316745-3351-1-git-send-email-reyad.attiyat@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 12:32 PM, Reyad Attiyat wrote:
> Fix build warning, sizeof() called on dynamically
> sized pointer, by removing the call and the dependent
> function parameter. It is not needed or used in this
> driver, when pushing values to an iio buffer.
>
> Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
> ---
>   drivers/iio/magnetometer/hid-sensor-magn-3d.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
> index 3ec777a..915ffb9 100644
> --- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
> +++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
> @@ -246,8 +246,7 @@ static const struct iio_info magn_3d_info = {
>   };
>
>   /* Function to push data to buffer */
> -static void hid_sensor_push_data(struct iio_dev *indio_dev, const void *data,
> -	int len)
> +static void hid_sensor_push_data(struct iio_dev *indio_dev, const void *data)
>   {
>   	dev_dbg(&indio_dev->dev, "hid_sensor_push_data\n");
>   	iio_push_to_buffers(indio_dev, data);
> @@ -263,9 +262,7 @@ static int magn_3d_proc_event(struct hid_sensor_hub_device *hsdev,
>
>   	dev_dbg(&indio_dev->dev, "magn_3d_proc_event\n");
>   	if (atomic_read(&magn_state->common_attributes.data_ready))
> -		hid_sensor_push_data(indio_dev,
> -				magn_state->iio_vals,
> -				sizeof(magn_state->iio_vals));
> +		hid_sensor_push_data(indio_devm, magn_state->iio_vals);
Is it indio_devm,  not indio_dev?

Thanks,
Srinivas
>
>   	return 0;
>   }
>

