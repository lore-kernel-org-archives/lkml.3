Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaKKN5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:57:52 -0500
Received: from mga14.intel.com ([192.55.52.115]:49256 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaKKN5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:57:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414819093"
Message-ID: <54621582.4060009@intel.com>
Date: Tue, 11 Nov 2014 15:56:18 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf tools: Fix annotation with kcore
References: <1415700294-30816-1-git-send-email-adrian.hunter@intel.com> <20141111130511.GU18464@kernel.org>
In-Reply-To: <20141111130511.GU18464@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/14 15:05, Arnaldo Carvalho de Melo wrote:
> Em Tue, Nov 11, 2014 at 12:04:54PM +0200, Adrian Hunter escreveu:
>> Patch "perf tools: Fix build-id matching on vmlinux"
> 
> So, I will check this, but please state for which branch this is
> supposed to be applied, i.e. does it fixes perf/urgent stuff and thus
> needs to go ASAP, or is this something that affects perf/core and thus
> can wait till I process more urgent stuff?

It is perf/core so it can wait.

> 
> - Arnaldo
> 
>> breaks annotation with kcore.  The problem is that
>> symbol__annotate() first gets the filename based on
>> the build-id which was previously not set.
>> This patch provides a quick fix, however there should
>> probably be only one way to determine the filename. e.g.
>> symbol__annotate() should use the same way as
>> dso__data_fd().
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/annotate.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
>> index 7dabde1..873c877 100644
>> --- a/tools/perf/util/annotate.c
>> +++ b/tools/perf/util/annotate.c
>> @@ -915,6 +915,8 @@ int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
>>  			return -ENOMEM;
>>  		}
>>  		goto fallback;
>> +	} else if (dso__is_kcore(dso)) {
>> +		goto fallback;
>>  	} else if (readlink(symfs_filename, command, sizeof(command)) < 0 ||
>>  		   strstr(command, "[kernel.kallsyms]") ||
>>  		   access(symfs_filename, R_OK)) {
>> -- 
>> 1.9.1
> 
> 

