Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3CUT5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:57:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:52877 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3CUT5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:57:12 -0400
Message-ID: <514B5814.4020309@infradead.org>
Date: Thu, 21 Mar 2013 11:57:24 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Janne Grunau <j@jannau.net>, linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] media: fix hdpvr build warning
References: <alpine.DEB.2.00.1303112254140.16847@ayla.of.borg> <513F769D.6040306@infradead.org> <20130321154509.46ad14e3@redhat.com>
In-Reply-To: <20130321154509.46ad14e3@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/13 11:45, Mauro Carvalho Chehab wrote:
> Em Tue, 12 Mar 2013 11:40:29 -0700
> Randy Dunlap <rdunlap@infradead.org> escreveu:
> 
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Fix build warning in hdpvr:
>>
>> drivers/media/usb/hdpvr/hdpvr-video.c: warning: "CONFIG_I2C_MODULE" is not defined [-Wundef]
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Cc: Janne Grunau <j@jannau.net>
> 
> From time to time, people used to write those checks wrong. So,
> we're now using a macro to avoid those problems (IS_ENABLED). The better
> is to also use it here.
> 

>From time to time, people omit including header files that should be
included.  Please add

#include <linux/kconfig.h>

to this patch.

Thank you.


> -
> 
> [PATCH] Use the proper check for I2C support
> 
> As reported by Geert Uytterhoeven <geert@linux-m68k.org>:
> 
> 	drivers/media/usb/hdpvr/hdpvr-video.c: warning: "CONFIG_I2C_MODULE" is not defined [-Wundef]
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
> index da6b779..554d2eb 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-video.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-video.c
> @@ -1238,7 +1238,7 @@ static void hdpvr_device_release(struct video_device *vdev)
>  	v4l2_device_unregister(&dev->v4l2_dev);
>  
>  	/* deregister I2C adapter */
> -#if defined(CONFIG_I2C) || (CONFIG_I2C_MODULE)
> +#if IS_ENABLED(CONFIG_I2C)
>  	mutex_lock(&dev->i2c_mutex);
>  	i2c_del_adapter(&dev->i2c_adapter);
>  	mutex_unlock(&dev->i2c_mutex);
> 
> Cheers,
> Mauro
> 


-- 
~Randy
