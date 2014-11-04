Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaKDIjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:39:23 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50032 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaKDIjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:39:19 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/3] perf tools: Add test_and_set_bit function
References: <1414363445-22370-1-git-send-email-jolsa@kernel.org>
Date: Tue, 04 Nov 2014 17:39:14 +0900
In-Reply-To: <1414363445-22370-1-git-send-email-jolsa@kernel.org> (Jiri Olsa's
	message of "Sun, 26 Oct 2014 23:44:03 +0100")
Message-ID: <87d2935php.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sun, 26 Oct 2014 23:44:03 +0100, Jiri Olsa wrote:
> Set a bit and return its old value. Stolen from kernel
> sources, will be used in next patches.
>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

For all 3 patches,

Acked-by: Namhyung Kim <namhyung@gmail.com>

Thanks,
Namhyung


> ---
>  tools/perf/util/include/linux/bitmap.h | 17 +++++++++++++++++
>  tools/perf/util/include/linux/bitops.h |  2 ++
>  2 files changed, 19 insertions(+)
>
> diff --git a/tools/perf/util/include/linux/bitmap.h b/tools/perf/util/include/linux/bitmap.h
> index 01ffd12dc791..40bd21488032 100644
> --- a/tools/perf/util/include/linux/bitmap.h
> +++ b/tools/perf/util/include/linux/bitmap.h
> @@ -46,4 +46,21 @@ static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
>  		__bitmap_or(dst, src1, src2, nbits);
>  }
>  
> +/**
> + * test_and_set_bit - Set a bit and return its old value
> + * @nr: Bit to set
> + * @addr: Address to count from
> + */
> +static inline int test_and_set_bit(int nr, unsigned long *addr)
> +{
> +	unsigned long mask = BIT_MASK(nr);
> +	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
> +	unsigned long old;
> +
> +	old = *p;
> +	*p = old | mask;
> +
> +	return (old & mask) != 0;
> +}
> +
>  #endif /* _PERF_BITOPS_H */
> diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
> index dadfa7e54287..c3294163de17 100644
> --- a/tools/perf/util/include/linux/bitops.h
> +++ b/tools/perf/util/include/linux/bitops.h
> @@ -15,6 +15,8 @@
>  #define BITS_TO_U64(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
>  #define BITS_TO_U32(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
>  #define BITS_TO_BYTES(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE)
> +#define BIT_WORD(nr)            ((nr) / BITS_PER_LONG)
> +#define BIT_MASK(nr)            (1UL << ((nr) % BITS_PER_LONG))
>  
>  #define for_each_set_bit(bit, addr, size) \
>  	for ((bit) = find_first_bit((addr), (size));		\
