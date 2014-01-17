Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaAQK0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 05:26:51 -0500
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2267 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaAQK0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 05:26:50 -0500
Message-ID: <52D90559.1020707@xs4all.nl>
Date: Fri, 17 Jan 2014 11:26:33 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH, RFC 06/30] [media] usbvision: remove bogus sleep_on_timeout
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <1388664474-1710039-7-git-send-email-arnd@arndb.de>
In-Reply-To: <1388664474-1710039-7-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 01:07 PM, Arnd Bergmann wrote:
> There is no reason to use sleep_on_timeout here, and we want to get
> rid of that interface. Use the simpler msleep_interruptible instead.

Since this define is unused anyway, lets just remove it completely.

I'll post a patch for this.

Regards,

	Hans

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/usb/usbvision/usbvision.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/usbvision/usbvision.h b/drivers/media/usb/usbvision/usbvision.h
> index 8a25876..eb6dc8a 100644
> --- a/drivers/media/usb/usbvision/usbvision.h
> +++ b/drivers/media/usb/usbvision/usbvision.h
> @@ -205,10 +205,8 @@ enum {
>  
>  /* Debugging aid */
>  #define USBVISION_SAY_AND_WAIT(what) { \
> -	wait_queue_head_t wq; \
> -	init_waitqueue_head(&wq); \
>  	printk(KERN_INFO "Say: %s\n", what); \
> -	interruptible_sleep_on_timeout(&wq, HZ * 3); \
> +	msleep_interruptible(3000); \
>  }
>  
>  /*
> 

