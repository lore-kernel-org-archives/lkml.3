Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbaJXFlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 01:41:07 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:59665 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaJXFlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 01:41:05 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/16] perf tools: Add a thread stack for synthesizing call chains
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
	<1414061124-26830-5-git-send-email-adrian.hunter@intel.com>
Date: Fri, 24 Oct 2014 14:41:02 +0900
In-Reply-To: <1414061124-26830-5-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Thu, 23 Oct 2014 13:45:12 +0300")
Message-ID: <87ppdic9e9.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014 13:45:12 +0300, Adrian Hunter wrote:
> +static void thread_stack__pop(struct thread_stack *ts, u64 ret_addr)
> +{
> +	if (!ts->cnt)
> +		return;
> +
> +	if (ts->stack[ts->cnt - 1].ret_addr == ret_addr) {
> +		ts->cnt -= 1;
> +	} else {
> +		size_t i = ts->cnt - 1;
> +
> +		while (i--) {
> +			if (ts->stack[i].ret_addr == ret_addr) {
> +				ts->cnt = i;
> +				return;
> +			}
> +		}
> +	}
> +}

Why not making it a single loop like:

	int i;

	for (i = ts->cnt - 1; i >= 0; i--) {
		if (ts->stack[i].ret_addr == ret_addr) {
			ts->cnt = i;
			return;
		}
        }

Thanks,
Namhyung
