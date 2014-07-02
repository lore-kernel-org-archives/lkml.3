Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbaGBRR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:17:26 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:40660 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbaGBRRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:17:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140702160908.GA12510@waldemar-brodkorb.de>
References: <20140702160908.GA12510@waldemar-brodkorb.de>
From: Florian Fainelli <florian@openwrt.org>
Date: Wed, 2 Jul 2014 10:16:44 -0700
X-Google-Sender-Auth: LiS1vczhMPfuCtmWaztfBxok4ag
Message-ID: <CAGVrzcYQDrEyc4kNvbh_XFv-Hxoq0NB+c88N7TW6=7mypX7aYQ@mail.gmail.com>
Subject: Re: [PATCH] fix reregistering of serial console
To: Waldemar Brodkorb <wbx@openadk.org>
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-02 9:09 GMT-07:00 Waldemar Brodkorb <wbx@openadk.org>:
> Runtime tested on Mikrotik RB532 board.
> Thanks goes to Geert Uytterhoeven for the explanation of the problem.

The subject should be something like "MIPS: rb532: fix reregistering
of serial console" to be consistent with the other changes.

>
> "I'm afraid this is not gonna help. When the port is unregistered,
> its type will be reset to PORT_UNKNOWN.
> So before registering it again, its type must be set again the actual
> serial driver, cfr. the change to of_serial.c."
>
> Signed-off-by: Waldemar Brodkorb <wbx@openadk.org>

Reviewed-by: Florian Fainelli <florian@openwrt.org>

Thanks!

> ---
>  arch/mips/rb532/devices.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/mips/rb532/devices.c b/arch/mips/rb532/devices.c
> index 3af00b2..ba61268 100644
> --- a/arch/mips/rb532/devices.c
> +++ b/arch/mips/rb532/devices.c
> @@ -223,6 +223,7 @@ static struct platform_device rb532_wdt = {
>
>  static struct plat_serial8250_port rb532_uart_res[] = {
>         {
> +               .type           = PORT_16550A,
>                 .membase        = (char *)KSEG1ADDR(REGBASE + UART0BASE),
>                 .irq            = UART0_IRQ,
>                 .regshift       = 2,
> --
> 1.7.10.4
>
>



-- 
Florian
