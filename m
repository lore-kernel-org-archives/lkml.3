Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbbALXvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:51:25 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55417 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbbALXvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:51:24 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Robert Jarzmik <robert.jarzmik@free.fr>, "Daniel Mack" <daniel@zonque.org>,
        "Haojian Zhuang" <haojian.zhuang@gmail.com>,
        "Robert Jarzmik" <robert.jarzmik@free.fr>,
        "Stephen Boyd" <sboyd@codeaurora.org>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        "Arnd Bergmann" <arnd@arndb.de>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1419688528-760-4-git-send-email-robert.jarzmik@free.fr>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1419688528-760-1-git-send-email-robert.jarzmik@free.fr>
 <1419688528-760-4-git-send-email-robert.jarzmik@free.fr>
Message-ID: <20150112235117.20842.79524@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 3/4] arm: pxa: move gpio11 clock to board files
Date: Mon, 12 Jan 2015 15:51:17 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Robert Jarzmik (2014-12-27 05:55:27)
> The pxa25x gpio11 clock output was previously selected on its pin by the
> clock enabling, toggling the pin function.
> 
> As we transition to common clock framework, the pin function is moved to
> board file for the 2 users, ie. lubbock and eseries.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

Reviewed-by: Michael Turquette <mturquette@linaro.org>

> ---
>  arch/arm/mach-pxa/eseries.c | 5 ++++-
>  arch/arm/mach-pxa/lubbock.c | 3 +++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-pxa/eseries.c b/arch/arm/mach-pxa/eseries.c
> index cfb8641..d8fc9a3 100644
> --- a/arch/arm/mach-pxa/eseries.c
> +++ b/arch/arm/mach-pxa/eseries.c
> @@ -683,7 +683,7 @@ static unsigned long e750_pin_config[] __initdata = {
>         /* PC Card */
>         GPIO8_GPIO,   /* CD0 */
>         GPIO44_GPIO,  /* CD1 */
> -       GPIO11_GPIO,  /* IRQ0 */
> +       /* GPIO11_GPIO,  IRQ0 */
>         GPIO6_GPIO,   /* IRQ1 */
>         GPIO27_GPIO,  /* RST0 */
>         GPIO24_GPIO,  /* RST1 */
> @@ -778,6 +778,9 @@ static unsigned long e800_pin_config[] __initdata = {
>         GPIO29_AC97_SDATA_IN_0,
>         GPIO30_AC97_SDATA_OUT,
>         GPIO31_AC97_SYNC,
> +
> +       /* tc6393xb */
> +       GPIO11_3_6MHz,
>  };
>  
>  static struct w100_gen_regs e800_lcd_regs = {
> diff --git a/arch/arm/mach-pxa/lubbock.c b/arch/arm/mach-pxa/lubbock.c
> index d8a1be6..b742708 100644
> --- a/arch/arm/mach-pxa/lubbock.c
> +++ b/arch/arm/mach-pxa/lubbock.c
> @@ -101,6 +101,9 @@ static unsigned long lubbock_pin_config[] __initdata = {
>         GPIO6_MMC_CLK,
>         GPIO8_MMC_CS0,
>  
> +       /* SA1111 chip */
> +       GPIO11_3_6MHz,
> +
>         /* wakeup */
>         GPIO1_GPIO | WAKEUP_ON_EDGE_RISE,
>  };
> -- 
> 2.1.0
> 
