Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbaEGMGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:06:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181AbaEGMGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:06:33 -0400
Date: Wed, 7 May 2014 14:05:21 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, will.deacon@arm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 2/3] perf tests: Add dwarf unwind test on ARM64
Message-ID: <20140507120521.GB2019@krava.brq.redhat.com>
References: <1399391733-11927-1-git-send-email-jean.pihet@linaro.org>
 <1399391733-11927-3-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399391733-11927-3-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 05:55:32PM +0200, Jean Pihet wrote:

SNIP

> +#include "tests/tests.h"
> +
> +#define STACK_SIZE 8192
> +
> +static int sample_ustack(struct perf_sample *sample,
> +			 struct thread *thread, u64 *regs)
> +{
> +	struct stack_dump *stack = &sample->user_stack;
> +	struct map *map;
> +	unsigned long sp;
> +	u64 stack_size, *buf;
> +
> +	buf = malloc(STACK_SIZE);
> +	if (!buf) {
> +		pr_debug("failed to allocate sample uregs data\n");
> +		return -1;
> +	}
> +
> +	sp = (unsigned long) regs[PERF_REG_ARM64_SP];
> +
> +	map = map_groups__find(&thread->mg, MAP__FUNCTION, (u64) sp);
> +	if (!map) {
> +		pr_debug("failed to get stack map\n");
> +		return -1;
> +	}

there's a memory leak of 'buf' already fixed fox x86:

  perf tests x86: Fix memory leak in sample_ustack()
  commit 763d7f5f2718f085bab5a9e63308349728f3ad12
  Author: Masanari Iida <standby24x7@gmail.com>
  Date:   Sun Apr 20 00:16:41 2014 +0900

jirka
