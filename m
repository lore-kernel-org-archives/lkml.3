Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbaGVNZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:25:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:36040 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868AbaGVNZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:25:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="565444780"
Message-ID: <53CE65F3.9050004@intel.com>
Date: Tue, 22 Jul 2014 16:24:03 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] perf tools: Record whether a dso has data
References: <1405586590-13657-3-git-send-email-adrian.hunter@intel.com> <1405587510-15037-1-git-send-email-adrian.hunter@intel.com> <20140722075515.GB29305@krava.redhat.com>
In-Reply-To: <20140722075515.GB29305@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 10:55 AM, Jiri Olsa wrote:
> On Thu, Jul 17, 2014 at 11:58:30AM +0300, Adrian Hunter wrote:
>> Add 'data_status' to record whether a dso has data
>> (i.e. an object file)
> 
> I might have seen it in your last patsent, but forgot.. what is
> this data_status going to be used for?

I have changed it a bit in the latest posting.  It was originally
for two purposes:
	1. to prevent repeatedly attempting to open a file that
was not there (very time consuming if you do it millions of times)
	2. to report the error exactly once

But I realized it did not meet the 2nd objective so I have added
another patch that does.  See "perf tools: Add dso__data_status_seen()"

> 
> SNIP
> 
>> diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
>> index c239e86..07d0a58 100644
>> --- a/tools/perf/util/dso.h
>> +++ b/tools/perf/util/dso.h
>> @@ -40,6 +40,12 @@ enum dso_swap_type {
>>  	DSO_SWAP__YES,
>>  };
>>  
>> +enum dso_data_status {
>> +	DSO_DATA_STATUS_ERROR	= -1,
>> +	DSO_DATA_STATUS_UNKNOWN	= 0,
>> +	DSO_DATA_STATUS_OK	= 1,
>> +};
>> +
>>  #define DSO__SWAP(dso, type, val)			\
>>  ({							\
>>  	type ____r = val;				\
>> @@ -104,6 +110,7 @@ struct dso {
>>  	struct {
>>  		struct rb_root	 cache;
>>  		int		 fd;
>> +		int		 data_status;
> 
> also please call it just 'status' it's already in 'data' struct

I made that change too.


