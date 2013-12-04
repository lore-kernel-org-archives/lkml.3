Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab3LDOCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:02:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:64312 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389Ab3LDOCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:02:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,824,1378882800"; 
   d="scan'208";a="444493629"
Message-ID: <529F37B0.6010209@intel.com>
Date: Wed, 04 Dec 2013 16:09:52 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/7] perf script: Do not call perf_event__preprocess_sample()
 twice)
References: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com> <1386055390-13757-2-git-send-email-adrian.hunter@intel.com> <20131203182305.GA2052@ghostprotocols.net>
In-Reply-To: <20131203182305.GA2052@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/13 20:23, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 03, 2013 at 09:23:04AM +0200, Adrian Hunter escreveu:
>> perf_event__preprocess_sample() is called in
>> process_sample_event().  Instead of calling it
>> again in perf_evsel__print_ip(), pass though
>> the resultant addr_location.
> 
> <SNIP>
>> +++ b/tools/perf/util/session.c
>> @@ -1487,11 +1487,12 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
>>  	return NULL;
>>  }
>>  
>> -void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
>> +void perf_evsel__print_ip(struct perf_evsel *evsel,
>> +			  union perf_event *event __maybe_unused,
> 
> Why do we have to keep this parameter?

You are right - it is not needed.

