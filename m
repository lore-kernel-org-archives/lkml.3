Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab3HMSTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:19:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab3HMSTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:19:12 -0400
Date: Tue, 13 Aug 2013 20:18:02 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V10 11/13] perf tools: expand
 perf_event__synthesize_sample()
Message-ID: <20130813181802.GA21321@krava.brq.redhat.com>
References: <1376045519-13832-1-git-send-email-adrian.hunter@intel.com>
 <1376045519-13832-12-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376045519-13832-12-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 01:51:57PM +0300, Adrian Hunter wrote:

SNIP

> +
> +	if (type & PERF_SAMPLE_BRANCH_STACK) {
> +		sz = sample->branch_stack->nr * sizeof(struct branch_entry);
> +		sz += sizeof(u64);
> +		memcpy(array, sample->branch_stack, sz);
> +		array = (void *)array + sz;
> +	}
> +
> +	if (type & PERF_SAMPLE_REGS_USER) {
> +		if (sample->user_regs.regs && sample_regs_user) {
> +			*array++ = sample_regs_user;

this one is still missing 'enum perf_sample_regs_abi' value

as used in perf_inject__sched_stat, we could parse it out in
perf_evsel__parse_sample into perf_sample::regs_dump::abi
and use the value in here

jirka
