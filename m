Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966209Ab3HIJxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:53:55 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:53972 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965382Ab3HIJxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:53:54 -0400
MIME-Version: 1.0
In-Reply-To: <1375856245-10717-3-git-send-email-zheng.z.yan@intel.com>
References: <1375856245-10717-1-git-send-email-zheng.z.yan@intel.com>
	<1375856245-10717-3-git-send-email-zheng.z.yan@intel.com>
Date: Fri, 9 Aug 2013 11:53:53 +0200
Message-ID: <CABPqkBRsKQLDjH_mynbeOQyX+_QEbuiPKF_Jv5tebqmYL090ig@mail.gmail.com>
Subject: Re: [PATCH 3/3] perf, uncore: enable ev_sel_ext bit for PCU.
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 8:17 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>
> PCU uncore event control register has a undocumented ev_sel_ext bit.
> The bit is needed by Andi's pmu-tools.
>
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>


Works for me. Is also needed by libpfm4 uncore PCU events.
Now results make more sense. Please apply.

Reviewed-by: Stephane Eranian <eranian@google.com>


>
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
