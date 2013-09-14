Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab3INQvE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 12:51:04 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43198 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab3INQvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 12:51:02 -0400
Message-ID: <5234A20F.7040008@kernel.org>
Date: Sat, 14 Sep 2013 18:51:11 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 32/38] iio: accel-core: st: Move LSM303DLH into correct
 group
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org> <1378817379-8238-33-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1378817379-8238-33-git-send-email-lee.jones@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/13 13:49, Lee Jones wrote:
> The LSM303DLH's WAI (WhoAmI) is 0x33, meaning it should be enabled by
> Accel Sensor group one. For the device to probe without error, we'll
> need to ensure it's registered with the correct WAI.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
You clearly have a better datasheet than I have as for that part it doesn't even claim to
have the relevant register to read a who am I from.

Now that datasheet does list odr values as 50, 100, 400 1000 which would put it where it originally
was in these tables.

http://www.st.com/web/en/resource/technical/document/datasheet/CD00260288.pdf

I haven't checked other elements...

I'm confused but suspect we may need another type entry to deal with this one.

> ---
>  drivers/iio/accel/st_accel_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/accel/st_accel_core.c b/drivers/iio/accel/st_accel_core.c
> index ea62291..03a2b6b 100644
> --- a/drivers/iio/accel/st_accel_core.c
> +++ b/drivers/iio/accel/st_accel_core.c
> @@ -170,6 +170,7 @@ static const struct st_sensors st_accel_sensors[] = {
>  			[2] = LSM330D_ACCEL_DEV_NAME,
>  			[3] = LSM330DL_ACCEL_DEV_NAME,
>  			[4] = LSM330DLC_ACCEL_DEV_NAME,
> +			[5] = LSM303DLH_ACCEL_DEV_NAME,
>  		},
>  		.ch = (struct iio_chan_spec *)st_accel_12bit_channels,
>  		.odr = {
> @@ -238,8 +239,7 @@ static const struct st_sensors st_accel_sensors[] = {
>  		.sensors_supported = {
>  			[0] = LIS331DLH_ACCEL_DEV_NAME,
>  			[1] = LSM303DL_ACCEL_DEV_NAME,
> -			[2] = LSM303DLH_ACCEL_DEV_NAME,
> -			[3] = LSM303DLM_ACCEL_DEV_NAME,
> +			[2] = LSM303DLM_ACCEL_DEV_NAME,
>  		},
>  		.ch = (struct iio_chan_spec *)st_accel_12bit_channels,
>  		.odr = {
> 
