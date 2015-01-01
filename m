Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbbAANt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 08:49:57 -0500
Received: from mout.gmx.net ([212.227.15.15]:51022 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbbAANty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 08:49:54 -0500
Message-ID: <54A55076.8070102@gmx.de>
Date: Thu, 01 Jan 2015 14:49:42 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, jic23@kernel.org
CC: lars@metafoo.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH 05/10] iio: imu: kmx61: Drop unused device parameter
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com> <1419340953-23161-6-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1419340953-23161-6-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:BHSP028lnU0Oz4y7/OJOpa5HhO5vUwhVCLKU4C70p5FZPhoKtuF
 XBeMW1ljTdVCLwweBPBte44KYVVavZkjRCuJ9G6Tgwgqlj2WYz8N/kmy8xNq2MI+a2nT11P
 WUwO6Ft2mGDojGir2seF5Ufx1UhfOBtzAulq1YYFb3JJ8Ws4NYA9iXENuGDHjGz1iTupBIl
 skR6UvoEFab1U4Glrg89g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Baluta schrieb am 23.12.2014 um 14:22:
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Reviewed-by: Hartmut Knaack <knaack.h@gmx.de>
> ---
>  drivers/iio/imu/kmx61.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
> index 2652179..332ee67 100644
> --- a/drivers/iio/imu/kmx61.c
> +++ b/drivers/iio/imu/kmx61.c
> @@ -681,7 +681,7 @@ static int kmx61_chip_update_thresholds(struct kmx61_data *data)
>  }
>  
>  static int kmx61_setup_any_motion_interrupt(struct kmx61_data *data,
> -					    bool status, u8 device)
> +					    bool status)
>  {
>  	u8 mode;
>  	int ret;
> @@ -984,7 +984,7 @@ static int kmx61_write_event_config(struct iio_dev *indio_dev,
>  	if (ret < 0)
>  		goto err_unlock;
>  
> -	ret = kmx61_setup_any_motion_interrupt(data, state, KMX61_ACC);
> +	ret = kmx61_setup_any_motion_interrupt(data, state);
>  	if (ret < 0) {
>  		kmx61_set_power_state(data, false, KMX61_ACC);
>  		goto err_unlock;
> @@ -1070,7 +1070,7 @@ static int kmx61_data_rdy_trigger_set_state(struct iio_trigger *trig,
>  	if (data->acc_dready_trig == trig || data->mag_dready_trig == trig)
>  		ret = kmx61_setup_new_data_interrupt(data, state, device);
>  	else
> -		ret = kmx61_setup_any_motion_interrupt(data, state, KMX61_ACC);
> +		ret = kmx61_setup_any_motion_interrupt(data, state);
>  	if (ret < 0) {
>  		kmx61_set_power_state(data, false, device);
>  		goto err_unlock;
> 

