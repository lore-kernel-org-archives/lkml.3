Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab3FQFl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:41:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16784 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3FQFly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:41:54 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-ea-51bea19ea116
Date: Mon, 17 Jun 2013 07:41:44 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
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
Subject: Re: [PATCH v3 0/3] cpufreq:boost: CPU Boost mode support
Message-id: <20130617074144.74704814@amdc308.digital.local>
In-reply-to: <CAKohpo=N2U8u_kQVoWLbL-OeufFFBs8e--Unq29Tv+HC5ERaFg@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371195540-2991-1-git-send-email-l.majewski@samsung.com>
 <CAKohpo=N2U8u_kQVoWLbL-OeufFFBs8e--Unq29Tv+HC5ERaFg@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t9jQd35C/cFGqxqYbH483Y5q8XTph/s
	FvM+y1p0nn3CbNG74CqbxZtH3BaXd81hs/jce4TR4nbjCjaL/oW9TBYdR74xW2z86uHA43Hn
	2h42j3XT3jJ79G1ZxejxaHELo8fnTXIBrFFcNimpOZllqUX6dglcGXs7ZjEXrJasOHziIXsD
	4xeBLkYODgkBE4nD6427GDmBTDGJC/fWs3UxcnEICUxnlDi6aho7hNPOJPHg9zFWkCoWAVWJ
	1k+/2EFsNgE9ic93nzKBDBIR0JJ4eTMVpJ5Z4BmzxOMva8DqhQUcJc78Ws4EYvMKWEscP3sU
	LM4pECzR9KgfatsJRonDj08ygiT4BSQl2v/9YIY4yU7i3KcN7BDNghI/Jt9jAbGZgZZt3tbE
	CmHLS2xe85Z5AqPgLCRls5CUzUJStoCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcKw8
	k9rBuLLB4hCjAAejEg/vhup9gUKsiWXFlbmHGCU4mJVEeGMnAoV4UxIrq1KL8uOLSnNSiw8x
	SnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwFoR/DdMymRW1tPnkjU1qcbmuDE+yHIxF
	GJobin9s3P/mu3jRF51DIh/Y7M5WMObIlXUYhL+Yfe3NNqtU9nBp2bYMEVODdQYmU+uP3WlZ
	tdI2uEl+VaJX8pZyvhtxJ4JeVn6+3vJtTZpb8vazp3dMb++58uHQHGvp+1n7L6ileR2ZXRSv
	OkVbiaU4I9FQi7moOBEAm9ebNpECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jun 2013 08:50:30 +0530, Viresh Kumar wrote:

> On 14 June 2013 13:08, Lukasz Majewski <l.majewski@samsung.com> wrote:
> >  arch/arm/mach-s3c24xx/cpufreq.c              |    2 +-
> >  arch/powerpc/platforms/pasemi/cpufreq.c      |    2 +-
> >  arch/powerpc/platforms/powermac/cpufreq_32.c |    2 +-
> >  arch/powerpc/platforms/powermac/cpufreq_64.c |    2 +-
> >  drivers/cpufreq/acpi-cpufreq.c               |   62
> > +++++++----------- drivers/cpufreq/arm_big_little.c
> > |    3 +- drivers/cpufreq/blackfin-cpufreq.c           |    2 +-
> >  drivers/cpufreq/cpufreq-cpu0.c               |    2 +-
> >  drivers/cpufreq/cpufreq.c                    |   87
> > ++++++++++++++++++++++++++
> > drivers/cpufreq/cris-artpec3-cpufreq.c       |    2 +-
> > drivers/cpufreq/cris-etraxfs-cpufreq.c       |    2 +-
> > drivers/cpufreq/davinci-cpufreq.c            |    2 +-
> > drivers/cpufreq/dbx500-cpufreq.c             |    2 +-
> > drivers/cpufreq/e_powersaver.c               |    3 +-
> > drivers/cpufreq/elanfreq.c                   |    2 +-
> > drivers/cpufreq/exynos-cpufreq.c             |    7 ++-
> > drivers/cpufreq/exynos5440-cpufreq.c         |    2 +-
> > drivers/cpufreq/freq_table.c                 |   44 ++++++++++---
> > drivers/cpufreq/ia64-acpi-cpufreq.c          |    2 +-
> > drivers/cpufreq/imx6q-cpufreq.c              |    2 +-
> > drivers/cpufreq/kirkwood-cpufreq.c           |    3 +-
> > drivers/cpufreq/longhaul.c                   |    2 +-
> > drivers/cpufreq/loongson2_cpufreq.c          |    2 +-
> > drivers/cpufreq/maple-cpufreq.c              |    2 +-
> > drivers/cpufreq/omap-cpufreq.c               |    2 +-
> > drivers/cpufreq/p4-clockmod.c                |    2 +-
> > drivers/cpufreq/powernow-k6.c                |    2 +-
> > drivers/cpufreq/powernow-k7.c                |    2 +-
> > drivers/cpufreq/powernow-k8.c                |    2 +-
> > drivers/cpufreq/ppc_cbe_cpufreq.c            |    2 +-
> > drivers/cpufreq/pxa2xx-cpufreq.c             |    4 +-
> > drivers/cpufreq/pxa3xx-cpufreq.c             |    2 +-
> > drivers/cpufreq/s3c2416-cpufreq.c            |    2 +-
> > drivers/cpufreq/s3c64xx-cpufreq.c            |    2 +-
> > drivers/cpufreq/s5pv210-cpufreq.c            |    2 +-
> > drivers/cpufreq/sc520_freq.c                 |    2 +-
> > drivers/cpufreq/sh-cpufreq.c                 |    2 +-
> > drivers/cpufreq/sparc-us2e-cpufreq.c         |    2 +-
> > drivers/cpufreq/sparc-us3-cpufreq.c          |    2 +-
> > drivers/cpufreq/spear-cpufreq.c              |    3 +-
> > drivers/cpufreq/speedstep-centrino.c         |    2 +-
> > drivers/cpufreq/speedstep-ich.c              |    2 +-
> > drivers/cpufreq/speedstep-smi.c              |    2 +-
> > drivers/cpufreq/tegra-cpufreq.c              |    4 +-
> > include/linux/cpufreq.h                      |   18 +++++- 45 files
> > changed, 211 insertions(+), 95 deletions(-)
> 
> Wow!! I am shocked to see these many files getting updated :)

Hmm, CPUFREQ framework is quite popular :-). 

Changing this one particular function, seemed to be the best solution.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
