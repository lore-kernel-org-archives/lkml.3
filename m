Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbaCEVYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:24:00 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:41141 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaCEVX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:23:59 -0500
MIME-Version: 1.0
In-Reply-To: <1394013516-4964-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1394013516-4964-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Date: Wed, 5 Mar 2014 22:23:58 +0100
Message-ID: <CABPqkBR567Gb53z==FTjcfC2mKK6cruTPURjNXM+3ZUwAv24rw@mail.gmail.com>
Subject: Re: [PATCH tip] perf/x86/uncore: Add __init for uncore_cpumask_init().
From: Stephane Eranian <eranian@google.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 10:58 AM, Dongsheng Yang
<yangds.fnst@cn.fujitsu.com> wrote:
> Commit 411cf180f introduce function uncore_cpumask_init() and it is only
> called in __init intel_uncore_init(). But it is not marked with __init,
> then the following warning is there when building.
>
I did not get this warning when building my kernels. But I agree
with the patch.

Acked-by: Stephane Eranian <eranian@google.com>

> WARNING: vmlinux.o(.text+0x2464a): Section mismatch in reference from the function uncore_cpumask_init() to the function .init.text:uncore_cpu_setup()
> The function uncore_cpumask_init() references
> the function __init uncore_cpu_setup().
> This is often because uncore_cpumask_init lacks a __init
> annotation or the annotation of uncore_cpu_setup is wrong.
>
> This patch add __init for uncore_cpumask_init() function.
>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> cc: Paul Mackerras <paulus@samba.org>
> cc: Ingo Molnar <mingo@redhat.com>
> cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> cc: Thomas Gleixner <tglx@linutronix.de>
> cc: "H. Peter Anvin" <hpa@zytor.com>
> cc: Stephane Eranian <eranian@google.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index b262c61..5c2537a 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -4229,7 +4229,7 @@ static int __init uncore_pmus_register(void)
>         return 0;
>  }
>
> -static void uncore_cpumask_init(void)
> +static void __init uncore_cpumask_init(void)
>  {
>         int cpu;
>
> --
> 1.8.2.1
>
