Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaCKNKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:10:35 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:59132 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbaCKNKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:10:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140311104713.GN28112@sirena.org.uk>
References: <1394531952-3905-1-git-send-email-geert@linux-m68k.org>
	<1394531952-3905-3-git-send-email-geert@linux-m68k.org>
	<20140311104713.GN28112@sirena.org.uk>
Date: Tue, 11 Mar 2014 14:10:31 +0100
X-Google-Sender-Auth: CRuGUJDkiZquz5Z6g4OTrc9801g
Message-ID: <CAMuHMdWoPWebnyUu2uGebbnzu68Lh4qsgzpu-otnwMmvaeY1hQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] spi: rspi: Add runtime PM support, using spi core auto_runtime_pm
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Mar 11, 2014 at 11:47 AM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Mar 11, 2014 at 10:59:12AM +0100, Geert Uytterhoeven wrote:
>> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>
> Applied, thanks, though...
>
>> -     ret = clk_prepare_enable(rspi->clk);
>> -     if (ret < 0) {
>> -             dev_err(&pdev->dev, "unable to prepare/enable clock\n");
>> -             goto error1;
>> -     }
>> +     pm_runtime_enable(&pdev->dev);
>
> ...due to the runtime PM API being configurable you're supposed to start
> off with the device runtime enabled (this applies to some of the other
> patches too).  I'm not sure that's terribly realistic for these drivers
> though.

Can you please elaborate what should be fixed?

If I disable CONFIG_PM_RUNTIME, the kernel prints:

    Runtime PM disabled, clock forced on.

and the clock is enabled all the time (verified by looking at the clock
registers)?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
