Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab3AWXqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 18:46:43 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:39674 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3AWXqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 18:46:36 -0500
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E1C4F7@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E1C4F7@DQHE02.ent.ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 23 Jan 2013 15:46:14 -0800
Message-ID: <CAK5ve-+mpOzoutWQz7VXeqV4fZaPudfPjb4_178HoW81Gt_VrQ@mail.gmail.com>
Subject: Re: [PATCH v2] leds-lp5521/3: use '%zu' for formatting 'size_t'
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Nathan Lynch <ntl@pobox.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 3:43 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
> The printk format of type 'size_t' is not '%d' but '%zu' or '%zx'.
> This patch fixes build warnings below.
>
>  drivers/leds/leds-lp5521.c: In function lp5521_firmware_loaded:
>  drivers/leds/leds-lp5521.c:257:4: warning: format %d expects argument of
>   type int, but argument 3 has type size_t [-Wformat]
>
>  drivers/leds/leds-lp5523.c: In function lp5523_firmware_loaded:
>  drivers/leds/leds-lp5523.c:283:4: warning: format %d expects argument of
>   type int, but argument 3 has type size_t [-Wformat]
>

OK, applied.
Thanks,
-Bryan

> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp5521.c |    2 +-
>  drivers/leds/leds-lp5523.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
> index 80adfb4..1001347 100644
> --- a/drivers/leds/leds-lp5521.c
> +++ b/drivers/leds/leds-lp5521.c
> @@ -253,7 +253,7 @@ static void lp5521_firmware_loaded(struct lp55xx_chip *chip)
>         const struct firmware *fw = chip->fw;
>
>         if (fw->size > LP5521_PROGRAM_LENGTH) {
> -               dev_err(&chip->cl->dev, "firmware data size overflow: %d\n",
> +               dev_err(&chip->cl->dev, "firmware data size overflow: %zu\n",
>                         fw->size);
>                 return;
>         }
> diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> index 4ac7061..229f734 100644
> --- a/drivers/leds/leds-lp5523.c
> +++ b/drivers/leds/leds-lp5523.c
> @@ -279,7 +279,7 @@ static void lp5523_firmware_loaded(struct lp55xx_chip *chip)
>         const struct firmware *fw = chip->fw;
>
>         if (fw->size > LP5523_PROGRAM_LENGTH) {
> -               dev_err(&chip->cl->dev, "firmware data size overflow: %d\n",
> +               dev_err(&chip->cl->dev, "firmware data size overflow: %zu\n",
>                         fw->size);
>                 return;
>         }
> --
> 1.7.9.5
>
>
> Best Regards,
> Milo
>
