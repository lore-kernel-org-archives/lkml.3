Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaDPEBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:01:38 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:45796 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaDPEBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:01:35 -0400
MIME-Version: 1.0
In-Reply-To: <534DB1CC.60407@semaphore.gr>
References: <534DB1CC.60407@semaphore.gr>
Date: Wed, 16 Apr 2014 09:31:34 +0530
Message-ID: <CAKohpomvmpiYkQAP7Yb=TNxNsXMVh1_MLuK7KQrdEkf15MyvMg@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Introduce new cpufreq helper macros
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>, linux-doc@vger.kernel.org,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 April 2014 03:55, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> Hi all,
>
> This patch set introduces two freq_table helper macros which
> can be used for iteration over cpufreq_frequency_table and
> makes the necessary changes to cpufreq core and drivers that
> use such an iteration procedure.
>
> The motivation was a usage of common procedure to iterate over
> cpufreq_frequency_table across all drivers and cpufreq core.
>
> This was tested on a x86_64 platform.
> Most files compiled successfully but unfortunately I was not
> able to compile sh_sir.c pasemi_cpufreq.c and ppc_cbe_cpufreq.c
> due to lack of cross compiler.
>
> Changes v1 -> v2
>         - Rearrange patches
>         - Remove redundant braces
>         - Fix a newly introduced bug in exynos5440
>         - Use cpufreq_for_each_valid_entry instead of
> cpufreq_for_each_entry in cpufreq_frequency_table_get_index()
>         - Drop redundant double ! operator in longhaul and change

You dropped this !! in thermal stuff and not longhaul :)

> the pos loop cursor variable to freq_pos.
>         - Declare pos variable on a separate line
>
> Stratos Karafotis (8):
>   cpufreq: Introduce macros for cpufreq_frequency_table iteration
>   cpufreq: Use cpufreq_for_each_* macros for frequency table iteration
>   davinci: da850: Use cpufreq_for_each_entry macro for iteration
>   mips: lemote 2f: se cpufreq_for_each_entry macro for iteration
>   mfd: db8500-prcmu: Use cpufreq_for_each_entry macro for iteration
>   thermal: cpu_cooling: Use cpufreq_for_each_valid_entry macro for
>     iteration
>   irda: sh_sir: Use cpufreq_for_each_valid_entry macro for iteration
>   sh: clk: Use cpufreq_for_each_valid_entry macro for iteration

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
