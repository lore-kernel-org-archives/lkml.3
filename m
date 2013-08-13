Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab3HMUnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:43:03 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37338 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759208Ab3HMUnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:43:00 -0400
MIME-Version: 1.0
In-Reply-To: <1375948794-6286-5-git-send-email-milo.kim@ti.com>
References: <1375948794-6286-1-git-send-email-milo.kim@ti.com> <1375948794-6286-5-git-send-email-milo.kim@ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 13 Aug 2013 13:42:39 -0700
Message-ID: <CAK5ve-Lr6-P2nyGtGoxQZewS-m9ySQMfaE=tng0p6hJKnj+9mA@mail.gmail.com>
Subject: Re: [PATCH 04/10] leds: lp5521: remove unnecessary writing commands
To: Milo Kim <woogyom.kim@gmail.com>
Cc: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Milo Kim <milo.kim@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 12:59 AM, Milo Kim <woogyom.kim@gmail.com> wrote:
> This patch reduces the number of programming commands.
>
> (Count of sending commands)
> Old code: 32 + program size (32 counts for clearing program memory)
> New code: 32
>
> Pattern buffer is initialized to 0 in this function.
> Just update new program data and remaining buffers are filled with 0.
> So it's needless to clear whole area.
>

Good, I will merge this.
-Bryan

> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp5521.c |   14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
> index c00f922..0518835 100644
> --- a/drivers/leds/leds-lp5521.c
> +++ b/drivers/leds/leds-lp5521.c
> @@ -220,17 +220,11 @@ static int lp5521_update_program_memory(struct lp55xx_chip *chip,
>         };
>         unsigned cmd;
>         char c[3];
> -       int program_size;
>         int nrchars;
> -       int offset = 0;
>         int ret;
> -       int i;
> -
> -       /* clear program memory before updating */
> -       for (i = 0; i < LP5521_PROGRAM_LENGTH; i++)
> -               lp55xx_write(chip, addr[idx] + i, 0);
> +       int offset = 0;
> +       int i = 0;
>
> -       i = 0;
>         while ((offset < size - 1) && (i < LP5521_PROGRAM_LENGTH)) {
>                 /* separate sscanfs because length is working only for %s */
>                 ret = sscanf(data + offset, "%2s%n ", c, &nrchars);
> @@ -250,11 +244,9 @@ static int lp5521_update_program_memory(struct lp55xx_chip *chip,
>         if (i % 2)
>                 goto err;
>
> -       program_size = i;
> -
>         mutex_lock(&chip->lock);
>
> -       for (i = 0; i < program_size; i++) {
> +       for (i = 0; i < LP5521_PROGRAM_LENGTH; i++) {
>                 ret = lp55xx_write(chip, addr[idx] + i, pattern[i]);
>                 if (ret) {
>                         mutex_unlock(&chip->lock);
> --
> 1.7.9.5
>
