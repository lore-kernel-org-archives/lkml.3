Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaEHFjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 01:39:07 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:51125 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaEHFjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 01:39:03 -0400
MIME-Version: 1.0
In-Reply-To: <536A605D.6030009@semaphore.gr>
References: <536A605D.6030009@semaphore.gr>
Date: Thu, 8 May 2014 11:09:02 +0530
Message-ID: <CAKohponPkv1gyCVca3Vigv2jSv7G49Jyu_dHDJ2BEMXDkfr-jw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Fix build error on some platforms that use cpufreq_for_each_*
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2014 22:03, Stratos Karafotis <stratosk@semaphore.gr> wrote:
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
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/cpufreq.c | 11 -----------
>  include/linux/cpufreq.h   | 11 +++++++++--
>  2 files changed, 9 insertions(+), 13 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
