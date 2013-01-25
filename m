Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab3AYLIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:08:46 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:47568 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab3AYLIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:08:40 -0500
MIME-Version: 1.0
In-Reply-To: <1357847443-3878-4-git-send-email-jacob.shin@amd.com>
References: <1357847443-3878-1-git-send-email-jacob.shin@amd.com>
	<1357847443-3878-4-git-send-email-jacob.shin@amd.com>
Date: Fri, 25 Jan 2013 12:08:37 +0100
Message-ID: <CABPqkBR5baJ5rQoCiJwG7dZ6p_5BpDbtVqUAcB4A1PjtW+rr6w@mail.gmail.com>
Subject: Re: [PATCH RESEND V5 3/6] perf, amd: Use proper naming scheme for AMD
 bit field definitions
From: Stephane Eranian <eranian@google.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 8:50 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> Update these AMD bit field names to be consistent with naming
> convention followed by the rest of the file.
>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>

Acked-by: Stephane Eranian <eranian@google.com>

> ---
>  arch/x86/include/asm/perf_event.h    |    4 ++--
>  arch/x86/kernel/cpu/perf_event_amd.c |    8 ++++----
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 4fabcdf..2234eaaec 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -29,8 +29,8 @@
>  #define ARCH_PERFMON_EVENTSEL_INV                      (1ULL << 23)
>  #define ARCH_PERFMON_EVENTSEL_CMASK                    0xFF000000ULL
>
> -#define AMD_PERFMON_EVENTSEL_GUESTONLY                 (1ULL << 40)
> -#define AMD_PERFMON_EVENTSEL_HOSTONLY                  (1ULL << 41)
> +#define AMD64_EVENTSEL_GUESTONLY                       (1ULL << 40)
> +#define AMD64_EVENTSEL_HOSTONLY                                (1ULL << 41)
>
>  #define AMD64_EVENTSEL_EVENT   \
>         (ARCH_PERFMON_EVENTSEL_EVENT | (0x0FULL << 32))
> diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> index 9541fe5..0c2cc51 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> @@ -156,9 +156,9 @@ static int amd_pmu_hw_config(struct perf_event *event)
>                 event->hw.config &= ~(ARCH_PERFMON_EVENTSEL_USR |
>                                       ARCH_PERFMON_EVENTSEL_OS);
>         else if (event->attr.exclude_host)
> -               event->hw.config |= AMD_PERFMON_EVENTSEL_GUESTONLY;
> +               event->hw.config |= AMD64_EVENTSEL_GUESTONLY;
>         else if (event->attr.exclude_guest)
> -               event->hw.config |= AMD_PERFMON_EVENTSEL_HOSTONLY;
> +               event->hw.config |= AMD64_EVENTSEL_HOSTONLY;
>
>         if (event->attr.type != PERF_TYPE_RAW)
>                 return 0;
> @@ -336,7 +336,7 @@ static void amd_pmu_cpu_starting(int cpu)
>         struct amd_nb *nb;
>         int i, nb_id;
>
> -       cpuc->perf_ctr_virt_mask = AMD_PERFMON_EVENTSEL_HOSTONLY;
> +       cpuc->perf_ctr_virt_mask = AMD64_EVENTSEL_HOSTONLY;
>
>         if (boot_cpu_data.x86_max_cores < 2)
>                 return;
> @@ -669,7 +669,7 @@ void amd_pmu_disable_virt(void)
>          * SVM is disabled the Guest-only bits still gets set and the counter
>          * will not count anything.
>          */
> -       cpuc->perf_ctr_virt_mask = AMD_PERFMON_EVENTSEL_HOSTONLY;
> +       cpuc->perf_ctr_virt_mask = AMD64_EVENTSEL_HOSTONLY;
>
>         /* Reload all events */
>         x86_pmu_disable_all();
> --
> 1.7.9.5
>
>
