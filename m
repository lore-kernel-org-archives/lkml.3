Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab3IBVBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 17:01:40 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55963 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab3IBVBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 17:01:38 -0400
MIME-Version: 1.0
In-Reply-To: <1378147630-12471-1-git-send-email-teg@jklm.no>
References: <1378147630-12471-1-git-send-email-teg@jklm.no>
Date: Mon, 2 Sep 2013 23:01:37 +0200
Message-ID: <CAFLxGvy+oBg-Qbd_8wL-86ODpB9fand2aVcyVcRRLarRe40wSw@mail.gmail.com>
Subject: Re: [PATCH] input: allow SERIO=m even without EXPERT=y
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Tom Gundersen <teg@jklm.no>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 2, 2013 at 8:47 PM, Tom Gundersen <teg@jklm.no> wrote:
> There is plenty of consumer hardware (e.g., mac books) that does not use
> AT keyboards or PS/2 mice. It therefore makes sense for distro kernels
> to build the related drivers as modules to avoid loading them on hardware
> that does not need them. As such, these options should no longer be protected
> by EXPERT.
>
> Moreover, building these drivers as modules gets rid of the following ugly
> error during boot:
>
> [    2.337745] i8042: PNP: No PS/2 controller found. Probing ports directly.
> [    3.439537] i8042: No controller found
>
> Signed-off-by: Tom Gundersen <teg@jklm.no>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/input/keyboard/Kconfig | 4 ++--
>  drivers/input/serio/Kconfig    | 6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index 269d4c3..2d31cec 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -2,7 +2,7 @@
>  # Input core configuration
>  #
>  menuconfig INPUT_KEYBOARD
> -       bool "Keyboards" if EXPERT || !X86
> +       bool "Keyboards"

Maybe this a stupid question, but why are you dropping the "!X86" too?

>         default y
>         help
>           Say Y here, and a list of supported keyboards will be displayed.
> @@ -67,7 +67,7 @@ config KEYBOARD_ATARI
>           module will be called atakbd.
>
>  config KEYBOARD_ATKBD
> -       tristate "AT keyboard" if EXPERT || !X86
> +       tristate "AT keyboard"
>         default y
>         select SERIO
>         select SERIO_LIBPS2
> diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
> index 1e691a3..39c869d 100644
> --- a/drivers/input/serio/Kconfig
> +++ b/drivers/input/serio/Kconfig
> @@ -2,7 +2,7 @@
>  # Input core configuration
>  #
>  config SERIO
> -       tristate "Serial I/O support" if EXPERT || !X86
> +       tristate "Serial I/O support"
>         default y
>         help
>           Say Yes here if you have any input device that uses serial I/O to
> @@ -19,7 +19,7 @@ config SERIO
>  if SERIO
>
>  config SERIO_I8042
> -       tristate "i8042 PC Keyboard controller" if EXPERT || !X86
> +       tristate "i8042 PC Keyboard controller"
>         default y
>         depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
>                    (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN && !S390 && \
> @@ -170,7 +170,7 @@ config SERIO_MACEPS2
>           module will be called maceps2.
>
>  config SERIO_LIBPS2
> -       tristate "PS/2 driver library" if EXPERT
> +       tristate "PS/2 driver library"
>         depends on SERIO_I8042 || SERIO_I8042=n
>         help
>           Say Y here if you are using a driver for device connected
> --
> 1.8.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
