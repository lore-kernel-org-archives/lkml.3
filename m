Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab3D2J7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:59:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab3D2J7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:59:33 -0400
Date: Mon, 29 Apr 2013 11:59:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: powerpc: Fix compile errors in bp_signal files
Message-ID: <20130429095925.GA1106@krava.brq.redhat.com>
References: <20130426173320.GA7029@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426173320.GA7029@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 10:33:21AM -0700, Sukadev Bhattiprolu wrote:
> From 0e27e218def9ae630cc07efbd21664c150a3727a Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Fri, 26 Apr 2013 10:17:56 -0700
> Subject: [PATCH] perf: powerpc: Fix compile errors in bp_signal files
> 
> When building on powerpc,  we get compile errors in bp_signal.c and
> bp_signal_overflow.c due to __u64 and '%llx'.
> 
> Powerpc, needs __SANE_USERSPACE_TYPES__ to be defined so we pick up
> <asm-generic/int-ll64.h> and define __u64 as unsigned long long.

matches the use in tests/attr.c

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> ---
>  tools/perf/tests/bp_signal.c          |    6 ++++++
>  tools/perf/tests/bp_signal_overflow.c |    6 ++++++
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/tests/bp_signal.c b/tools/perf/tests/bp_signal.c
> index 68daa28..aba0954 100644
> --- a/tools/perf/tests/bp_signal.c
> +++ b/tools/perf/tests/bp_signal.c
> @@ -4,6 +4,12 @@
>   * (git://github.com/deater/perf_event_tests)
>   */
>  
> +/*
> + * Powerpc needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
> + * 'int-ll64.h' and avoid compile warnings when printing __u64 with %llu.
> + */
> +#define __SANE_USERSPACE_TYPES__
> +
>  #include <stdlib.h>
>  #include <stdio.h>
>  #include <unistd.h>
> diff --git a/tools/perf/tests/bp_signal_overflow.c b/tools/perf/tests/bp_signal_overflow.c
> index fe7ed28..44ac821 100644
> --- a/tools/perf/tests/bp_signal_overflow.c
> +++ b/tools/perf/tests/bp_signal_overflow.c
> @@ -3,6 +3,12 @@
>   * perf_event_tests (git://github.com/deater/perf_event_tests)
>   */
>  
> +/*
> + * Powerpc needs __SANE_USERSPACE_TYPES__ before <linux/types.h> to select
> + * 'int-ll64.h' and avoid compile warnings when printing __u64 with %llu.
> + */
> +#define __SANE_USERSPACE_TYPES__
> +
>  #include <stdlib.h>
>  #include <stdio.h>
>  #include <unistd.h>
> -- 
> 1.7.1
> 
