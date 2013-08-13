Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab3HMMTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:19:39 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63983 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632Ab3HMMTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:19:38 -0400
MIME-Version: 1.0
In-Reply-To: <1376375382-21350-4-git-send-email-zheng.z.yan@intel.com>
References: <1376375382-21350-1-git-send-email-zheng.z.yan@intel.com>
	<1376375382-21350-4-git-send-email-zheng.z.yan@intel.com>
Date: Tue, 13 Aug 2013 14:19:37 +0200
Message-ID: <CABPqkBSATdJL8UFfnR89rvB=Tw8PCAf-8xJV1R+Wf0W-JN3HWg@mail.gmail.com>
Subject: Re: [PATCH 3/3] perf, uncore: enable ev_sel_ext bit for PCU.
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 8:29 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>
> This patch adds support for the SNB-EP PCU uncore PMU extra_sel_bit
> (bit 21) which is missing from the documentation in Table-2.75 of
> Intel Xeon Processor E5-2600 Product Family Uncore Performance
> Monitoring Guide. It is referred to later in Table-2.81. Without
> this selection bit explicitly enabled by the kernel, some events
> such as COREx_TRANSITION_CYCLES do not count correctly.
>
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>

Reviewed-by: Stephane Eranian <eranian@google.com>

> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
>  arch/x86/kernel/cpu/perf_event_intel_uncore.h | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index 6b8b9c9..e9696d8 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -301,7 +301,7 @@ static struct attribute *snbep_uncore_cbox_formats_attr[] = {
>  };
>
>  static struct attribute *snbep_uncore_pcu_formats_attr[] = {
> -       &format_attr_event.attr,
> +       &format_attr_event_ext.attr,
>         &format_attr_occ_sel.attr,
>         &format_attr_edge.attr,
>         &format_attr_inv.attr,
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> index 628500e..a80ab71 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> @@ -117,6 +117,7 @@
>                                 (SNBEP_PMON_CTL_EV_SEL_MASK | \
>                                  SNBEP_PCU_MSR_PMON_CTL_OCC_SEL_MASK | \
>                                  SNBEP_PMON_CTL_EDGE_DET | \
> +                                SNBEP_PMON_CTL_EV_SEL_EXT | \
>                                  SNBEP_PMON_CTL_INVERT | \
>                                  SNBEP_PCU_MSR_PMON_CTL_TRESH_MASK | \
>                                  SNBEP_PCU_MSR_PMON_CTL_OCC_INVERT | \
> --
> 1.8.1.4
>
