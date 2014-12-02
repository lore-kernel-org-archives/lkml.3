Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbaLBOL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:11:29 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:37888 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaLBOLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:11:15 -0500
MIME-Version: 1.0
In-Reply-To: <1417527724-24960-1-git-send-email-acourbot@nvidia.com>
References: <CAAVeFuJm_UXHioENBg6himgZkEmopr=T8iCbt0xD6-ds6AHyxA@mail.gmail.com>
	<1417527724-24960-1-git-send-email-acourbot@nvidia.com>
Date: Tue, 2 Dec 2014 15:11:13 +0100
X-Google-Sender-Auth: B-WOLJNA_nsX9__y-MVbEvJYquY
Message-ID: <CAMuHMdUVZ9st+UjTcfmncnBQjj_4tiNS3wFu-SpRUdGmg220Ug@mail.gmail.com>
Subject: Re: [PATCH] gpio: fix deferred probe detection for legacy API
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On Tue, Dec 2, 2014 at 2:42 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
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

Thanks, this restored functionality. There's still a loud
WARN(1, "invalid GPIO %d\n", gpio) in gpio_to_desc().

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
