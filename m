Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbaEFPYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:24:49 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:51958 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaEFPYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:24:47 -0400
MIME-Version: 1.0
In-Reply-To: <1621123.rMC9JtD3Mo@vostro.rjw.lan>
References: <535AC247.3070907@semaphore.gr>
	<CAKohpok-74uK5k-adxjmEy71=vF8V7MaBwdCD1Vb2ats7FHi_A@mail.gmail.com>
	<535FCDBD.6080500@semaphore.gr>
	<1621123.rMC9JtD3Mo@vostro.rjw.lan>
Date: Tue, 6 May 2014 17:24:46 +0200
X-Google-Sender-Auth: Xzpbc9Wj362FOohxv50u1wx7wGo
Message-ID: <CAMuHMdU6eKQbmqvDj8Ra3MjuqhvFQ6WxoTsiJ4mojqXY4XOtaw@mail.gmail.com>
Subject: Re: [PATCH v5 0/8] Introduce new cpufreq helper macros
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stratos Karafotis <stratosk@semaphore.gr>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Simon Horman <horms@verge.net.au>, Sekhar Nori <nsekhar@ti.com>,
        Samuel Ortiz <samuel@sortiz.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stratos,

On Wed, Apr 30, 2014 at 12:26 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, April 29, 2014 07:05:17 PM Stratos Karafotis wrote:
>> On 29/04/2014 07:17 πμ, Viresh Kumar wrote:
>> > On 26 April 2014 01:45, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>> >> This patch set introduces two freq_table helper macros which
>> >> can be used for iteration over cpufreq_frequency_table and
>> >> makes the necessary changes to cpufreq core and drivers that
>> >> use such an iteration procedure.
>> >>
>> >> The motivation was a usage of common procedure to iterate over
>> >> cpufreq_frequency_table across all drivers and cpufreq core.
>> >>
>> >> This was tested on a x86_64 platform.
>> >> Most files compiled successfully but unfortunately I was not
>> >> able to compile sh_sir.c pasemi_cpufreq.c and ppc_cbe_cpufreq.c
>> >> due to lack of cross compiler.
>> >>
>> >> Changelog
>> >>
>> >> v4 -> v5
>> >>         - Fix warnings in printk format specifier for 32 bit
>> >>           architectures in freq_table.c, longhaul, pasemi, ppc_cbe
>> >
>> > Doesn't look much has changed and so it stays as is:
>> >
>> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>> >
>>
>> Thank you very much!
>
> I've applied the series to my bleeding-edge branch, will move it to linux-next
> after build testing later this week.

This breaks if CONFIG_CPU_FREQ=n, e.g. ARM/shmobile/koelsch/
non-multiplatform:

drivers/built-in.o: In function `clk_round_parent':
clkdev.c:(.text+0xcf168): undefined reference to `cpufreq_next_valid'
drivers/built-in.o: In function `clk_rate_table_find':
clkdev.c:(.text+0xcf820): undefined reference to `cpufreq_next_valid'
make[3]: *** [vmlinux] Error 1

drivers/sh/clk/core.c (pre-CCF shmobile clock core) calls
cpufreq_for_each_valid_entry():

#define cpufreq_for_each_valid_entry(pos, table)        \
        for (pos = table; cpufreq_next_valid(&pos); pos++)

but cpufreq_next_valid() in drivers/cpufreq/cpufreq.c is not
compiled in.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
