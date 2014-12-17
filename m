Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaLQNl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 08:41:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaLQNl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 08:41:58 -0500
Date: Wed, 17 Dec 2014 14:41:16 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 10/18] tools lib: Move asm-generic/bitops/find.h code to
 tools/include and tools/lib
Message-ID: <20141217134116.GD18257@krava.brq.redhat.com>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
 <1418749040-31807-11-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418749040-31807-11-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 01:57:12PM -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> To match the Linux kernel source code structure from where this code came from.

SNIP

> +			goto found;
> +		result += BITS_PER_LONG;
> +		size -= BITS_PER_LONG;
> +	}
> +	if (!size)
> +		return result;
> +
> +	tmp = (*p) & (~0UL >> (BITS_PER_LONG - size));
> +	if (tmp == 0UL)		/* Are any bits set? */
> +		return result + size;	/* Nope. */
> +found:
> +	return result + __ffs(tmp);
> +}
> +#endif
> diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
> index 67d48e20f7e1..bfd7e22bafad 100644
> --- a/tools/perf/MANIFEST
> +++ b/tools/perf/MANIFEST
> @@ -4,8 +4,10 @@ tools/lib/traceevent
>  tools/lib/api
>  tools/lib/symbol/kallsyms.c
>  tools/lib/symbol/kallsyms.h
> +tools/lib/util/find_next_bit.c

hum, I had the impression that we will move 'generic' things under 'api' to
be built separatelly.. so whats the current notion? ;-)

what kind of code belongs to 'lib/api/...' and what to 'lib/...' ?

thanks,
jirka
