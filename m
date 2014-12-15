Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaLOOxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:53:37 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36493 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaLOOxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:53:31 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-cb-548ef5e97210
Content-transfer-encoding: 8BIT
Message-id: <1418655206.20866.6.camel@AMDC1943>
Subject: Re: [RFC PATCHv3 2/7] devfreq: event: Add the list of supported
 devfreq-event type
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, kgene.kim@samsung.com,
        rafael.j.wysocki@intel.com, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Date: Mon, 15 Dec 2014 15:53:26 +0100
In-reply-to: <1418372852-12454-3-git-send-email-cw00.choi@samsung.com>
References: <1418372852-12454-1-git-send-email-cw00.choi@samsung.com>
 <1418372852-12454-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t/xy7ovv/aFGKx9IWHxeM1iJouNM9az
	Wlz/8pzVYv6Rc6wWvQuuslmcbXrDbrHp8TVWi8u75rBZfO49wmgx4/w+JovbjSvYLB6veMtu
	sWrXH0YHXo+ds+6yeyze85LJY/OSeo++LasYPT5vkgtgjeKySUnNySxLLdK3S+DKmNOVVHDW
	rGLpjK8sDYx7dboYOTkkBEwkenbOY4KwxSQu3FvP1sXIxSEksJRRYv3OZewgCV4BQYkfk++x
	dDFycDALyEscuZQNEmYWUJeYNG8RM0T9Z0aJ96/vM0LU60tsbLzNAmILC8RKzGrZxQpiswkY
	S2xevoQNxBYR0JCY+fcKI0gzs8B1JomeiwfBrmARUJU42XMSrIhTwE3i/s2D7BAbGhklVh67
	CnaFhICyRGO/2wRGgVlI7puFcN8sJPctYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRES
	HV93MC49ZnWIUYCDUYmH90dib4gQa2JZcWXuIUYJDmYlEd5Z7/pChHhTEiurUovy44tKc1KL
	DzEycXBKNTCm/54fWPjhXN3CvK3qszTPisq/1fmavFDhpslXiyjWiYIleUtffJpYqCDV2J49
	N4tlZfVmyxV77jVpROubP9kj3eukPfHUQ02taYICdhzH/lv8drt/pjP5hdKMipkd//+HFce1
	hnipe5gd7t/63MOz3uTCp4+SqQ9muq10XzxdMmrXRL9CYXclluKMREMt5qLiRAD8c+GTbAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-12-12 at 17:27 +0900, Chanwoo Choi wrote:
