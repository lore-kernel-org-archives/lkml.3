Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3FALtA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 07:49:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34318 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab3FALsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 07:48:54 -0400
Message-ID: <51A9DF7C.30303@ti.com>
Date: Sat, 1 Jun 2013 17:18:12 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] serial: omap: repair building without PM_SLEEP
References: <1844339.mxci2DdvBF@wuerfel>
In-Reply-To: <1844339.mxci2DdvBF@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,
On Saturday 01 June 2013 02:48 PM, Arnd Bergmann wrote:
> A recent bug fix in 3.10, ddd85e225c "serial: omap: prevent runtime PM for
> "no_console_suspend"", introduced a regression from an obvious typo:
>
> drivers/tty/serial/omap-serial.c:1677:14: error: 'serial_omap_complete'
> 	undeclared here (not in a function)
>
> This changes the incorrectly added macro to the one that we need instead.
>
> Signed-off-by: Arnd Bergmann<arnd@arndb.de>
> ---
> Please apply for 3.10-rc
>
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
> index 393a8eb..1aaeca8 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -1326,7 +1326,7 @@ static int serial_omap_resume(struct device *dev)
>   }
>   #else
>   #define serial_omap_prepare NULL
> -#define serial_omap_prepare NULL
> +#define serial_omap_complete NULL
>   #endif /* CONFIG_PM_SLEEP */
>
>   static void omap_serial_fill_features_erratas(struct uart_omap_port *up)
>
Yes, this bug was noticed last week and a patch for it has already been 
posted to the
serial mailing list[1].
[1]: http://www.spinics.net/lists/linux-serial/msg09741.html

