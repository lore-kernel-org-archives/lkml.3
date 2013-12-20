Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab3LTBcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 20:32:42 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:63535 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3LTBcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 20:32:41 -0500
X-AuditID: 9c930197-b7cefae000007949-5e-52b39e37ee59
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/6] perf report: Use pr_*() functions if possible
References: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
	<1387436411-20160-2-git-send-email-namhyung@kernel.org>
	<20131219133047.GK4819@ghostprotocols.net>
Date: Fri, 20 Dec 2013 10:32:39 +0900
In-Reply-To: <20131219133047.GK4819@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Thu, 19 Dec 2013 10:30:47 -0300")
Message-ID: <87iouke288.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013 10:30:47 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Dec 19, 2013 at 04:00:06PM +0900, Namhyung Kim escreveu:
>> -	if (verbose > 3)
>> -		perf_session__fprintf(session, stdout);
>> +	if (use_browser == 0) {
>> +		if (verbose > 3)
>> +			perf_session__fprintf(session, stdout);
>>  
>> -	if (verbose > 2)
>> -		perf_session__fprintf_dsos(session, stdout);
>> +		if (verbose > 2)
>> +			perf_session__fprintf_dsos(session, stdout);
>>  
>> -	if (dump_trace) {
>> -		perf_session__fprintf_nr_events(session, stdout);
>> -		return 0;
>> +		if (dump_trace) {
>> +			perf_session__fprintf_nr_events(session, stdout);
>> +			return 0;
>> +		}
>>  	}
>
> This should be in a different patch, one that is related just to
> dump_trace, i.e. if -D, aka dump_trace (right?) is enabled, then
> probably we won't be initializing the TUI/GUI, no?

Yes, the dump_trace will make use_browser = 0.  So I just moved it under
the if (use_browser == 0).

>
> So having a patch that deals just with conversions of fprintf ->
> pr_{err,etc} and another that deals with dump_trace related seems to be
> the best course of action.

Okay, I'll split this into two.

Thanks,
Namhyung
