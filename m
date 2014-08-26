Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944AbaHZHqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:46:14 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:63522 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933859AbaHZHqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:46:07 -0400
MIME-Version: 1.0
In-Reply-To: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
References: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
Date: Tue, 26 Aug 2014 09:46:05 +0200
X-Google-Sender-Auth: Fn_-J9H9-Y-SjjpBS-hhdUKZ0SQ
Message-ID: <CAMuHMdWwhLuPp_-4Mhnk4tb_azCeLU7bYEgBUf4zR5bMmd6RHQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] mmc: tmio: Fixup PM support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Linux MMC List <linux-mmc@vger.kernel.org>,
        Ian Molton <ian.molton@codethink.co.uk>, Chris Ball <chris@printf.net>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On Mon, Aug 25, 2014 at 2:25 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> This patchset fixup the PM support for tmio and the tmio hosts.
> Some re-structuring of the code was also necessary to accomplish the above.
>
> A few of these patches has been posted earlier, but at that time I couldn't get
> help in testing them on hardware. Let's give this a second try now.
>
> http://www.spinics.net/lists/linux-mmc/msg23177.html
>
> Ulf Hansson (12):
>   mmc: tmio: Keep host active while SDIO IRQ is enabled
>   mmc: tmio: Keep host active while serving requests
>   mmc: tmio: Extract bus_width modifications to a separate function
>   mmc: tmio: Restructure ->set_ios() and adapt ->probe() to it
>   mmc: tmio: Handle clock gating from runtime PM functions
>   mmc: tmio: Mask all IRQs when inactive
>   mmc: tmio: Make runtime PM callbacks available for CONFIG_PM
>   mmc: sdhi: Make runtime PM callbacks available for CONFIG_PM
>   mmc: tmio_mmc: Enable runtime PM support
>   mmc: sdhi: Fixup system PM suspend lock-up
>   mmc: tmio_mmc: Fixup system PM suspend lock-up
>   mmc: tmio: Remove library functions for system PM

I gave this series a test run on r8a7791/Koelsch, everything seems to
work fine.
Even more important, s2ram was fixed by "mmc: sdhi: Fixup system PM
suspend lock-up".

For the whole series:
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
