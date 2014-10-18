Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbaJRL5e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 07:57:34 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:51159 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaJRL5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 07:57:21 -0400
Message-ID: <5442559C.9080800@kernel.org>
Date: Sat, 18 Oct 2014 12:57:16 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH] io: accel: kxcjk-1013: Fix iio_event_spec direction
References: <1412952812-974-1-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1412952812-974-1-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/14 15:53, Daniel Baluta wrote:
> Because IIO_EV_DIR_* are not bitmasks but enums,
> IIO_EV_DIR_RISING | IIO_EV_DIR_FALLING is not equal
> with IIO_EV_DIR_EITHER.
> 
> This could lead to potential misformatted sysfs attributes
> like:
> 	* in_accel_x_thresh_(null)_en
> 	* in_accel_x_thresh_(null)_period
> 	* in_accel_x_thresh_(null)_value
> 
> or even memory corruption.
> 
> Fixes: b4b491c083 (iio: accel: kxcjk-1013: Support threshold)
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>

Good catch.  I'll have to hold this for a little until Greg takes
my last pull request and I can bring the fixes branch up past the
merge window.


> ---
>  drivers/iio/accel/kxcjk-1013.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
> index 98909a9..a23e58c 100644
> --- a/drivers/iio/accel/kxcjk-1013.c
> +++ b/drivers/iio/accel/kxcjk-1013.c
> @@ -894,7 +894,7 @@ static const struct attribute_group kxcjk1013_attrs_group = {
>  
>  static const struct iio_event_spec kxcjk1013_event = {
>  		.type = IIO_EV_TYPE_THRESH,
> -		.dir = IIO_EV_DIR_RISING | IIO_EV_DIR_FALLING,
> +		.dir = IIO_EV_DIR_EITHER,
>  		.mask_separate = BIT(IIO_EV_INFO_VALUE) |
>  				 BIT(IIO_EV_INFO_ENABLE) |
>  				 BIT(IIO_EV_INFO_PERIOD)
> 
