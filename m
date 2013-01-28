Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3A1JuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:50:19 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:42220 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3A1JuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:50:18 -0500
MIME-Version: 1.0
In-Reply-To: <1359153858-31992-11-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de> <1359153858-31992-11-git-send-email-arnd@arndb.de>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Mon, 28 Jan 2013 10:49:57 +0100
Message-ID: <CAHkwnC-pQo03VNdRJZXGrRZHPFdMOJhHH4y+JmGtTENs7h-+wg@mail.gmail.com>
Subject: Re: [PATCH 10/19] watchdog: at91sam9: at91_wdt_dt_ids cannot be __init
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, Jan 25, 2013 at 11:44 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The device IDs are referenced by the driver and potentially
> used beyond the init time, as kbuild correctly warns
> about. Remove the __initconst annotation.
>
> Without this patch, building at91_dt_defconfig results in:
>
> WARNING: drivers/watchdog/built-in.o(.data+0x28): Section mismatch in reference from the variable at91wdt_driver to the (unknown reference) .init.rodata:(unknown)
> The variable at91wdt_driver references
> the (unknown reference) __initconst (unknown)

Thanks for fixing my commit.

Best regards

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: linux-watchdog@vger.kernel.org
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Fabio Porcedda <fabio.porcedda@gmail.com>
> ---
>  drivers/watchdog/at91sam9_wdt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
> index dc42e44..6dad954 100644
> --- a/drivers/watchdog/at91sam9_wdt.c
> +++ b/drivers/watchdog/at91sam9_wdt.c
> @@ -304,7 +304,7 @@ static int __exit at91wdt_remove(struct platform_device *pdev)
>  }
>
>  #if defined(CONFIG_OF)
> -static const struct of_device_id at91_wdt_dt_ids[] __initconst = {
> +static const struct of_device_id at91_wdt_dt_ids[] = {
>         { .compatible = "atmel,at91sam9260-wdt" },
>         { /* sentinel */ }
>  };
> --
> 1.8.0
>

--
Fabio Porcedda
