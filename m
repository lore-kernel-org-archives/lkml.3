Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaGJTQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:16:32 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:34466 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaGJTQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:16:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140630144624.GA2604@quad>
References: <20140630144624.GA2604@quad>
Date: Thu, 10 Jul 2014 21:16:30 +0200
Message-ID: <CABPqkBRBF6TXf3Q5+MvWneKrgtrjZMv3FzW6rVMygz2QvWgowg@mail.gmail.com>
Subject: Re: [PATCH] perf/x86/uncore: fix SNB-EP/IVT Cbox filter mappings
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 4:46 PM, Stephane Eranian <eranian@google.com> wrote:
>
> This patch fixes the SNB-EP and IVT Cbox filter mapping
> table. The table controls which filters are supported by
> which events. There were several mistakes in those tables
> causing some filters to be ignored, such as NID on
> TOR_INSERTS.
>
> Signed-off-by: Stephane Eranian <eranian@google.com>

Any comment on this patch?

> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index 65bbbea..ae6552a 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -550,16 +550,16 @@ static struct extra_reg snbep_uncore_cbox_extra_regs[] = {
>         SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0x6),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x0135, 0xffff, 0x8),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x0335, 0xffff, 0x8),
> -       SNBEP_CBO_EVENT_EXTRA_REG(0x4135, 0xffff, 0xc),
> -       SNBEP_CBO_EVENT_EXTRA_REG(0x4335, 0xffff, 0xc),
> +       SNBEP_CBO_EVENT_EXTRA_REG(0x4135, 0xffff, 0xa),
> +       SNBEP_CBO_EVENT_EXTRA_REG(0x4335, 0xffff, 0xa),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x4435, 0xffff, 0x2),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x4835, 0xffff, 0x2),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x4a35, 0xffff, 0x2),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x5035, 0xffff, 0x2),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x0136, 0xffff, 0x8),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x0336, 0xffff, 0x8),
> -       SNBEP_CBO_EVENT_EXTRA_REG(0x4136, 0xffff, 0xc),
> -       SNBEP_CBO_EVENT_EXTRA_REG(0x4336, 0xffff, 0xc),
> +       SNBEP_CBO_EVENT_EXTRA_REG(0x4136, 0xffff, 0xa),
> +       SNBEP_CBO_EVENT_EXTRA_REG(0x4336, 0xffff, 0xa),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x4436, 0xffff, 0x2),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x4836, 0xffff, 0x2),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x4a36, 0xffff, 0x2),
> @@ -1222,6 +1222,7 @@ static struct extra_reg ivt_uncore_cbox_extra_regs[] = {
>         SNBEP_CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
>                                   SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x1031, 0x10ff, 0x2),
> +
>         SNBEP_CBO_EVENT_EXTRA_REG(0x1134, 0xffff, 0x4),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0xc),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x5134, 0xffff, 0xc),
> @@ -1245,7 +1246,7 @@ static struct extra_reg ivt_uncore_cbox_extra_regs[] = {
>         SNBEP_CBO_EVENT_EXTRA_REG(0x8335, 0xffff, 0x10),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x0136, 0xffff, 0x10),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x0336, 0xffff, 0x10),
> -       SNBEP_CBO_EVENT_EXTRA_REG(0x2336, 0xffff, 0x10),
> +       SNBEP_CBO_EVENT_EXTRA_REG(0x2136, 0xffff, 0x10),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x2336, 0xffff, 0x10),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x4136, 0xffff, 0x18),
>         SNBEP_CBO_EVENT_EXTRA_REG(0x4336, 0xffff, 0x18),
> --
> 1.8.3.2
>
