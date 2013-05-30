Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967852Ab3E3H5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:57:18 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:59552 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967643Ab3E3H5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:57:12 -0400
MIME-Version: 1.0
In-Reply-To: <1369756432-5552-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <CAMuHMdV8gJew_x1+L3O51sB=JU_EvJ-Y05JxKSsXUi+B43HAJA@mail.gmail.com>
	<1369756432-5552-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1369756432-5552-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 30 May 2013 09:57:11 +0200
X-Google-Sender-Auth: 5OkblL_Nmgets2rt3-xWSBVx7_g
Message-ID: <CAMuHMdXBk6vMFNOJVsxYnt8qvuQN2xveXFaSTM8tUTbiEgPArQ@mail.gmail.com>
Subject: Re: [PATCH] cris: kgdb: use native hex2bin
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cris <linux-cris-kernel@axis.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 5:53 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
> index 37e6d2c..07bccd8 100644
> --- a/arch/cris/arch-v10/kernel/kgdb.c
> +++ b/arch/cris/arch-v10/kernel/kgdb.c

> @@ -659,18 +651,6 @@ read_register (char regno, unsigned int *valptr)
>  }
>
>  /********************************** Packet I/O ******************************/
> -/* Returns the integer equivalent of a hexadecimal character. */
> -static int
> -hex (char ch)
> -{
> -       if ((ch >= 'a') && (ch <= 'f'))
> -               return (ch - 'a' + 10);
> -       if ((ch >= '0') && (ch <= '9'))
> -               return (ch - '0');
> -       if ((ch >= 'A') && (ch <= 'F'))
> -               return (ch - 'A' + 10);
> -       return (-1);
> -}

This one handles both upper and lower case hex characters, while hex2bin()
handles lower case only. Is that OK, or should hex2bin be extended?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
