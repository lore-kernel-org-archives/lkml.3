Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbaJ2JIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:08:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbaJ2JIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:08:20 -0400
Date: Wed, 29 Oct 2014 10:07:32 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/16] perf tools: Add a thread stack for synthesizing
 call chains
Message-ID: <20141029090732.GF3538@krava.brq.redhat.com>
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
 <1414061124-26830-5-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414061124-26830-5-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 01:45:12PM +0300, Adrian Hunter wrote:

SNIP

>  };
>  
> +enum {
> +	PERF_FLAG_BRANCH		= 1ULL << 0,
> +	PERF_FLAG_CALL			= 1ULL << 1,
> +	PERF_FLAG_RETURN		= 1ULL << 2,
> +	PERF_FLAG_CONDITIONAL		= 1ULL << 3,
> +	PERF_FLAG_SYSCALLRET		= 1ULL << 4,
> +	PERF_FLAG_ASYNC			= 1ULL << 5,
> +	PERF_FLAG_INTERRUPT		= 1ULL << 6,
> +	PERF_FLAG_TX_ABORT		= 1ULL << 7,
> +	PERF_FLAG_TRACE_BEGIN		= 1ULL << 8,
> +	PERF_FLAG_TRACE_END		= 1ULL << 9,
> +	PERF_FLAG_IN_TX			= 1ULL << 10,
> +};
> +
> +#define PERF_BRANCH_MASK	(\
> +	PERF_FLAG_BRANCH	|\
> +	PERF_FLAG_CALL		|\
> +	PERF_FLAG_RETURN	|\
> +	PERF_FLAG_CONDITIONAL	|\
> +	PERF_FLAG_SYSCALLRET	|\
> +	PERF_FLAG_ASYNC		|\
> +	PERF_FLAG_INTERRUPT	|\
> +	PERF_FLAG_TX_ABORT	|\
> +	PERF_FLAG_TRACE_BEGIN	|\
> +	PERF_FLAG_TRACE_END)

PERF_FLAG_ prefix seems too generic,

should it be something like PERF_BRANCH_FLAG__* ?


jirka
