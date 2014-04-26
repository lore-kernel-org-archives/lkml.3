Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaDZG3h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 02:29:37 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:56113 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaDZG3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 02:29:35 -0400
MIME-Version: 1.0
In-Reply-To: <1397859600-11507-4-git-send-email-robherring2@gmail.com>
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
	<1397859600-11507-4-git-send-email-robherring2@gmail.com>
Date: Fri, 25 Apr 2014 23:29:35 -0700
X-Google-Sender-Auth: EFBU65hpbzzf6KaiPsTVCQhbc2M
Message-ID: <CAE9FiQVp5u-jF_xjCu68BgbZ=e0D508tn_-auoiT6cbkYtX8Og@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] tty/serial: convert 8250 to generic earlycon
From: Yinghai Lu <yinghai@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 3:19 PM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <robh@kernel.org>
>
> With the generic earlycon infrastructure in place, convert the 8250
> early console to use it.
>
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> ---
>  drivers/tty/serial/8250/8250_early.c | 138 ++++-------------------------------
>  drivers/tty/serial/8250/Kconfig      |   1 +
>  2 files changed, 16 insertions(+), 123 deletions(-)
>
> diff --git a/drivers/tty/serial/8250/8250_early.c b/drivers/tty/serial/8250/8250_early.c
> index c100d63..e83c9db 100644
> --- a/drivers/tty/serial/8250/8250_early.c
> +++ b/drivers/tty/serial/8250/8250_early.c
> @@ -35,18 +35,8 @@
...
> -
> -int __init setup_early_serial8250_console(char *cmdline)

You removed global function, but still left declaration and calling...

arch/mips/mti-malta/malta-init.c:
setup_early_serial8250_console(console_string);
drivers/firmware/pcdp.c:        return setup_early_serial8250_console(options);
include/linux/serial_8250.h:extern int
setup_early_serial8250_console(char *cmdline);

Yinghai
