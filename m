Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab3GEAss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 20:48:48 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:43506 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3GEAsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 20:48:47 -0400
MIME-Version: 1.0
In-Reply-To: <1372951039-10375-1-git-send-email-k.krivyakin@samsung.com>
References: <1372951039-10375-1-git-send-email-k.krivyakin@samsung.com>
Date: Fri, 5 Jul 2013 09:48:46 +0900
X-Google-Sender-Auth: TKHyZq2LpyO2Cb9oRga5Eys2lGs
Message-ID: <CAH9JG2U-TTb+V-8tLnmSXz8CbYOex3H03GsoEsmeTjXumdAmwQ@mail.gmail.com>
Subject: Re: [PATCH RFC 0/3] Per-process power consumption measurement facility
From: Kyungmin Park <kmpark@infradead.org>
To: Konstantin Krivyakin <k.krivyakin@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, viresh.kumar@linaro.org,
        mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>
Cc: i.zhbanov@samsung.com, e.voevodin@samsung.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krivyakin,

Please use "./scripts/get_maintainer.pl" and send proper maintainers.

I added them.

Thank you,
Kyungmin Park

On Fri, Jul 5, 2013 at 12:17 AM, Konstantin Krivyakin
<k.krivyakin@samsung.com> wrote:
> This patchset adds per-process power consumption measurement facility.
> Power consumption is very important on mobile platforms. This code
> allows to measure consumed power in Watts*Hours. The consumed power
> for process is updated on scheduler switch and depends on current
> CPU voltage and frequency.
>
> The formula for computation is: P = C * V^2 * f, where C is a constant
> that reflects capacity of the system, V is the current voltage and
> f is the current frequency.
> (Taken from: http://en.wikipedia.org/wiki/CPU_power_dissipation).
>
> In this patchset was added implementation for Exynos platform
> to demonstrate how it works.
>
> To minimize scheduler impact for each CPU P-state the value of (V^2 *f)
> was precomputed at the time of platform initialization.
>
> And to reduce performance impact furthermore, the C constant is multiplied
> in userspace.
>
> Konstantin Krivyakin (3):
>   Add interface to receive current cpu power
>   Add power consumption counter in task_struct.
>   Update current cpu power when cpu freq change for exynos.
>
>  drivers/cpufreq/cpufreq.c            |   17 +++++++++++++++++
>  drivers/cpufreq/exynos-cpufreq.c     |    2 ++
>  drivers/cpufreq/exynos-cpufreq.h     |    1 +
>  drivers/cpufreq/exynos4x12-cpufreq.c |   19 ++++++++++++++++++-
>  include/linux/cpufreq.h              |    6 ++++++
>  include/linux/sched.h                |    2 ++
>  include/uapi/linux/taskstats.h       |    2 ++
>  kernel/fork.c                        |    1 +
>  kernel/sched/core.c                  |    8 ++++++++
>  kernel/sched/cputime.c               |   11 +++++++++++
>  kernel/tsacct.c                      |    3 +++
>  11 files changed, 71 insertions(+), 1 deletion(-)
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
