Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab3LLMFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:05:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:41106 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415Ab3LLMFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:05:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,877,1378882800"; 
   d="scan'208";a="423529992"
Message-ID: <52A9A672.9050509@intel.com>
Date: Thu, 12 Dec 2013 14:05:06 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 07/71] perf tools: Record whether a dso is 64-bit
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-8-git-send-email-alexander.shishkin@linux.intel.com> <52A8BC5D.2030603@gmail.com>
In-Reply-To: <52A8BC5D.2030603@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13 21:26, David Ahern wrote:
> On 12/11/13, 5:36 AM, Alexander Shishkin wrote:
>> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
>> index a0c7c59..80817ec 100644
>> --- a/tools/perf/util/dso.c
>> +++ b/tools/perf/util/dso.c
>> @@ -446,6 +446,7 @@ struct dso *dso__new(const char *name)
>>           dso->cache = RB_ROOT;
>>           dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
>>           dso->data_type   = DSO_BINARY_TYPE__NOT_FOUND;
>> +        dso->is_64_bit = (sizeof(void *) == 8);
> 
> Isnt' that going to record the bitness of perf when it is compiled?
> 
>>           dso->loaded = 0;
>>           dso->rel = 0;
>>           dso->sorted_by_name = 0;
>> diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
>> index 384f2d9..62680e1 100644
>> --- a/tools/perf/util/dso.h
>> +++ b/tools/perf/util/dso.h
>> @@ -91,6 +91,7 @@ struct dso {
>>       u8         annotate_warned:1;
>>       u8         sname_alloc:1;
>>       u8         lname_alloc:1;
>> +    u8         is_64_bit:1;
> 
> The is_64_bit name seems a bit hardcoded. We need something similar for
> perf-trace to set the audit machine type for resolving syscalls. How about
> having this field set a machine type rather than a "64-bit" flag?

I am not sure what you mean by "machine type".  For itrace the
implementation only deals with its own architecture (e.g. the intel_pt
pmu is only on Intel architecture) so it is not necessary to record
the architecture.

is_64_bit corresponds to ELFCLASS64 (vs ELFCLASS32) which is needed
to determine whether the instruction set is 64-bit.  That should
work for other architectures too.

