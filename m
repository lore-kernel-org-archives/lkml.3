Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaEHI1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:27:19 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:60321 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaEHI1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:27:16 -0400
MIME-Version: 1.0
In-Reply-To: <536A605D.6030009@semaphore.gr>
References: <536A605D.6030009@semaphore.gr>
Date: Thu, 8 May 2014 10:27:15 +0200
X-Google-Sender-Auth: 0b7BcftC6SHs_Ni_EUJ1wEJlNZU
Message-ID: <CAMuHMdWSMG0ShnkZR4E=HvqNQzk6DEdHQdr0qYqxw1THmOLanA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Fix build error on some platforms that use cpufreq_for_each_*
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stratos,

On Wed, May 7, 2014 at 6:33 PM, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> On platforms that use cpufreq_for_each_* macros, build fails if
> CONFIG_CPU_FREQ=n, e.g. ARM/shmobile/koelsch/non-multiplatform:
>
> drivers/built-in.o: In function `clk_round_parent':
> clkdev.c:(.text+0xcf168): undefined reference to `cpufreq_next_valid'
> drivers/built-in.o: In function `clk_rate_table_find':
> clkdev.c:(.text+0xcf820): undefined reference to `cpufreq_next_valid'
> make[3]: *** [vmlinux] Error 1
>
> Fix this making cpufreq_next_valid function inline and move it to
> cpufreq.h.

Thanks!

> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
