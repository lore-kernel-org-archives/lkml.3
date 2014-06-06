Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaFFEr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 00:47:59 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:62429 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaFFEr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 00:47:57 -0400
MIME-Version: 1.0
Date: Fri, 6 Jun 2014 10:17:56 +0530
Message-ID: <CAKohpo=MQEpMo8FYzaPwaaFuPsDKus5=U+nduqDGu5NtG-j+JA@mail.gmail.com>
Subject: Re: [PATCH] Documentation, intel_pstate: Add a description of the
 intel_pstate internal governors [v3]
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 June 2014 22:51, Prarit Bhargava <prarit@redhat.com> wrote:
> The current documentation is incomplete wrt the intel_pstate internal
> governors.  The confusion comes from the general use internal governors
> which also use the names performance and powersave.  This patch
> differentiates between the two sets of governors.
>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Ramkumar Ramachandra <artagnon@gmail.com>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: linux-doc@vger.kernel.org
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>
> [v2]: text update
> [v3]: text update

This will get into 'git logs' :(, you should have placed those below the ---
on the next line.

In case we are going to do a resend of this please change subject to:

I have seen some commits where [v3] in $subject is pushed into the logs,
but I am not sure if that's the right way. Why would we need to
know which version went into the kernel? In case maintainer
picked the wrong version we can simply check the diff..

cpufreq: documentation/intel_pstate: Add a description of the
intel_pstate internal governors

Anyway, I think Rafael might do these changes himself. So
don't resend it unless he asks for..

> ---
>  Documentation/cpu-freq/governors.txt    |    2 +-
>  Documentation/cpu-freq/intel-pstate.txt |    8 ++++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/cpu-freq/governors.txt b/Documentation/cpu-freq/governors.txt
> index 77ec215..c15aa75 100644
> --- a/Documentation/cpu-freq/governors.txt
> +++ b/Documentation/cpu-freq/governors.txt
> @@ -36,7 +36,7 @@ Contents:
>  1. What Is A CPUFreq Governor?
>  ==============================
>
> -Most cpufreq drivers (in fact, all except one, longrun) or even most
> +Most cpufreq drivers (except the intel_pstate and longrun) or even most
>  cpu frequency scaling algorithms only offer the CPU to be set to one
>  frequency. In order to offer dynamic frequency scaling, the cpufreq
>  core must be able to tell these drivers of a "target frequency". So
> diff --git a/Documentation/cpu-freq/intel-pstate.txt b/Documentation/cpu-freq/intel-pstate.txt
> index e742d21..7e9db8f 100644
> --- a/Documentation/cpu-freq/intel-pstate.txt
> +++ b/Documentation/cpu-freq/intel-pstate.txt
> @@ -9,6 +9,14 @@ assumed to implement internal governors by the cpufreq core. All the
>  logic for selecting the current P state is contained within the
>  driver; no external governor is used by the cpufreq core.
>
> +The Intel P-state driver has two internal governors, performance and
> +powersave.  These governors differ from the generally used governors of the
> +same name in the kernel.  The internal performance governor sets the
> +max_perf_pct and min_perf_pct to 100; that is, the governor selects the
> +highest available P state to maximize the performance of the core.  The
> +internal powersave governor selects the appropriate P state based on the
> +current load on the CPU.
> +
>  Intel SandyBridge+ processors are supported.
>
>  New sysfs files for controlling P state selection have been added to

Otherwise looks good:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
