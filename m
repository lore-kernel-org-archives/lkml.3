Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbaBFTgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 14:36:47 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:34986 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbaBFTgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 14:36:45 -0500
MIME-Version: 1.0
In-Reply-To: <20140109231339.GA20157@amd.pavel.ucw.cz>
References: <20140107204233.GA22413@amd.pavel.ucw.cz> <20140109231339.GA20157@amd.pavel.ucw.cz>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 6 Feb 2014 11:36:23 -0800
Message-ID: <CAK5ve-KhdWP0f9OwSt+5wAXmRVtHAQnxP4J+Wh1QdedPwVmxoQ@mail.gmail.com>
Subject: Re: [trivial] Comment improvements for lp5523 and friend
To: Pavel Machek <pavel@ucw.cz>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, milo kim <milo.kim@ti.com>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 3:13 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Add some comments that are not obvious from first look at the driver
> to lp5523, fix typo in lp8501.
>

Milo, can you take a look at this. If it's OK, I will take it.

-Bryan

> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>
> diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> index c00f55e4..ac64ebc 100644
> --- a/drivers/leds/leds-lp5523.c
> +++ b/drivers/leds/leds-lp5523.c
> @@ -34,7 +34,15 @@
>
>  #include "leds-lp55xx-common.h"
>
> -#define LP5523_PROGRAM_LENGTH          32
> +#define LP5523_PROGRAM_LENGTH          32      /* bytes */
> +/* Memory is used like this:
> +   0x00 engine 1 program
> +   0x10 engine 2 program
> +   0x20 engine 3 program
> +   0x30 engine 1 muxing info
> +   0x40 engine 2 muxing info
> +   0x50 engine 3 muxing info
> +*/
>  #define LP5523_MAX_LEDS                        9
>
>  /* Registers */
> index 8d55a780..ae5c6fe 100644
> --- a/drivers/leds/leds-lp8501.c
> +++ b/drivers/leds/leds-lp8501.c
> @@ -262,7 +262,7 @@ static void lp8501_firmware_loaded(struct lp55xx_chip *chip)
>         }
>
>         /*
> -        * Program momery sequence
> +        * Program memory sequence
>          *  1) set engine mode to "LOAD"
>          *  2) write firmware data into program memory
>          */
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
