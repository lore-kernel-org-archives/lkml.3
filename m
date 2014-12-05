Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaLETuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:50:25 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:65324 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaLETuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:50:22 -0500
MIME-Version: 1.0
In-Reply-To: <1417166286-27685-4-git-send-email-j.anaszewski@samsung.com>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com> <1417166286-27685-4-git-send-email-j.anaszewski@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 5 Dec 2014 11:50:01 -0800
Message-ID: <CAK5ve-J5QOJvdRs20CaDUT_-gj35QJMPR2fdzb+0=jQV-fKBxQ@mail.gmail.com>
Subject: Re: [PATCH/RFC v8 03/14] Documentation: leds: Add description of
 v4l2-flash sub-device
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com,
        Pavel Machek <pavel@ucw.cz>, "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 1:17 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> This patch extends LED Flash class documention by
> the description of interactions with v4l2-flash sub-device.
>
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---

This patch looks good to me. I will take it with other patches!

Thanks,
-Bryan

>  Documentation/leds/leds-class-flash.txt |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
> index d68565c..1a611ec 100644
> --- a/Documentation/leds/leds-class-flash.txt
> +++ b/Documentation/leds/leds-class-flash.txt
> @@ -46,3 +46,16 @@ Following sysfs attributes are exposed for controlling flash led devices:
>                          until this flag is no longer set
>                 * 0x100 - the temperature of the LED has exceeded its allowed
>                           upper limit
> +
> +A LED subsystem driver can be controlled also from the level of VideoForLinux2
> +subsystem. In order to enable this CONFIG_V4L2_FLASH_LED_CLASS symbol has to
> +be defined in the kernel config. The driver must call the v4l2_flash_init
> +function to get registered in the V4L2 subsystem. On remove the
> +v4l2_flash_release function has to be called (see <media/v4l2-flash.h>).
> +
> +After proper initialization a V4L2 Flash sub-device is created. The sub-device
> +exposes a number of V4L2 controls, which allow for controlling a LED Flash class
> +device with use of its internal kernel API.
> +Opening the V4L2 Flash sub-device makes the LED subsystem sysfs interface
> +unavailable. The interface is re-enabled after the V4L2 Flash sub-device
> +is closed.
> --
> 1.7.9.5
>
