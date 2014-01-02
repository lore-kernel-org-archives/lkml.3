Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbaABILF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 03:11:05 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:55352 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaABILD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 03:11:03 -0500
MIME-Version: 1.0
In-Reply-To: <2681fd21a9ee014ffe77c0ec7304157be7209b6f.1388649430.git.baruch@tkos.co.il>
References: <2681fd21a9ee014ffe77c0ec7304157be7209b6f.1388649430.git.baruch@tkos.co.il>
Date: Thu, 2 Jan 2014 12:11:02 +0400
Message-ID: <CAMo8BfLokJ7uBi=G=pVCK+-FwVANa2nJiE+pBnPzv2APxYUpkw@mail.gmail.com>
Subject: Re: [Linux-Xtensa] [PATCH v2] perf: add support for the xtensa architecture
From: Max Filippov <jcmvbkbc@gmail.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 2, 2014 at 11:57 AM, Baruch Siach <baruch@tkos.co.il> wrote:
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
> v2: use the "core ID" field from /proc/cpuinfo (Max Filippov)
> ---
>  tools/perf/perf.h | 7 +++++++
>  1 file changed, 7 insertions(+)

Acked-by: Max Filippov <jcmvbkbc@gmail.com>

> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index b079304bd53d..e441864dbe03 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -132,6 +132,13 @@
>  #define CPUINFO_PROC   "CPU"
>  #endif
>
> +#ifdef __xtensa__
> +#define mb()           asm volatile("memw" ::: "memory")
> +#define wmb()          asm volatile("memw" ::: "memory")
> +#define rmb()          asm volatile("" ::: "memory")
> +#define CPUINFO_PROC   "core ID"
> +#endif
> +
>  #define barrier() asm volatile ("" ::: "memory")
>
>  #ifndef cpu_relax
> --
> 1.8.5.2

-- 
Thanks.
-- Max
