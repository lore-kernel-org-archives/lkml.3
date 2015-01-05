Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbbAELkC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:40:02 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:36583 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbbAELj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:39:58 -0500
MIME-Version: 1.0
In-Reply-To: <1420130951-29766-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420130951-29766-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 5 Jan 2015 12:39:57 +0100
X-Google-Sender-Auth: vm05BoZa7I1oB1GMrv258kG0ssU
Message-ID: <CAMuHMdUSWJW=ozYgPSBysEk9hrVF0eqXScaHU25zPWzEyZYFbw@mail.gmail.com>
Subject: Re: [PATCH] arch: m68k: mvme147: config.c: Remove unused function
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2015 at 5:49 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Remove the function mvme147_init_console_port() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  arch/m68k/mvme147/config.c |    5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
> index 1bb3ce6..5da5e6e 100644
> --- a/arch/m68k/mvme147/config.c
> +++ b/arch/m68k/mvme147/config.c
> @@ -209,8 +209,3 @@ void m147_scc_write (struct console *co, const char *str, unsigned count)
>         }
>         local_irq_restore(flags);
>  }
> -
> -void mvme147_init_console_port (struct console *co, int cflag)
> -{
> -       co->write    = m147_scc_write;
> -}

And after that m147_scc_write() becomes unused, and scc_write(), and
scc_delay()... I will remove these, too.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
