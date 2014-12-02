Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbaLBOaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:30:07 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:48316 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbaLBOaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:30:05 -0500
MIME-Version: 1.0
In-Reply-To: <1417529705-1515-1-git-send-email-acourbot@nvidia.com>
References: <1417527724-24960-1-git-send-email-acourbot@nvidia.com>
	<1417529705-1515-1-git-send-email-acourbot@nvidia.com>
Date: Tue, 2 Dec 2014 15:30:02 +0100
X-Google-Sender-Auth: AEkn8lQHrTNxSIjd_2tRHFtj3cw
Message-ID: <CAMuHMdVfmJvaQkKv4gOPu=60gzb40=A56iq+p8dYhrTLcTPOyw@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: fix deferred probe detection for legacy API
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Tue, Dec 2, 2014 at 3:15 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Commit 14e85c0e69d5 ("gpio: remove gpio_descs global array") changed
> gpio_to_desc()'s behavior to return NULL not only for GPIOs numbers
> not in the valid range, but also for all GPIOs whose controller has not
> been probed yet. Although this behavior is more correct (nothing hints
> that these GPIO numbers will be populated later), this affects
> gpio_request() and gpio_request_one() which call gpiod_request() with a
> NULL descriptor, causing it to return -EINVAL instead of the expected
> -EPROBE_DEFER for a non-probed GPIO.
>
> gpiod_request() is only called with a descriptor obtained from
> gpio_to_desc() from these two functions, so address the issue there.
>
> Other ways to obtain GPIOs rely on well-defined mappings and can thus
> return -EPROBE_DEFER only for relevant GPIOs, and are thus not affected
> by this issue.
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> v2:
> - Add Geert's Tested-by
> - Only display scary warning on gpio_to_desc() is the GPIO is outside
>   the valid range (pre gpio_desc array removal behavior)

Thanks, the scary warnings are gone, together with a few superfluous
"gpio-0 (?): gpiod_request: status -517" messages.

Have a good night!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
