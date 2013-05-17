Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab3EQQF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 12:05:27 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:62899 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab3EQQF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 12:05:26 -0400
MIME-Version: 1.0
In-Reply-To: <1368095819-11011-9-git-send-email-yefremov.denis@gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
	<1368095819-11011-9-git-send-email-yefremov.denis@gmail.com>
Date: Fri, 17 May 2013 18:05:25 +0200
X-Google-Sender-Auth: x148cZaIMnCKD25zWyK6fc0N2Wo
Message-ID: <CAMuHMdUU5+WJnYER8kO2Ne2iaBQESYp_bbBMTLDvTEJchDu15A@mail.gmail.com>
Subject: Re: [PATCH 20/21] powerpc/ps3: remove inline marking of EXPORT_SYMBOL functions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: Geoff Levand <geoff@infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>, ldv-project@linuxtesting.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 12:36 PM, Denis Efremov <yefremov.denis@gmail.com> wrote:
> EXPORT_SYMBOL and inline directives are contradictory to each other.
> The patch fixes this inconsistency.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
> ---
>  arch/powerpc/platforms/ps3/spu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/platforms/ps3/spu.c b/arch/powerpc/platforms/ps3/spu.c
> index e17fa14..a0bca05 100644
> --- a/arch/powerpc/platforms/ps3/spu.c
> +++ b/arch/powerpc/platforms/ps3/spu.c
> @@ -143,7 +143,7 @@ static void _dump_areas(unsigned int spe_id, unsigned long priv2,
>         pr_debug("%s:%d: shadow:  %lxh\n", func, line, shadow);
>  }
>
> -inline u64 ps3_get_spe_id(void *arg)
> +u64 ps3_get_spe_id(void *arg)
>  {
>         return spu_pdata(arg)->spe_id;
>  }

FYI, this symbol is not used in mainline.

IIRC, it's used for profiling only. Any chance the profile code will
ever make it
in mainline?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
