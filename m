Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaBXGl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 01:41:29 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61564 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaBXGl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 01:41:28 -0500
X-AuditID: 9c93016f-b7c65ae000004a2a-78-530ae9973138
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6/8] perf tools: Add hist.percentage config option
In-Reply-To: <20140220110112.GF11018@krava.brq.redhat.com> (Jiri Olsa's
	message of "Thu, 20 Feb 2014 12:01:12 +0100")
References: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
	<1392000446-14744-7-git-send-email-namhyung@kernel.org>
	<20140220110112.GF11018@krava.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Mon, 24 Feb 2014 15:41:26 +0900
Message-ID: <87d2idvwq1.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014 12:01:12 +0100, Jiri Olsa wrote:
> On Mon, Feb 10, 2014 at 11:47:23AM +0900, Namhyung Kim wrote:
>> Add hist.percentage option for setting default value of the
>> symbol_conf.filter_relative.  It affects the output of various perf
>> commands (like perf report, top and diff) only if filter(s) applied.
>> 
>> An user can write .perfconfig file like below to show absolute
>> percentage of filtered entries by default:
>
> SNIP
>
>> +++ b/tools/perf/util/hist.c
>> @@ -934,3 +934,17 @@ int hists__link(struct hists *leader, struct hists *other)
>>  
>>  	return 0;
>>  }
>> +
>> +int perf_hist_config(const char *var, const char *value)
>> +{
>> +	if (!strcmp(var, "hist.percentage")) {
>> +		if (!strcmp(value, "relative"))
>> +			symbol_conf.filter_relative = true;
>> +		else if (!strcmp(value, "absolute"))
>> +			symbol_conf.filter_relative = false;
>> +		else
>> +			return -1;
>> +	}
>> +
>> +	return 0;
>> +}
>
> the inner stuff could be done in parse_percentage function
> not to duplicate the symbol_conf.filter_relative assignment

Will do!

Thanks,
Namhyung
