Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab3APJUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:20:19 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63786 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758657Ab3APJUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:20:16 -0500
X-AuditID: 9c930179-b7b54ae000000e44-7a-50f670cebdf6
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 05/13] perf hists: Resort hist entries using group members for output
References: <1358235117-12803-1-git-send-email-namhyung@kernel.org>
	<1358235117-12803-6-git-send-email-namhyung@kernel.org>
	<20130115182915.GA5826@ghostprotocols.net>
Date: Wed, 16 Jan 2013 18:20:14 +0900
In-Reply-To: <20130115182915.GA5826@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 15 Jan 2013 15:29:15 -0300")
Message-ID: <87mww9mqlt.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Tue, 15 Jan 2013 15:29:15 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jan 15, 2013 at 04:31:49PM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> When event group is enabled, sorting hist entries on periods for output
>> should consider groups members' period also.  To do that, build period
>> table using link/pair information and compare the table.
[snip]
>> +static int hist_entry__sort_on_period(struct hist_entry *a,
>> +				      struct hist_entry *b)
>> +{
>> +	int ret;
>> +	int i, nr_members;
>> +	struct perf_evsel *evsel;
>> +	struct hist_entry *pair;
>> +	u64 *periods_a, *periods_b;
>> +
>> +	ret = period_cmp(a->stat.period, b->stat.period);
>> +	if (ret || !symbol_conf.event_group)
>
> Why do we need to call period_cmp() when symbol_conf.event_group is
> false?
>
> I see, confusing neverthless :-\

In this function @a and @b are entries of group leaders and should be
compared first - other group members are compared only if periods of
leader entries are same.

For non-group events or when event group view is disabled, this function
will be called for every events as if they're leaders.


>
>> +		return ret;
>
> I would expect two functions, one for sorting on period and another for
> not sorting on period, i.e. don't call a function called
> 'sort_on_period' when _not_ sorting on period.

Sorry, I can't understand.

This 'sort_on_period' function is called during the (final) output
resorting and it's unconditional.  IOW hist entries should be sorted by
their period to be shown accordingly in the output.

Am I missing something?

Thanks,
Namhyung
