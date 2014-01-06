Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaAFIKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:10:49 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59662 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaAFIKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:10:46 -0500
X-AuditID: 9c930197-b7c4aae000003d84-44-52ca6505e17c
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 03/21] perf hists: Add support for accumulated stat of hist entry
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
	<1387873347-28838-4-git-send-email-namhyung@kernel.org>
	<20140105164546.GD10018@krava.brq.redhat.com>
Date: Mon, 06 Jan 2014 17:10:45 +0900
In-Reply-To: <20140105164546.GD10018@krava.brq.redhat.com> (Jiri Olsa's
	message of "Sun, 5 Jan 2014 17:45:46 +0100")
Message-ID: <87fvp1ediy.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jan 2014 17:45:46 +0100, Jiri Olsa wrote:
> On Tue, Dec 24, 2013 at 05:22:09PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Maintain accumulated stat information in hist_entry->stat_acc if
>> symbol_conf.cumulate_callchain is set.  Fields in ->stat_acc have same
>> vaules initially, and will be updated as callchain is processed later.
>> 
>> Cc: Arun Sharma <asharma@fb.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/util/hist.c   | 18 ++++++++++++++++++
>>  tools/perf/util/sort.h   |  1 +
>>  tools/perf/util/symbol.h |  1 +
>>  3 files changed, 20 insertions(+)
>> 
>> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
>> index 283aa1972b4f..b61e2fa42412 100644
>> --- a/tools/perf/util/hist.c
>> +++ b/tools/perf/util/hist.c
>> @@ -237,6 +237,8 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
>>  		return true;
>>  
>>  	he_stat__decay(&he->stat);
>> +	if (symbol_conf.cumulate_callchain)
>> +		he_stat__decay(he->stat_acc);
>>  
>>  	if (!he->filtered)
>>  		hists->stats.total_period -= prev_period - he->stat.period;
>> @@ -284,6 +286,15 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
>
> there's callchain size computation in here:
>         size_t callchain_size = symbol_conf.use_callchain ?  sizeof(struct callchain_root) : 0;
>
> I wonder we could make it zero for symbol_conf.cumulate_callchain

The plan is to support callchain with --children enabled. :)

Thanks,
Namhyung
