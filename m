Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbaDXQgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:36:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57513 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbaDXQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:36:34 -0400
MIME-Version: 1.0
In-Reply-To: <1398354436-25467-1-git-send-email-standby24x7@gmail.com>
References: <1398354436-25467-1-git-send-email-standby24x7@gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 24 Apr 2014 09:36:12 -0700
Message-ID: <CAK5ve-KyoLaJxZWDokKTyKvvXK0w6vVWFS7AWM6G-dzDkbKpDA@mail.gmail.com>
Subject: Re: [PATCH] video/backlight: Fix string type mismatch in s6e63m0.c
To: Masanari Iida <standby24x7@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        FBDEV list <linux-fbdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 8:47 AM, Masanari Iida <standby24x7@gmail.com> wrote:
> Fix string type mismatch in s6e63m0_sysfs_show_gamma_table().
> gamma_table_count is defined as unsigned int.
>

Looks good to me,
Acked-by: Bryan Wu <cooloney@gmail.com>

> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/video/backlight/s6e63m0.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
> index 510a1bc..2d6d481 100644
> --- a/drivers/video/backlight/s6e63m0.c
> +++ b/drivers/video/backlight/s6e63m0.c
> @@ -703,7 +703,7 @@ static ssize_t s6e63m0_sysfs_show_gamma_table(struct device *dev,
>         struct s6e63m0 *lcd = dev_get_drvdata(dev);
>         char temp[3];
>
> -       sprintf(temp, "%d\n", lcd->gamma_table_count);
> +       sprintf(temp, "%u\n", lcd->gamma_table_count);
>         strcpy(buf, temp);
>
>         return strlen(buf);
> --
> 2.0.0.rc0.26.g779792a
>
