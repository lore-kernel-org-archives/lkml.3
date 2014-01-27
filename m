Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaA0Flq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 00:41:46 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46139 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaA0Flp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 00:41:45 -0500
X-AuditID: 9c930197-b7b7cae000000e34-9b-52e5f197b585
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 01/21] perf tools: Introduce struct hist_entry_iter
References: <1390436045-16830-1-git-send-email-namhyung@kernel.org>
	<1390436045-16830-2-git-send-email-namhyung@kernel.org>
	<20140123144400.GD1180@krava.brq.redhat.com>
Date: Mon, 27 Jan 2014 14:41:43 +0900
In-Reply-To: <20140123144400.GD1180@krava.brq.redhat.com> (Jiri Olsa's message
	of "Thu, 23 Jan 2014 15:44:00 +0100")
Message-ID: <87txcq56co.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014 15:44:00 +0100, Jiri Olsa wrote:
> On Thu, Jan 23, 2014 at 09:13:45AM +0900, Namhyung Kim wrote:
>> There're some duplicate code when adding hist entries.  They are
>> different in that some have branch info or mem info but generally do
>> same thing.  So introduce new struct hist_entry_iter and add callbacks
>> to customize each case in general way.
>> 
>> The new perf_evsel__add_entry() function will look like:
>> 
>>   iter->prepare_entry();
>>   iter->add_single_entry();
>> 
>>   while (iter->next_entry())
>>     iter->add_next_entry();
>> 
>>   iter->finish_entry();
>> 
>> This will help further work like the cumulative callchain patchset.

[SNIP]
>> -	if (rep->hide_unresolved && !al->sym)
>> -		return 0;
>
> this check seems to be missing in iter_add_single_mem_entry

Right.  But afaics it's duplicate as we already check it in
process_sample_event().

Thanks,
Namhyung
