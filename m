Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbaJ2JEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:04:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468AbaJ2JEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:04:11 -0400
Date: Wed, 29 Oct 2014 10:03:40 +0100
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
Message-ID: <20141029090340.GE3538@krava.brq.redhat.com>
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

> +		while (i--) {
> +			if (ts->stack[i].ret_addr == ret_addr) {
> +				ts->cnt = i;
> +				return;
> +			}
> +		}
> +	}
> +}
> +
> +void thread_stack__event(struct thread *thread, u32 flags, u64 from_ip,
> +			 u64 to_ip, u16 insn_len, u64 trace_nr)
> +{
> +	if (!thread)
> +		return;
> +
> +	if (!thread->ts) {
> +		thread->ts = thread_stack__new();
> +		if (!thread->ts)
> +			return;

should the function return 'int' then..? So the allocation
error gets handled properly.

jirka
