Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab3CNHeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 03:34:24 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:41891 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3CNHeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 03:34:22 -0400
Date: Thu, 14 Mar 2013 08:34:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Vinson Lee <vlee@twitter.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v3] perf tools: Fix LIBNUMA build with glibc 2.12 and
 older.
Message-ID: <20130314073418.GA10245@gmail.com>
References: <20130311083652.GE12742@gmail.com>
 <1363214064-4671-1-git-send-email-vlee@twitter.com>
 <1363214064-4671-2-git-send-email-vlee@twitter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363214064-4671-2-git-send-email-vlee@twitter.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vinson Lee <vlee@twitter.com> wrote:

> The tokens MADV_HUGEPAGE and MADV_NOHUGEPAGE are not available with
> glibc 2.12 and older. Define these tokens if they are not already
> defined.
> 
> This patch fixes these build errors with older versions of glibc.
> 
>     CC bench/numa.o
> bench/numa.c: In function ???alloc_data???:
> bench/numa.c:334: error: ???MADV_HUGEPAGE??? undeclared (first use in this function)
> bench/numa.c:334: error: (Each undeclared identifier is reported only once
> bench/numa.c:334: error: for each function it appears in.)
> bench/numa.c:341: error: ???MADV_NOHUGEPAGE??? undeclared (first use in this function)
> make: *** [bench/numa.o] Error 1
> 
> Signed-off-by: Vinson Lee <vlee@twitter.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Irina Tirdea <irina.tirdea@intel.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  tools/perf/bench/bench.h |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
> index a5223e6..c132ee7 100644
> --- a/tools/perf/bench/bench.h
> +++ b/tools/perf/bench/bench.h
> @@ -1,6 +1,30 @@
>  #ifndef BENCH_H
>  #define BENCH_H
>  
> +/*
> + * The madvise transparent hugepage constants were added in glibc
> + * 2.13. For compatibility with older versions of glibc, define these
> + * tokens if they are not already defined.
> + *
> + * PA-RISC uses different madvise values from other architectures and
> + * needs to be special-cased.
> + */
> +#ifdef __hppa__
> +# ifndef MADV_HUGEPAGE
> +#  define MADV_HUGEPAGE		67
> +# endif
> +# ifndef MADV_NOHUGEPAGE
> +#  define MADV_NOHUGEPAGE	68
> +# endif
> +#else
> +# ifndef MADV_HUGEPAGE
> +#  define MADV_HUGEPAGE		14
> +# endif
> +# ifndef MADV_NOHUGEPAGE
> +#  define MADV_NOHUGEPAGE	15
> +# endif
> +#endif

Thanks!

Acked-by: Ingo Molnar <mingo@kernel.org>

Arnaldo, will you be picking this up for perf/urgent, or should I?

Thanks,

	Ingo
