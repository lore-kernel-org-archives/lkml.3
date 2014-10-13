Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaJMQQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 12:16:14 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33907 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbaJMQQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 12:16:12 -0400
MIME-Version: 1.0
In-Reply-To: <1412234489-1330-1-git-send-email-thierry.reding@gmail.com>
References: <1412234489-1330-1-git-send-email-thierry.reding@gmail.com>
Date: Mon, 13 Oct 2014 18:16:10 +0200
X-Google-Sender-Auth: mFJGKHfAyV1wa3MnXzMpiKFJWC4
Message-ID: <CAMuHMdXG1pD1-O2m1NXp6gr4aVqyqV=-x-nPoWQJMWr_0XF42w@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-jpeg: Only build suspend/resume for PM
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 9:21 AM, Thierry Reding <thierry.reding@gmail.com> wrote:
> From: Thierry Reding <treding@nvidia.com>
>
> If power management is disabled these function become unused, so there
> is no reason to build them. This fixes a couple of build warnings when
> PM(_SLEEP,_RUNTIME) is not enabled.

Thanks!

Despite the availability of your patch, this build warning has
migrated to mainline.

> Signed-off-by: Thierry Reding <treding@nvidia.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c

> @@ -2681,7 +2682,9 @@ static int s5p_jpeg_runtime_resume(struct device *dev)
>
>         return 0;
>  }
> +#endif

I'd add a comment "/* CONFIG_PM_RUNTIME || CONFIG_PM_SLEEP */" here,
as above is a big block of code.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
