Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab3BVV0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 16:26:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab3BVV0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 16:26:06 -0500
Date: Fri, 22 Feb 2013 13:26:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [PATCH] backlight: ams369fg06: convert ams369fg06 to dev_pm_ops
Message-Id: <20130222132603.9993aa86.akpm@linux-foundation.org>
In-Reply-To: <003201ce10e9$61e11b50$25a351f0$%han@samsung.com>
References: <003201ce10e9$61e11b50$25a351f0$%han@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013 19:42:59 +0900
Jingoo Han <jg1.han@samsung.com> wrote:

> Instead of using legacy suspend/resume methods, using newer dev_pm_ops
> structure allows better control over power management.
> 
> ...
>
> @@ -571,12 +571,13 @@ static struct spi_driver ams369fg06_driver = {
>  	.driver = {
>  		.name	= "ams369fg06",
>  		.owner	= THIS_MODULE,
> +#ifdef CONFIG_PM
> +		.pm	= &ams369fg06_pm_ops,
> +#endif
>  	},
>  	.probe		= ams369fg06_probe,
>  	.remove		= ams369fg06_remove,
>  	.shutdown	= ams369fg06_shutdown,

Are the ifdefs needed?  There's various macro trickery in pm.h to clean
this up - the rtc drivers use it.

