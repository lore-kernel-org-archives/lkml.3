Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab3BOWrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:47:32 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:34476 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3BOWrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:47:31 -0500
MIME-Version: 1.0
In-Reply-To: <1360771110-9490-1-git-send-email-christian.gmeiner@gmail.com>
References: <1360771110-9490-1-git-send-email-christian.gmeiner@gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 15 Feb 2013 14:47:08 -0800
Message-ID: <CAK5ve-K43n=4n1GyRW+2PgMTe2bU6ROHAa-_dK_0LgzM7JCRcw@mail.gmail.com>
Subject: Re: [PATCH] leds-ot200: Fix misbehavior caused by wrong bit masks
To: Christian Gmeiner <christian.gmeiner@gmail.com>,
        akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 7:58 AM, Christian Gmeiner
<christian.gmeiner@gmail.com> wrote:
> During the development of this driver an in-house register
> documentation was used. The last weeks some integration tests
> were done and this problem was found. It turned out that
> the released register documentation is wrong.
>
> The fix is very simple: shift all masks by one.
>
> Our customers can control LEDs from userspace via Java,
> C++ or what every. They have running/working applications where
> they want to control led_3 but led_2 get's used.
> I got a bug report in our in-house bug tracker so it would be
> great to fix this upstream.
>
> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>

Thanks, Christian.

And Andrew, are you going to take care of this patch? Or I will merge this.

-Bryan

> ---
>  drivers/leds/leds-ot200.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/leds/leds-ot200.c b/drivers/leds/leds-ot200.c
> index ee14662..98cae52 100644
> --- a/drivers/leds/leds-ot200.c
> +++ b/drivers/leds/leds-ot200.c
> @@ -47,37 +47,37 @@ static struct ot200_led leds[] = {
>         {
>                 .name = "led_1",
>                 .port = 0x49,
> -               .mask = BIT(7),
> +               .mask = BIT(6),
>         },
>         {
>                 .name = "led_2",
>                 .port = 0x49,
> -               .mask = BIT(6),
> +               .mask = BIT(5),
>         },
>         {
>                 .name = "led_3",
>                 .port = 0x49,
> -               .mask = BIT(5),
> +               .mask = BIT(4),
>         },
>         {
>                 .name = "led_4",
>                 .port = 0x49,
> -               .mask = BIT(4),
> +               .mask = BIT(3),
>         },
>         {
>                 .name = "led_5",
>                 .port = 0x49,
> -               .mask = BIT(3),
> +               .mask = BIT(2),
>         },
>         {
>                 .name = "led_6",
>                 .port = 0x49,
> -               .mask = BIT(2),
> +               .mask = BIT(1),
>         },
>         {
>                 .name = "led_7",
>                 .port = 0x49,
> -               .mask = BIT(1),
> +               .mask = BIT(0),
>         }
>  };
>
> --
> 1.7.12.2.421.g261b511
>
