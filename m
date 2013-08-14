Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130Ab3HNUVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:21:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758388Ab3HNUVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:21:41 -0400
Date: Wed, 14 Aug 2013 13:21:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sangjung Woo <sangjung.woo@samsung.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org,
        Myugnjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] drivers/rtc/rtc-max77686.c: Fix wrong register
Message-Id: <20130814132139.82b8c40e460845535190e1d0@linux-foundation.org>
In-Reply-To: <1376443301-969-1-git-send-email-sangjung.woo@samsung.com>
References: <1376443301-969-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013 10:21:41 +0900 Sangjung Woo <sangjung.woo@samsung.com> wrote:

> Fix to read the wrong register when checking whether the RTC timer has
> reached or not.
> 
> ...
>
> --- a/drivers/rtc/rtc-max77686.c
> +++ b/drivers/rtc/rtc-max77686.c
> @@ -240,9 +240,9 @@ static int max77686_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
>  	}
>  
>  	alrm->pending = 0;
> -	ret = regmap_read(info->max77686->regmap, MAX77686_REG_STATUS1, &val);
> +	ret = regmap_read(info->max77686->regmap, MAX77686_REG_STATUS2, &val);
>  	if (ret < 0) {
> -		dev_err(info->dev, "%s:%d fail to read status1 reg(%d)\n",
> +		dev_err(info->dev, "%s:%d fail to read status2 reg(%d)\n",
>  				__func__, __LINE__, ret);
>  		goto out;
>  	}

The changelog didn't describe the end-user visible effects of the bug,
so I am unable to determine which kernel version(s) need patching. 
Please always include this information.

