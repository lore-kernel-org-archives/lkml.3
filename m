Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaBXGhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 01:37:53 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55960 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaBXGhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 01:37:52 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-45-530ae8beb74f
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 4/8] perf top: Add --percentage option
References: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
	<1392000446-14744-5-git-send-email-namhyung@kernel.org>
	<20140220104440.GB11018@krava.brq.redhat.com>
Date: Mon, 24 Feb 2014 15:37:49 +0900
In-Reply-To: <20140220104440.GB11018@krava.brq.redhat.com> (Jiri Olsa's
	message of "Thu, 20 Feb 2014 11:44:40 +0100")
Message-ID: <87ios5vww2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014 11:44:40 +0100, Jiri Olsa wrote:
> On Mon, Feb 10, 2014 at 11:47:21AM +0900, Namhyung Kim wrote:
>> The --percentage option is for controlling overhead percentage
>> displayed.  It can only receive either of "relative" or "absolute".
>> 
>> For more information, please see previous commit same thing done to
>> "perf report".
>> 
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>
> SNIP
>
>>  
>> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
>> index ed99ec4a309f..a516e0389c5e 100644
>> --- a/tools/perf/builtin-top.c
>> +++ b/tools/perf/builtin-top.c
>> @@ -1011,6 +1011,20 @@ parse_percent_limit(const struct option *opt, const char *arg,
>>  	return 0;
>>  }
>>  
>> +static int
>> +parse_percentage(const struct option *opt __maybe_unused, const char *arg,
>> +		 int unset __maybe_unused)
>> +{
>> +	if (!strcmp(arg, "relative"))
>> +		symbol_conf.filter_relative = true;
>> +	else if (!strcmp(arg, "absolute"))
>> +		symbol_conf.filter_relative = false;
>> +	else
>> +		return -1;
>> +
>> +	return 0;
>> +}
>
> please make one of parse_percentage functions public and
> share it among report/top/diff commands

Okay.

Thanks,
Namhyung
