Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3KEHJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 02:09:58 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53116 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab3KEHJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 02:09:57 -0500
X-AuditID: 9c930197-b7b60ae000006860-7d-527899c4a6a1
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
	<20131101120735.GB10041@krava.brq.redhat.com>
Date: Tue, 05 Nov 2013 16:09:56 +0900
In-Reply-To: <20131101120735.GB10041@krava.brq.redhat.com> (Jiri Olsa's
	message of "Fri, 1 Nov 2013 13:07:35 +0100")
Message-ID: <87ob5zz5mj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, 1 Nov 2013 13:07:35 +0100, Jiri Olsa wrote:
> On Thu, Oct 31, 2013 at 03:56:04PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>
> SNIP
>
>> +
>> +static int
>> +perf_evsel__add_entry(struct perf_evsel *evsel, struct addr_location *al,
>> +		      struct perf_sample *sample, struct machine *machine,
>> +		      struct add_entry_iter *iter)
>> +{
>> +	int err;
>> +
>> +	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
>> +		err = machine__resolve_callchain(machine, evsel, al->thread,
>> +						 sample, &iter->parent, al,
>> +						 iter->rep->max_stack);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>> +	err = iter->prepare_entry(iter, machine, evsel, al, sample);
>> +	if (err)
>> +		return err;
>> +
>> +	err = iter->add_single_entry(iter, al);
>> +	if (err)
>> +		return err;
>> +
>> +	while (iter->next_entry(iter, al)) {
>> +		err = iter->add_next_entry(iter, al);
>> +		if (err)
>> +			break;
>> +	}
>> +
>> +	err = iter->finish_entry(iter, al);
>> +
>> +	return err;
>
> 	return iter->finish_entry(iter, al);  ?

Right.  Will fix in v3.

Thanks,
Namhyung
