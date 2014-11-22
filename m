Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaKVLOB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 06:14:01 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:40064 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaKVLOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 06:14:00 -0500
Message-ID: <54706FF6.5070703@kernel.org>
Date: Sat, 22 Nov 2014 11:13:58 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, knaack.h@gmx.de
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        irina.tirdea@intel.com, daniel.baluta@inte.com
Subject: Re: [PATCH v4 3/7] iio: core: Introduce IIO_EV_DIR_NONE
References: <1415623535-24337-1-git-send-email-daniel.baluta@intel.com> <1415623535-24337-4-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1415623535-24337-4-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/14 12:45, Daniel Baluta wrote:
> From: Irina Tirdea <irina.tirdea@intel.com>
> 
> For some events (e.g.: step detector) a direction does not make sense.
> 
> Add IIO_EV_DIR_NONE to be used with such events and generate sysfs event
> attributes that do not contain direction.
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Applied -> iio.git:togreg, pushed->iio.git:testing.

> ---
>  drivers/iio/industrialio-event.c | 12 +++++++++---
>  include/linux/iio/types.h        |  1 +
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
> index 0c1e37e..1290290 100644
> --- a/drivers/iio/industrialio-event.c
> +++ b/drivers/iio/industrialio-event.c
> @@ -327,9 +327,15 @@ static int iio_device_add_event(struct iio_dev *indio_dev,
>  	for_each_set_bit(i, mask, sizeof(*mask)*8) {
>  		if (i >= ARRAY_SIZE(iio_ev_info_text))
>  			return -EINVAL;
> -		postfix = kasprintf(GFP_KERNEL, "%s_%s_%s",
> -				iio_ev_type_text[type], iio_ev_dir_text[dir],
> -				iio_ev_info_text[i]);
> +		if (dir != IIO_EV_DIR_NONE)
> +			postfix = kasprintf(GFP_KERNEL, "%s_%s_%s",
> +					iio_ev_type_text[type],
> +					iio_ev_dir_text[dir],
> +					iio_ev_info_text[i]);
> +		else
> +			postfix = kasprintf(GFP_KERNEL, "%s_%s",
> +					iio_ev_type_text[type],
> +					iio_ev_info_text[i]);
>  		if (postfix == NULL)
>  			return -ENOMEM;
>  
> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
> index b3a241d..52cb532 100644
> --- a/include/linux/iio/types.h
> +++ b/include/linux/iio/types.h
> @@ -86,6 +86,7 @@ enum iio_event_direction {
>  	IIO_EV_DIR_EITHER,
>  	IIO_EV_DIR_RISING,
>  	IIO_EV_DIR_FALLING,
> +	IIO_EV_DIR_NONE,
>  };
>  
>  #define IIO_VAL_INT 1
> 

