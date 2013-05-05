Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab3EEIYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 04:24:49 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:40123 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3EEIYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 04:24:45 -0400
MIME-Version: 1.0
In-Reply-To: <87sj22zuga.fsf_-_@hase.home>
References: <51814943.7000604@intel.com>
	<20130501182138.GA17550@kroah.com>
	<5B8DA87D05A7694D9FA63FD143655C1B01F18E66@HASMSX106.ger.corp.intel.com>
	<518284E6.7040503@intel.com>
	<CAMuHMdWSVUcwkY=xn+HjbruLxsc8Eqq=CWX78CdUc1+MAwCVhg@mail.gmail.com>
	<87sj22zuga.fsf_-_@hase.home>
Date: Sun, 5 May 2013 10:24:43 +0200
X-Google-Sender-Auth: tF6maA4U0P2IaT7hGRovWp4owA8
Message-ID: <CAMuHMdX6PETQqQG-ASDv4OtLyB=X0hNyQRaSO13rUHf_HqNt3w@mail.gmail.com>
Subject: Re: [PATCH] Fix cleaning in scripts/mod
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Dave Hansen <dave.hansen@intel.com>,
        "Winkler, Tomas" <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "SamuelOrtiz@kroah.com" <SamuelOrtiz@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 4, 2013 at 4:32 PM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Make sure devicetable-offsets.h is cleaned in the scripts/mod directory
>
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  scripts/mod/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
> index 9415b56..75d59fc 100644
> --- a/scripts/mod/Makefile
> +++ b/scripts/mod/Makefile
> @@ -37,6 +37,8 @@ scripts/mod/devicetable-offsets.s: scripts/mod/devicetable-offsets.c FORCE
>  $(obj)/$(devicetable-offsets-file): scripts/mod/devicetable-offsets.s
>         $(call cmd,offsets)
>
> +targets += $(devicetable-offsets-file)
> +
>  # dependencies on generated files need to be listed explicitly
>
>  $(obj)/modpost.o $(obj)/file2alias.o $(obj)/sumversion.o: $(obj)/elfconfig.h

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
