Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaEGVmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:42:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaEGVmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:42:49 -0400
Date: Wed, 7 May 2014 14:42:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Raghavendra Ganiga <ravi23ganiga@gmail.com>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] rtc: add support for maxim dallas rtc ds1343 and ds1344
Message-Id: <20140507144248.cf3d5e7411186e2cd616ded8@linux-foundation.org>
In-Reply-To: <1399403036-11377-1-git-send-email-ravi23ganiga@gmail.com>
References: <1399403036-11377-1-git-send-email-ravi23ganiga@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 May 2014 00:33:56 +0530 Raghavendra Ganiga <ravi23ganiga@gmail.com> wrote:

> This is a patch to add support for
> maxim dallas rtc ds1343 and ds1344
> 
> ...
>
> +static int ds1343_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
> +{
> +	switch (cmd) {
> +#ifdef RTC_SET_CHARGE
> +	case RTC_SET_CHARGE:
> +	{
> +		int val;
> +
> +		if (copy_from_user(&val, (int __user *)arg, sizeof(int)))
> +			return -EFAULT;
> +
> +		return regmap_write(priv->map, DS1343_TRICKLE_REG, val);
> +	}
> +	break;
> +#endif
> +	}

Why is RTC_SET_CHARGE defined only for m32r?  It seems pretty generic?

> +	return -ENOIOCTLCMD;
> +}

It's possible that this should be -ENOTTY.  I always forget the rule,
but Alan never forgets anything ;)

