Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaA0Fp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 00:45:27 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:43631 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaA0Fp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 00:45:26 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-45-52e5f274d450
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
	<20140123145654.GE1180@krava.brq.redhat.com>
Date: Mon, 27 Jan 2014 14:45:24 +0900
In-Reply-To: <20140123145654.GE1180@krava.brq.redhat.com> (Jiri Olsa's message
	of "Thu, 23 Jan 2014 15:56:54 +0100")
Message-ID: <87ppne566j.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014 15:56:54 +0100, Jiri Olsa wrote:
> On Thu, Jan 23, 2014 at 09:13:45AM +0900, Namhyung Kim wrote:
>> There're some duplicate code when adding hist entries.  They are
>> different in that some have branch info or mem info but generally do
>> same thing.  So introduce new struct hist_entry_iter and add callbacks
>> to customize each case in general way.
>> 
>
> SNIP
>
>>  
>> -	if (sort__mode == SORT_MODE__BRANCH) {
>> -		ret = report__add_branch_hist_entry(tool, &al, sample, evsel);
>> -		if (ret < 0)
>> -			pr_debug("problem adding lbr entry, skipping event\n");
>> -	} else if (rep->mem_mode == 1) {
>> -		ret = report__add_mem_hist_entry(tool, &al, sample, evsel, event);
>> -		if (ret < 0)
>> -			pr_debug("problem adding mem entry, skipping event\n");
>> -	} else {
>> -		if (al.map != NULL)
>> -			al.map->dso->hit = 1;
>> -
>> -		ret = report__add_hist_entry(tool, evsel, &al, sample);
>> -		if (ret < 0)
>> -			pr_debug("problem incrementing symbol period, skipping event\n");
>> -	}
>> +	if (sort__mode == SORT_MODE__BRANCH)
>> +		iter.ops = &hist_iter_branch;
>> +	else if (rep->mem_mode == 1)
>
> nit.. mem_mode is bool

Ah, right!  As you can see the old code already did it. ;-p

Thanks,
Namhyung
