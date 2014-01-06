Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaAFIS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:18:56 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47734 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaAFISz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:18:55 -0500
X-AuditID: 9c930179-b7c89ae000006438-10-52ca66ec0357
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 06/21] perf tools: Update cpumode for each cumulative entry
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
	<1387873347-28838-7-git-send-email-namhyung@kernel.org>
	<20140105170219.GF10018@krava.brq.redhat.com>
Date: Mon, 06 Jan 2014 17:18:52 +0900
In-Reply-To: <20140105170219.GF10018@krava.brq.redhat.com> (Jiri Olsa's
	message of "Sun, 5 Jan 2014 18:02:19 +0100")
Message-ID: <877gaded5f.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jan 2014 18:02:19 +0100, Jiri Olsa wrote:
> On Tue, Dec 24, 2013 at 05:22:12PM +0900, Namhyung Kim wrote:
[SNIP]

>> @@ -100,6 +100,7 @@ struct add_entry_iter {
>>  	struct report *rep;
>>  	struct perf_evsel *evsel;
>>  	struct perf_sample *sample;
>> +	struct machine *machine;
>>  	struct hist_entry *he;
>>  	struct symbol *parent;
>>  	void *priv;
>> @@ -362,7 +363,7 @@ iter_finish_normal_entry(struct add_entry_iter *iter, struct addr_location *al)
>>  
>>  static int
>>  iter_prepare_cumulative_entry(struct add_entry_iter *iter,
>> -			      struct machine *machine __maybe_unused,
>> +			      struct machine *machine,
>>  			      struct perf_evsel *evsel,
>>  			      struct addr_location *al __maybe_unused,
>>  			      struct perf_sample *sample)
>> @@ -371,6 +372,7 @@ iter_prepare_cumulative_entry(struct add_entry_iter *iter,
>>  
>>  	iter->evsel = evsel;
>>  	iter->sample = sample;
>> +	iter->machine = machine;
>
> machine is already in 'al->machine'

Okay, will remove ->machine in the iter.

Thanks,
Namhyung
