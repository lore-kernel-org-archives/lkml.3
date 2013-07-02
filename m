Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3GBXZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 19:25:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42478 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab3GBXZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 19:25:00 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Oskar Andero <oskar.andero@sonymobile.com>,
        Shingo Nakao <shingo.x.nakao@sonymobile.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        Radovan Lekanovic <Radovan.Lekanovic@sonymobile.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] backlight: lp855x: set zero brightness at FBBLANK
Thread-Topic: [PATCH] backlight: lp855x: set zero brightness at FBBLANK
Thread-Index: AQHOdx3rU8OKtaAMc0+51xVGHFhPc5lSB/xt
Date: Tue, 2 Jul 2013 23:24:42 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E7C42D@DQHE06.ent.ti.com>
References: <1372767354-16499-1-git-send-email-oskar.andero@sonymobile.com>
In-Reply-To: <1372767354-16499-1-git-send-email-oskar.andero@sonymobile.com>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.49]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Shingo Nakao <shingo.x.nakao@sonymobile.com>
> 
> When backlight turns on early from display, a white line can be
> seen on the screen. Therefore make sure backlight is off when we
> are under an fb blank event.
> 
> Signed-off-by: Shingo Nakao <shingo.x.nakao@sonymobile.com>
> Cc: Milo Kim <milo.kim@ti.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>

Acked-by: Milo Kim <milo.kim@ti.com>

> ---
>  drivers/video/backlight/lp855x_bl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
> index a0e1e02..c0b41f1 100644
> --- a/drivers/video/backlight/lp855x_bl.c
> +++ b/drivers/video/backlight/lp855x_bl.c
> @@ -246,7 +246,7 @@ static int lp855x_bl_update_status(struct backlight_device *bl)
>  {
>         struct lp855x *lp = bl_get_data(bl);
> 
> -       if (bl->props.state & BL_CORE_SUSPENDED)
> +       if (bl->props.state & (BL_CORE_SUSPENDED | BL_CORE_FBBLANK))
>                 bl->props.brightness = 0;
> 
>         if (lp->mode == PWM_BASED) {
> --
> 1.8.1.5

