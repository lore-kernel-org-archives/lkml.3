Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaENISh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 04:18:37 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:49303 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaENISd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 04:18:33 -0400
Message-ID: <537326D5.7040802@linux.vnet.ibm.com>
Date: Wed, 14 May 2014 10:18:29 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Yuan Pengfei <yuanpf12@sei.pku.edu.cn>,
        "'Andi Kleen'" <andi@firstfloor.org>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] gcov: add support for GCC 4.9
References: <001f01cf6f2c$d4e62350$7eb269f0$@sei.pku.edu.cn>
In-Reply-To: <001f01cf6f2c$d4e62350$7eb269f0$@sei.pku.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051408-5024-0000-0000-000009D26045
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.05.2014 06:27, Yuan Pengfei wrote:
> From: Yuan Pengfei <coolypf@qq.com>
> 
> This patch handles the gcov-related changes in GCC 4.9:
>   A new counter (time profile) is added. The total number is 9 now.
>   A new profile merge function __gcov_merge_time_profile is added.
> See gcc/gcov-io.h and libgcc/libgcov-merge.c
> For the first change, the layout of struct gcov_info is affected.
> For the second one, a dummy function is added to kernel/gcov/base.c similarly.
> Signed-off-by: Yuan Pengfei <coolypf@qq.com>

Looks good. Tested successfully on s390x with both GCC 4.9 and GCC 4.3.4.

Acked-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

> ---
>  kernel/gcov/base.c    | 6 ++++++
>  kernel/gcov/gcc_4_7.c | 5 +++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/kernel/gcov/base.c b/kernel/gcov/base.c
> index f45b75b..b358a80 100644
> --- a/kernel/gcov/base.c
> +++ b/kernel/gcov/base.c
> @@ -85,6 +85,12 @@ void __gcov_merge_ior(gcov_type *counters, unsigned int n_counters)
>  }
>  EXPORT_SYMBOL(__gcov_merge_ior);
> 
> +void __gcov_merge_time_profile(gcov_type *counters, unsigned int n_counters)
> +{
> +	/* Unused. */
> +}
> +EXPORT_SYMBOL(__gcov_merge_time_profile);
> +
>  /**
>   * gcov_enable_events - enable event reporting through gcov_event()
>   *
> diff --git a/kernel/gcov/gcc_4_7.c b/kernel/gcov/gcc_4_7.c
> index 7465944..7f74b59 100644
> --- a/kernel/gcov/gcc_4_7.c
> +++ b/kernel/gcov/gcc_4_7.c
> @@ -18,7 +18,12 @@
>  #include <linux/vmalloc.h>
>  #include "gcov.h"
> 
> +#if __GNUC__ == 4 && __GNUC_MINOR__ >= 9
> +#define GCOV_COUNTERS			9
> +#else
>  #define GCOV_COUNTERS			8
> +#endif
> +
>  #define GCOV_TAG_FUNCTION_LENGTH	3
> 
>  static struct gcov_info *gcov_info_head;
> 


-- 
Peter Oberparleiter
Linux on System z Development - IBM Germany

