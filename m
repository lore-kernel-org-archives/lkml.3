Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaG0NPg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 09:15:36 -0400
Received: from mail.kernel.org ([198.145.19.201]:52789 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbaG0NPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 09:15:35 -0400
Message-ID: <53D4FC07.1050007@kernel.org>
Date: Sun, 27 Jul 2014 14:17:59 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Reyad Attiyat <reyad.attiyat@gmail.com>,
        srinivas.pandruvada@linux.intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iio: hid-sensor-magn-3d: Fix build warning
References: <1406322857-12391-1-git-send-email-reyad.attiyat@gmail.com>
In-Reply-To: <1406322857-12391-1-git-send-email-reyad.attiyat@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/07/14 22:14, Reyad Attiyat wrote:
> Fix build warning, sizeof() called on dynamically
> sized pointer, by removing the call and the dependent
> function parameter. It is not needed or used in this
> driver, when pushing values to an iio buffer.
>
> Changes from v1
> - Fix mistake in varible name
>
> Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
Applied to the togreg branch of iio.git

Thanks for fixing up my mistake!

Jonathan
> ---
>   drivers/iio/magnetometer/hid-sensor-magn-3d.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
> index 3ec777a..1e717c7 100644
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
> +		hid_sensor_push_data(indio_dev, magn_state->iio_vals);
>
>   	return 0;
>   }
>

