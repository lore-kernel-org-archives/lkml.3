Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbbAZTEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:04:43 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:57377 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbbAZTEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:04:41 -0500
Message-ID: <54C68FC7.5090403@kernel.org>
Date: Mon, 26 Jan 2015 19:04:39 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@intel.com>, linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Vlad Dogaru <vlad.dogaru@intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [PATCH v2 06/10] iio: core: Remove IIO_EV_TYPE_INSTANCE
References: <1421003416-27557-1-git-send-email-irina.tirdea@intel.com> <1421003416-27557-7-git-send-email-irina.tirdea@intel.com>
In-Reply-To: <1421003416-27557-7-git-send-email-irina.tirdea@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/15 19:10, Irina Tirdea wrote:
> By introducing IIO_EV_TYPE_CHANGE, IIO_EV_TYPE_INSTANCE becomes redundant.
> The effect of IIO_EV_TYPE_INSTANCE can be obtained by using IIO_EV_TYPE_CHANGE
> with IIO_EV_INFO_VALUE set to 1.
> 
> Remove all instances of IIO_EV_TYPE_INSTANCE and replace them with
> IIO_EV_TYPE_CHANGE where needed.
> 
Definitely a more general interfaces so good.

Applied to the togreg branch of iio.git

Thanks,

Jonathan
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> ---
>  drivers/iio/industrialio-event.c                      | 1 -
>  drivers/staging/iio/Documentation/iio_event_monitor.c | 2 --
>  drivers/staging/iio/iio_simple_dummy.c                | 2 +-
>  drivers/staging/iio/iio_simple_dummy_events.c         | 4 ++--
>  include/linux/iio/types.h                             | 1 -
>  5 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
> index 08c4a4c..b5663f6 100644
> --- a/drivers/iio/industrialio-event.c
> +++ b/drivers/iio/industrialio-event.c
> @@ -197,7 +197,6 @@ static const char * const iio_ev_type_text[] = {
>  	[IIO_EV_TYPE_ROC] = "roc",
>  	[IIO_EV_TYPE_THRESH_ADAPTIVE] = "thresh_adaptive",
>  	[IIO_EV_TYPE_MAG_ADAPTIVE] = "mag_adaptive",
> -	[IIO_EV_TYPE_INSTANCE] = "instance",
>  	[IIO_EV_TYPE_CHANGE] = "change",
>  };
>  
> diff --git a/drivers/staging/iio/Documentation/iio_event_monitor.c b/drivers/staging/iio/Documentation/iio_event_monitor.c
> index 2e78d58..72c96aa 100644
> --- a/drivers/staging/iio/Documentation/iio_event_monitor.c
> +++ b/drivers/staging/iio/Documentation/iio_event_monitor.c
> @@ -59,7 +59,6 @@ static const char * const iio_ev_type_text[] = {
>  	[IIO_EV_TYPE_ROC] = "roc",
>  	[IIO_EV_TYPE_THRESH_ADAPTIVE] = "thresh_adaptive",
>  	[IIO_EV_TYPE_MAG_ADAPTIVE] = "mag_adaptive",
> -	[IIO_EV_TYPE_INSTANCE] = "instance",
>  	[IIO_EV_TYPE_CHANGE] = "change",
>  };
>  
> @@ -179,7 +178,6 @@ static bool event_is_known(struct iio_event_data *event)
>  	case IIO_EV_TYPE_ROC:
>  	case IIO_EV_TYPE_THRESH_ADAPTIVE:
>  	case IIO_EV_TYPE_MAG_ADAPTIVE:
> -	case IIO_EV_TYPE_INSTANCE:
>  	case IIO_EV_TYPE_CHANGE:
>  		break;
>  	default:
> diff --git a/drivers/staging/iio/iio_simple_dummy.c b/drivers/staging/iio/iio_simple_dummy.c
> index 0b8611a..e452021 100644
> --- a/drivers/staging/iio/iio_simple_dummy.c
> +++ b/drivers/staging/iio/iio_simple_dummy.c
> @@ -73,7 +73,7 @@ static const struct iio_event_spec iio_dummy_event = {
>   * simple step detect event - triggered when a step is detected
>   */
>  static const struct iio_event_spec step_detect_event = {
> -	.type = IIO_EV_TYPE_INSTANCE,
> +	.type = IIO_EV_TYPE_CHANGE,
>  	.dir = IIO_EV_DIR_NONE,
>  	.mask_separate = BIT(IIO_EV_INFO_ENABLE),
>  };
> diff --git a/drivers/staging/iio/iio_simple_dummy_events.c b/drivers/staging/iio/iio_simple_dummy_events.c
> index ac15a44..a5cd3bb 100644
> --- a/drivers/staging/iio/iio_simple_dummy_events.c
> +++ b/drivers/staging/iio/iio_simple_dummy_events.c
> @@ -86,7 +86,7 @@ int iio_simple_dummy_write_event_config(struct iio_dev *indio_dev,
>  		}
>  	case IIO_STEPS:
>  		switch (type) {
> -		case IIO_EV_TYPE_INSTANCE:
> +		case IIO_EV_TYPE_CHANGE:
>  			st->event_en = state;
>  			break;
>  		default:
> @@ -201,7 +201,7 @@ static irqreturn_t iio_simple_dummy_event_handler(int irq, void *private)
>  		iio_push_event(indio_dev,
>  			       IIO_EVENT_CODE(IIO_STEPS, 0, IIO_NO_MOD,
>  					      IIO_EV_DIR_NONE,
> -					      IIO_EV_TYPE_INSTANCE, 0, 0, 0),
> +					      IIO_EV_TYPE_CHANGE, 0, 0, 0),
>  			       iio_get_time_ns());
>  		break;
>  	default:
> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
> index 3ba3d66..580ed5b 100644
> --- a/include/linux/iio/types.h
> +++ b/include/linux/iio/types.h
> @@ -78,7 +78,6 @@ enum iio_event_type {
>  	IIO_EV_TYPE_ROC,
>  	IIO_EV_TYPE_THRESH_ADAPTIVE,
>  	IIO_EV_TYPE_MAG_ADAPTIVE,
> -	IIO_EV_TYPE_INSTANCE,
>  	IIO_EV_TYPE_CHANGE,
>  };
>  
> 