> This patch adds the list of supported devfreq-event type as following.
> Each devfreq-event device driver would support the various devfreq-event type
> for devfreq governor at the same time.
> - DEVFREQ_EVENT_TYPE_RAW_DATA
> - DEVFREQ_EVENT_TYPE_UTILIZATION
> - DEVFREQ_EVENT_TYPE_BANDWIDTH
> - DEVFREQ_EVENT_TYPE_LATENCY
> 
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/devfreq/devfreq-event.c | 44 +++++++++++++++++++++++++++++++++++++----
>  include/linux/devfreq.h         | 29 ++++++++++++++++++++++-----
>  2 files changed, 64 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
> index eaf59c1..9444f93 100644
> --- a/drivers/devfreq/devfreq-event.c
> +++ b/drivers/devfreq/devfreq-event.c
> @@ -29,6 +29,9 @@
>  #include <linux/of.h>
>  #include "governor.h"
>  
> +#define EVENT_TYPE_RAW_DATA_MAX		U64_MAX
> +#define EVENT_TYPE_UTILIZATION_MAX	100
> +
>  static struct class *devfreq_event_class;
>  
>  /* The list of all devfreq event list */
> @@ -144,7 +147,8 @@ EXPORT_SYMBOL_GPL(devfreq_event_is_enabled);
>   * Note that this function set the event to the devfreq-event device to start
>   * for getting the event data which could be various event type.
>   */
> -int devfreq_event_set_event(struct devfreq_event_dev *edev)
> +int devfreq_event_set_event(struct devfreq_event_dev *edev,
> +				enum devfreq_event_type type)
>  {
>  	int ret;
>  
> @@ -158,7 +162,15 @@ int devfreq_event_set_event(struct devfreq_event_dev *edev)
>  		return -EPERM;
>  
>  	mutex_lock(&edev->lock);
> -	ret = edev->desc->ops->set_event(edev);
> +
> +	if ((edev->desc->type & type) == 0) {
> +		dev_err(&edev->dev, "unsupported of devfreq-event type\n");
> +		mutex_unlock(&edev->lock);
> +		return -EINVAL;
> +	}
> +
> +	ret = edev->desc->ops->set_event(edev, type);
> +
>  	mutex_unlock(&edev->lock);
>  
>  	return ret;
> @@ -174,7 +186,9 @@ EXPORT_SYMBOL_GPL(devfreq_event_set_event);
>   * current event data and total_event should be stored in second parameter
>   * (total_event).
>   */
> -u64 devfreq_event_get_event(struct devfreq_event_dev *edev, u64 *total_event)
> +u64 devfreq_event_get_event(struct devfreq_event_dev *edev,
> +				enum devfreq_event_type type,
> +				u64 *total_event)
>  {
>  	u64 event;
>  
> @@ -190,7 +204,27 @@ u64 devfreq_event_get_event(struct devfreq_event_dev *edev, u64 *total_event)
>  		return 0;
>  
>  	mutex_lock(&edev->lock);
> -	event = edev->desc->ops->get_event(edev, total_event);
> +
> +	if ((edev->desc->type & type) == 0) {
> +		dev_err(&edev->dev, "unsupported of devfreq-event type\n");
> +		return -EINVAL;
> +	}
> +
> +	event = edev->desc->ops->get_event(edev, type, total_event);
> +
> +	switch (type) {
> +	case DEVFREQ_EVENT_TYPE_RAW_DATA:
> +	case DEVFREQ_EVENT_TYPE_BANDWIDTH:
> +	case DEVFREQ_EVENT_TYPE_LATENCY:
> +		if ((event > *total_event)
> +			|| ((event > EVENT_TYPE_RAW_DATA_MAX) ||
> +				*total_event > EVENT_TYPE_RAW_DATA_MAX))
> +			event = 0;

missing break here.

Best regards,
Krzysztof

> +	case DEVFREQ_EVENT_TYPE_UTILIZATION:
> +		if (event > EVENT_TYPE_UTILIZATION_MAX)
> +			event = 0;
> +	}
> +
>  	mutex_unlock(&edev->lock);
>  
>  	return event;
> @@ -215,8 +249,10 @@ int devfreq_event_reset_event(struct devfreq_event_dev *edev)
>  		return -EPERM;
>  
>  	mutex_lock(&edev->lock);
> +
>  	if (edev->desc->ops && edev->desc->ops->reset)
>  		ret = edev->desc->ops->reset(edev);
> +
>  	mutex_unlock(&edev->lock);
>  
>  	if (ret < 0)
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index a8d2277..82da235 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -197,6 +197,14 @@ struct devfreq_event_dev {
>  	const struct devfreq_event_desc *desc;
>  };
>  
> +/* The supported type by devfreq-event device */
> +enum devfreq_event_type {
> +	DEVFREQ_EVENT_TYPE_RAW_DATA	= BIT(0),
> +	DEVFREQ_EVENT_TYPE_UTILIZATION	= BIT(1),
> +	DEVFREQ_EVENT_TYPE_BANDWIDTH	= BIT(2),
> +	DEVFREQ_EVENT_TYPE_LATENCY	= BIT(3),
> +};
> +
>  /**
>   * struct devfreq_event_ops - the operations of devfreq-event device
>   *
> @@ -219,8 +227,10 @@ struct devfreq_event_ops {
>  	int (*reset)(struct devfreq_event_dev *event_dev);
>  
>  	/* Mandatory functions */
> -	int (*set_event)(struct devfreq_event_dev *event_dev);
> -	u64 (*get_event)(struct devfreq_event_dev *event_dev, u64 *total_event);
> +	int (*set_event)(struct devfreq_event_dev *event_dev,
> +			enum devfreq_event_type type);
> +	u64 (*get_event)(struct devfreq_event_dev *event_dev,
> +			enum devfreq_event_type type, u64 *total_event);
>  };
>  
>  /**
> @@ -228,6 +238,10 @@ struct devfreq_event_ops {
>   *
>   * @name	: the name of devfreq-event device.
>   * @driver_data	: the private data for devfreq-event driver.
> + * @event_type	: the supported devfreq-event type among as following
> + *		  - DEVFREQ_EVENT_TYPE_UTILIZATION
> + *		  - DEVFREQ_EVENT_TYPE_BANDWIDTH
> + *		  - DEVFREQ_EVENT_TYPE_LATENCY
>   * @ops		: the operation to control devfreq-event device.
>   *
>   * Each devfreq-event device is described with a this structure.
> @@ -236,6 +250,7 @@ struct devfreq_event_ops {
>  struct devfreq_event_desc {
>  	const char *name;
>  	void *driver_data;
> +	enum devfreq_event_type type;
>  
>  	struct devfreq_event_ops *ops;
>  };
> @@ -273,8 +288,10 @@ extern void devm_devfreq_unregister_opp_notifier(struct device *dev,
>  extern int devfreq_event_enable_edev(struct devfreq_event_dev *edev);
>  extern int devfreq_event_disable_edev(struct devfreq_event_dev *edev);
>  extern bool devfreq_event_is_enabled(struct devfreq_event_dev *edev);
> -extern int devfreq_event_set_event(struct devfreq_event_dev *edev);
> +extern int devfreq_event_set_event(struct devfreq_event_dev *edev,
> +				enum devfreq_event_type type);
>  extern u64 devfreq_event_get_event(struct devfreq_event_dev *edev,
> +				enum devfreq_event_type type,
>  				u64 *total_event);
>  extern int devfreq_event_reset_event(struct devfreq_event_dev *edev);
>  extern void *devfreq_event_get_drvdata(struct devfreq_event_dev *edev);
> @@ -397,13 +414,15 @@ static inline bool devfreq_event_is_enabled(struct devfreq_event_dev *edev);
>  	return false;
>  }
>  
> -static inline int devfreq_event_set_event(struct devfreq_event_dev *edev);
> +static inline int devfreq_event_set_event(struct devfreq_event_dev *edev,
> +					enum devfreq_event_type type)
>  {
>  	return -EINVAL;
>  }
>  
>  static inline u64 devfreq_event_get_event(struct devfreq_event_dev *edev
> -					u64 *total_event);
> +					enum devfreq_event_type type,
> +					u64 *total_event)
>  {
>  	return 0;
>  }

