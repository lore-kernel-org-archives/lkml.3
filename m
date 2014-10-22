Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbaJVTH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:07:59 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:42604 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaJVTH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:07:58 -0400
MIME-Version: 1.0
In-Reply-To: <1409872109-31645-2-git-send-email-andi@firstfloor.org>
References: <1409872109-31645-1-git-send-email-andi@firstfloor.org>
	<1409872109-31645-2-git-send-email-andi@firstfloor.org>
Date: Wed, 22 Oct 2014 12:07:56 -0700
Message-ID: <CAADnVQKWgm9smg5vtfFwt53RiNYidgV9kiq3C0B0Xekx0cUJJg@mail.gmail.com>
Subject: Re: [PATCH 2/5] perf, x86, uncore: Add Haswell-EP uncore support
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, eranian@google.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 4:08 PM, Andi Kleen <andi@firstfloor.org> wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>
> The uncore subsystem in Haswell-EP is similar to Sandy/Ivy
> Bridge-EP. There are some differences in config register
> encoding and pci device IDs. The Haswell-EP uncore also
> supports a few new events. Add the Haswell-EP driver to
> the snbep split driver.
>
> v2: (AK): Add missing break. Add imc events. Add cbox nc/isoc/c6.
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c      |   7 +-
>  arch/x86/kernel/cpu/perf_event_intel_uncore.h      |   2 +
>  .../x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 608 ++++++++++++++++++++-
>  3 files changed, 615 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index 812ec5d..2b0fa02 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -883,6 +883,9 @@ static int __init uncore_pci_init(void)
>         case 62: /* Ivy Bridge-EP */
>                 ret = ivbep_uncore_pci_init();
>                 break;
> +       case 63: /* Haswell-EP */
> +               ret = hswep_uncore_pci_init();
> +               break;

my E5-1630 v3 crashes hard during boot in
snbep_uncore_msr_init_box()+0x3c
I don't have a setup to capture the screen so early in the boot.
So this is just heads up.
I replaced the call above with 'return -ENODEV' as a workaround.
btw, E5-16xx v3 became available just a month ago.
