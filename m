Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbbAANyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 08:54:32 -0500
Received: from mout.gmx.net ([212.227.15.19]:59289 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbbAANy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 08:54:29 -0500
Message-ID: <54A5518C.6050107@gmx.de>
Date: Thu, 01 Jan 2015 14:54:20 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, jic23@kernel.org
CC: lars@metafoo.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH 10/10] iio: imu: kmx61: Use correct base when reading data
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com> <1419340953-23161-11-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1419340953-23161-11-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:WtV5t7tF6nEG1gp6yG4ODJIYthifi7DiwrTb/6FZ87RFipm+dYs
 VCK7CYzRIUQllZD8d6RApuusUe3DnODmCrKetXN3W+Fmb9VDMwEDkROwD5PM0K9GZYk/aZn
 4VDcSwTZkMLDi0vIp7U7vBWpuBxomUMw+ZofBP1BL425joXE5ikELEUEaR5enCcrnWDSlon
 oa/ggnCCcI2LeqWlwDVyQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Baluta schrieb am 23.12.2014 um 14:22:
> We have two IIO devices and we need to adjust the base
> when reading data.
> 
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Reviewed-by: Hartmut Knaack <knaack.h@gmx.de>
> ---
>  drivers/iio/imu/kmx61.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
> index 98369eb..6178cea 100644
> --- a/drivers/iio/imu/kmx61.c
> +++ b/drivers/iio/imu/kmx61.c
> @@ -1210,12 +1210,18 @@ static irqreturn_t kmx61_trigger_handler(int irq, void *p)
>  	struct iio_dev *indio_dev = pf->indio_dev;
>  	struct kmx61_data *data = kmx61_get_data(indio_dev);
>  	int bit, ret, i = 0;
> +	u8 base;
>  	s16 buffer[8];
>  
> +	if (indio_dev == data->acc_indio_dev)
> +		base = KMX61_ACC_XOUT_L;
> +	else
> +		base = KMX61_MAG_XOUT_L;
> +
>  	mutex_lock(&data->lock);
>  	for_each_set_bit(bit, indio_dev->buffer->scan_mask,
>  			 indio_dev->masklength) {
> -		ret = kmx61_read_measurement(data, KMX61_ACC_XOUT_L, bit);
> +		ret = kmx61_read_measurement(data, base, bit);
>  		if (ret < 0) {
>  			mutex_unlock(&data->lock);
>  			goto err;
> 

