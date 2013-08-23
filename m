Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab3HWMSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:18:05 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:52180 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3HWMSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:18:03 -0400
MIME-Version: 1.0
In-Reply-To: <1376591851-31854-1-git-send-email-slyfox@gentoo.org>
References: <1376591851-31854-1-git-send-email-slyfox@gentoo.org>
Date: Fri, 23 Aug 2013 14:18:02 +0200
X-Google-Sender-Auth: tOybvY7AbdYxyHptstCTCDPPmAg
Message-ID: <CAMuHMdXRb2K+WSfFGK=SASTU=+fUZ3XRQQ-+5xoDS=04HG92OQ@mail.gmail.com>
Subject: Re: [PATCH v2] Makefile: enable -Werror=implicit-int and
 -Werror=strict-prototypes by default
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sergei Trofimovich <slyfox@gentoo.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 8:37 PM, Sergei Trofimovich <slyfox@gentoo.org> wrote:
> diff --git a/Makefile b/Makefile
> index 6e48848..53f4776 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -374,6 +374,11 @@ KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
>                    -Werror-implicit-function-declaration \
>                    -Wno-format-security \
>                    -fno-delete-null-pointer-checks
> +
> +# not universally available, but nice to have ones
> +KBUILD_CFLAGS   +=  $(call cc-option,-Werror=implicit-int) \
> +                   $(call cc-option,-Werror=strict-prototypes)
> +

This should be _below_ the line

    include $(srctree)/arch/$(SRCARCH)/Makefile

, together with the other users of cc-option, else it detects the features of
the host compiler instead of the cross-compiler when cross-compiling:

cc1: error: unrecognized command line option "-Werror=implicit-int"
cc1: error: unrecognized command line option "-Werror=strict-prototypes"

See also commit a1f42beb8e287482d1a802731d4fb7e2bdc2c703
("Makefile: fix up CROSS_COMPILE and READABLE_ASM interaction.").

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
