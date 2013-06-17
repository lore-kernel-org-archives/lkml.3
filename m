Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab3FQD2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 23:28:18 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:49798 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab3FQD2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 23:28:17 -0400
MIME-Version: 1.0
In-Reply-To: <1371195540-2991-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1371195540-2991-1-git-send-email-l.majewski@samsung.com>
Date: Mon, 17 Jun 2013 08:50:30 +0530
Message-ID: <CAKohpo=N2U8u_kQVoWLbL-OeufFFBs8e--Unq29Tv+HC5ERaFg@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] cpufreq:boost: CPU Boost mode support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 June 2013 13:08, Lukasz Majewski <l.majewski@samsung.com> wrote:
>  arch/arm/mach-s3c24xx/cpufreq.c              |    2 +-
>  arch/powerpc/platforms/pasemi/cpufreq.c      |    2 +-
>  arch/powerpc/platforms/powermac/cpufreq_32.c |    2 +-
>  arch/powerpc/platforms/powermac/cpufreq_64.c |    2 +-
>  drivers/cpufreq/acpi-cpufreq.c               |   62 +++++++-----------
>  drivers/cpufreq/arm_big_little.c             |    3 +-
>  drivers/cpufreq/blackfin-cpufreq.c           |    2 +-
>  drivers/cpufreq/cpufreq-cpu0.c               |    2 +-
>  drivers/cpufreq/cpufreq.c                    |   87 ++++++++++++++++++++++++++
>  drivers/cpufreq/cris-artpec3-cpufreq.c       |    2 +-
>  drivers/cpufreq/cris-etraxfs-cpufreq.c       |    2 +-
>  drivers/cpufreq/davinci-cpufreq.c            |    2 +-
>  drivers/cpufreq/dbx500-cpufreq.c             |    2 +-
>  drivers/cpufreq/e_powersaver.c               |    3 +-
>  drivers/cpufreq/elanfreq.c                   |    2 +-
>  drivers/cpufreq/exynos-cpufreq.c             |    7 ++-
>  drivers/cpufreq/exynos5440-cpufreq.c         |    2 +-
>  drivers/cpufreq/freq_table.c                 |   44 ++++++++++---
>  drivers/cpufreq/ia64-acpi-cpufreq.c          |    2 +-
>  drivers/cpufreq/imx6q-cpufreq.c              |    2 +-
>  drivers/cpufreq/kirkwood-cpufreq.c           |    3 +-
>  drivers/cpufreq/longhaul.c                   |    2 +-
>  drivers/cpufreq/loongson2_cpufreq.c          |    2 +-
>  drivers/cpufreq/maple-cpufreq.c              |    2 +-
>  drivers/cpufreq/omap-cpufreq.c               |    2 +-
>  drivers/cpufreq/p4-clockmod.c                |    2 +-
>  drivers/cpufreq/powernow-k6.c                |    2 +-
>  drivers/cpufreq/powernow-k7.c                |    2 +-
>  drivers/cpufreq/powernow-k8.c                |    2 +-
>  drivers/cpufreq/ppc_cbe_cpufreq.c            |    2 +-
>  drivers/cpufreq/pxa2xx-cpufreq.c             |    4 +-
>  drivers/cpufreq/pxa3xx-cpufreq.c             |    2 +-
>  drivers/cpufreq/s3c2416-cpufreq.c            |    2 +-
>  drivers/cpufreq/s3c64xx-cpufreq.c            |    2 +-
>  drivers/cpufreq/s5pv210-cpufreq.c            |    2 +-
>  drivers/cpufreq/sc520_freq.c                 |    2 +-
>  drivers/cpufreq/sh-cpufreq.c                 |    2 +-
>  drivers/cpufreq/sparc-us2e-cpufreq.c         |    2 +-
>  drivers/cpufreq/sparc-us3-cpufreq.c          |    2 +-
>  drivers/cpufreq/spear-cpufreq.c              |    3 +-
>  drivers/cpufreq/speedstep-centrino.c         |    2 +-
>  drivers/cpufreq/speedstep-ich.c              |    2 +-
>  drivers/cpufreq/speedstep-smi.c              |    2 +-
>  drivers/cpufreq/tegra-cpufreq.c              |    4 +-
>  include/linux/cpufreq.h                      |   18 +++++-
>  45 files changed, 211 insertions(+), 95 deletions(-)

Wow!! I am shocked to see these many files getting updated :)
