Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab3EGX2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:28:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab3EGX2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:28:39 -0400
Date: Tue, 7 May 2013 16:28:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: a.zummo@towertech.it, yongjun_wei@trendmicro.com.cn,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: rtc-tile: add missing platform_device_unregister()
 when module exit
Message-Id: <20130507162838.81a78e16234ef86e0b332275@linux-foundation.org>
In-Reply-To: <CAPgLHd86cg11pHka0TRMFkEJV2ETLHwnr3oUo=FpBYnSLk=8sA@mail.gmail.com>
References: <CAPgLHd86cg11pHka0TRMFkEJV2ETLHwnr3oUo=FpBYnSLk=8sA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 May 2013 13:07:00 +0800 Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> We have registered platform device when module init, and
> need unregister it when module exit.
> 
> ...
>
> --- a/drivers/rtc/rtc-tile.c
> +++ b/drivers/rtc/rtc-tile.c
> @@ -146,6 +146,7 @@ exit_driver_unregister:
>   */
>  static void __exit tile_rtc_driver_exit(void)
>  {
> +	platform_device_unregister(tile_rtc_platform_device);
>  	platform_driver_unregister(&tile_rtc_platform_driver);
>  }

We don't need to do a platform_device_put(), as tile_rtc_driver_init()
does?

drivers/rtc/rtc-stmp3xxx.c appears to need the same fix.

  
