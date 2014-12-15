Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaLOHum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:50:42 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46818 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaLOHui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:50:38 -0500
MIME-Version: 1.0
In-Reply-To: <20141215072207.GA15062@ubuntu>
References: <20141215072207.GA15062@ubuntu>
Date: Mon, 15 Dec 2014 08:50:36 +0100
Message-ID: <CALnQHM0c_-NG9FPbsWun+yK6PVgYVQjRzE4jGEXEQ4E-yqsfpA@mail.gmail.com>
Subject: Re: [PATCH] usb: host: max3421-hcd: use time_after()
From: David Mosberger <davidm@egauge.net>
To: Asaf Vertz <asaf.vertz@tandemg.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: David Mosberger <davidm@egauge.net>

On Mon, Dec 15, 2014 at 8:22 AM, Asaf Vertz <asaf.vertz@tandemg.com> wrote:
> To be future-proof and for better readability the time comparisons are
> modified to use time_after() instead of plain, error-prone math.
>
> Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
> ---
>  drivers/usb/host/max3421-hcd.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
> index 6234c75..aaaff94 100644
> --- a/drivers/usb/host/max3421-hcd.c
> +++ b/drivers/usb/host/max3421-hcd.c
> @@ -55,6 +55,7 @@
>   * single thread (max3421_spi_thread).
>   */
>
> +#include <linux/jiffies.h>
>  #include <linux/module.h>
>  #include <linux/spi/spi.h>
>  #include <linux/usb.h>
> @@ -1291,7 +1292,7 @@ max3421_handle_irqs(struct usb_hcd *hcd)
>                 char sbuf[16 * 16], *dp, *end;
>                 int i;
>
> -               if (jiffies - last_time > 5*HZ) {
> +               if (time_after(jiffies, last_time + 5*HZ)) {
>                         dp = sbuf;
>                         end = sbuf + sizeof(sbuf);
>                         *dp = '\0';
> --
> 1.7.0.4
>



-- 
eGauge Systems LLC, http://egauge.net/, 1.877-EGAUGE1, fax 720.545.9768
