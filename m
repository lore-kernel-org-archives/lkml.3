Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab3KAMJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 08:09:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab3KAMJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 08:09:25 -0400
Date: Fri, 1 Nov 2013 13:09:09 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 02/14] perf tools: Introduce struct add_entry_iter
Message-ID: <20131101120909.GC10041@krava.brq.redhat.com>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
 <1383202576-28141-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383202576-28141-3-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 03:56:04PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>

SNIP

> +}
> +
> +static int
> +iter_add_next_nop_entry(struct add_entry_iter *iter __maybe_unused,
> +			struct addr_location *al __maybe_unused)
> +{
> +	return 0;
> +}
> +
> +static int
> +iter_prepare_mem_entry(struct add_entry_iter *iter, struct machine *machine,
> +		       struct perf_evsel *evsel, struct addr_location *al,
> +		       struct perf_sample *sample)
> +{
> +	union perf_event *event = iter->priv;
> +	struct mem_info *mi;
> +	u8 cpumode;
> +
> +	BUG_ON(event == NULL);

the priv does not get assigned.. 'perf mem rep' aborts

[jolsa@krava perf]$ ./perf mem rep --stdio
Aborted
perf: builtin-report.c:120: iter_prepare_mem_entry: Assertion `!(event == ((void *)0))' failed.

jirka
