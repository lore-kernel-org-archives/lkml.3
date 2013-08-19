Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750904Ab3HSOY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 10:24:58 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:43585 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3HSOY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 10:24:56 -0400
MIME-Version: 1.0
In-Reply-To: <1374138144-17278-1-git-send-email-zheng.z.yan@intel.com>
References: <1374138144-17278-1-git-send-email-zheng.z.yan@intel.com>
Date: Mon, 19 Aug 2013 16:24:56 +0200
Message-ID: <CABPqkBRjJDOcFWOvZw6CTokrLbg5X=p8KCxZYQ47yRGYbdY_Pg@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf, x86: use INTEL_UEVENT_EXTRA_REG to define MSR_OFFCORE_RSP_X
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 11:02 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>
> Silvermont (22nm Atom) has two offcore response configuration MSRs,
> unlike other Intel CPU, its event code for MSR_OFFCORE_RSP_1 is 0x02b7.
> To avoid complicating intel_fixup_er(), use INTEL_UEVENT_EXTRA_REG to
> define MSR_OFFCORE_RSP_X. So intel_fixup_er() can find the event code
> for OFFCORE_RSP_N by x86_pmu.extra_regs[N].event.
>
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>

Works for me on IVB and NHM.

Reviewed-by: Stephane Eranian <eranian@google.com>

> ---
>  arch/x86/kernel/cpu/perf_event_intel.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index fbc9210..d312edf 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -81,7 +81,8 @@ static struct event_constraint intel_nehalem_event_constraints[] __read_mostly =
>
>  static struct extra_reg intel_nehalem_extra_regs[] __read_mostly =
>  {
> -       INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
> +       /* must define OFFCORE_RSP_X first, see intel_fixup_er() */
> +       INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
>         INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x100b),
>         EVENT_EXTRA_END
>  };
> @@ -143,8 +144,9 @@ static struct event_constraint intel_ivb_event_constraints[] __read_mostly =
>
>  static struct extra_reg intel_westmere_extra_regs[] __read_mostly =
>  {
> -       INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
> -       INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0xffff, RSP_1),
> +       /* must define OFFCORE_RSP_X first, see intel_fixup_er() */
> +       INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
> +       INTEL_UEVENT_EXTRA_REG(0x01bb, MSR_OFFCORE_RSP_1, 0xffff, RSP_1),
>         INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x100b),
>         EVENT_EXTRA_END
>  };
> @@ -163,15 +165,17 @@ static struct event_constraint intel_gen_event_constraints[] __read_mostly =
>  };
>
>  static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
> -       INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3f807f8fffull, RSP_0),
> -       INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3f807f8fffull, RSP_1),
> +       /* must define OFFCORE_RSP_X first, see intel_fixup_er() */
> +       INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x3f807f8fffull, RSP_0),
> +       INTEL_UEVENT_EXTRA_REG(0x01bb, MSR_OFFCORE_RSP_1, 0x3f807f8fffull, RSP_1),
>         INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
>         EVENT_EXTRA_END
>  };
>
>  static struct extra_reg intel_snbep_extra_regs[] __read_mostly = {
> -       INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffff8fffull, RSP_0),
> -       INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffff8fffull, RSP_1),
> +       /* must define OFFCORE_RSP_X first, see intel_fixup_er() */
> +       INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x3fffff8fffull, RSP_0),
> +       INTEL_UEVENT_EXTRA_REG(0x01bb, MSR_OFFCORE_RSP_1, 0x3fffff8fffull, RSP_1),
>         INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
>         EVENT_EXTRA_END
>  };
> @@ -1301,11 +1305,11 @@ static void intel_fixup_er(struct perf_event *event, int idx)
>
>         if (idx == EXTRA_REG_RSP_0) {
>                 event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
> -               event->hw.config |= 0x01b7;
> +               event->hw.config |= x86_pmu.extra_regs[EXTRA_REG_RSP_0].event;
>                 event->hw.extra_reg.reg = MSR_OFFCORE_RSP_0;
>         } else if (idx == EXTRA_REG_RSP_1) {
>                 event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
> -               event->hw.config |= 0x01bb;
> +               event->hw.config |= x86_pmu.extra_regs[EXTRA_REG_RSP_1].event;
>                 event->hw.extra_reg.reg = MSR_OFFCORE_RSP_1;
>         }
>  }
> --
> 1.8.1.4
>
