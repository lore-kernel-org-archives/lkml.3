Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab3KEHQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 02:16:45 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:59769 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab3KEHQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 02:16:42 -0500
X-AuditID: 9c93017e-b7c22ae000005611-98-52789b58faad
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 02/14] perf tools: Introduce struct add_entry_iter
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
	<1383202576-28141-3-git-send-email-namhyung@kernel.org>
	<20131101120909.GC10041@krava.brq.redhat.com>
Date: Tue, 05 Nov 2013 16:16:40 +0900
In-Reply-To: <20131101120909.GC10041@krava.brq.redhat.com> (Jiri Olsa's
	message of "Fri, 1 Nov 2013 13:09:09 +0100")
Message-ID: <87k3gnz5bb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Nov 2013 13:09:09 +0100, Jiri Olsa wrote:
> On Thu, Oct 31, 2013 at 03:56:04PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>
> SNIP
>
>> +}
>> +
>> +static int
>> +iter_add_next_nop_entry(struct add_entry_iter *iter __maybe_unused,
>> +			struct addr_location *al __maybe_unused)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int
>> +iter_prepare_mem_entry(struct add_entry_iter *iter, struct machine *machine,
>> +		       struct perf_evsel *evsel, struct addr_location *al,
>> +		       struct perf_sample *sample)
>> +{
>> +	union perf_event *event = iter->priv;
>> +	struct mem_info *mi;
>> +	u8 cpumode;
>> +
>> +	BUG_ON(event == NULL);
>
> the priv does not get assigned.. 'perf mem rep' aborts
>
> [jolsa@krava perf]$ ./perf mem rep --stdio
> Aborted
> perf: builtin-report.c:120: iter_prepare_mem_entry: Assertion `!(event == ((void *)0))' failed.

Argh... forgot to set it for mem entries after code refactoring,
sorry. :-/  Will fix in v3.

Thanks,
Namhyung
