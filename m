Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaFEPKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:10:38 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:38163 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaFEPKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:10:36 -0400
Message-ID: <53908869.6060401@gmail.com>
Date: Thu, 05 Jun 2014 08:10:33 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
CC: dirk.brandewie@gmail.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation, intel_pstate: Add a description of the
 intel_pstate internal governors [v2]
References: <CAKohpokDZBfZdpSRN_K_QZWXRHk+jSeZ0e4-iBpoaf=hVJ8F_w@mail.gmail.com> <1401980832-4552-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1401980832-4552-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 08:07 AM, Prarit Bhargava wrote:
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
Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

> [v2]: text update
> ---
>   Documentation/cpu-freq/governors.txt    |    2 +-
>   Documentation/cpu-freq/intel-pstate.txt |    8 ++++++++
>   2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/cpu-freq/governors.txt b/Documentation/cpu-freq/governors.txt
> index 77ec215..c15aa75 100644
> --- a/Documentation/cpu-freq/governors.txt
> +++ b/Documentation/cpu-freq/governors.txt
> @@ -36,7 +36,7 @@ Contents:
>   1. What Is A CPUFreq Governor?
>   ==============================
>
> -Most cpufreq drivers (in fact, all except one, longrun) or even most
> +Most cpufreq drivers (except the intel_pstate and longrun) or even most
>   cpu frequency scaling algorithms only offer the CPU to be set to one
>   frequency. In order to offer dynamic frequency scaling, the cpufreq
>   core must be able to tell these drivers of a "target frequency". So
> diff --git a/Documentation/cpu-freq/intel-pstate.txt b/Documentation/cpu-freq/intel-pstate.txt
> index e742d21..2edd8d9 100644
> --- a/Documentation/cpu-freq/intel-pstate.txt
> +++ b/Documentation/cpu-freq/intel-pstate.txt
> @@ -9,6 +9,14 @@ assumed to implement internal governors by the cpufreq core. All the
>   logic for selecting the current P state is contained within the
>   driver; no external governor is used by the cpufreq core.
>
> +The Intel P-state driver has two internal governors, performance and
> +powersave.  These governors differ from the generally used governors of the
> +same name in the kernel.  The internal performance governor sets the
> +max_perf_pct and min_perf_pct to 100; that is, the governor selects the
> +highest available P state to maximize the performance of the core.  The
> +internal powersave governor, selects the appropriate P state based on the
> +current load on the CPU.
> +
>   Intel SandyBridge+ processors are supported.
>
>   New sysfs files for controlling P state selection have been added to
>

