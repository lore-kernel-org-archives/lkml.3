Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaFWGMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 02:12:20 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:47874 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaFWGMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 02:12:18 -0400
MIME-Version: 1.0
In-Reply-To: <1403503334-4816-1-git-send-email-tushar.b@samsung.com>
References: <1403503334-4816-1-git-send-email-tushar.b@samsung.com>
Date: Mon, 23 Jun 2014 11:42:16 +0530
X-Google-Sender-Auth: LvTwMcQuuqpMekbJF8hrqwFYhNc
Message-ID: <CAK5sBcFn6vJQNDnQ-Pta0b09icFt9Qdx24iUQLcBe0vCkL1oig@mail.gmail.com>
Subject: Re: [PATCH] serial: samsung: Remove redundant label
From: Sachin Kamat <sachin.kamat@samsung.com>
To: Tushar Behera <tushar.b@samsung.com>
Cc: open list <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 11:32 AM, Tushar Behera <tushar.b@samsung.com> wrote:
> probe_err label only returns the error code. This label can be removed
> and the error code can be returned directly.
>
> Signed-off-by: Tushar Behera <tushar.b@samsung.com>
> ---
>  drivers/tty/serial/samsung.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
> index c1d3ebd..bf93010 100644
> --- a/drivers/tty/serial/samsung.c
> +++ b/drivers/tty/serial/samsung.c
> @@ -1303,7 +1303,7 @@ static int s3c24xx_serial_probe(struct platform_device *pdev)
>
>         ret = s3c24xx_serial_init_port(ourport, pdev);
>         if (ret < 0)
> -               goto probe_err;
> +               return ret;
>
>         if (!s3c24xx_uart_drv.state) {
>                 ret = uart_register_driver(&s3c24xx_uart_drv);
> @@ -1335,9 +1335,6 @@ static int s3c24xx_serial_probe(struct platform_device *pdev)
>                 dev_err(&pdev->dev, "failed to add cpufreq notifier\n");
>
>         return 0;
> -
> - probe_err:
> -       return ret;
>  }
>
>  static int s3c24xx_serial_remove(struct platform_device *dev)
> --

Looks good.
Reviewed-by: Sachin Kamat <sachin.kamat@samsung.com>
