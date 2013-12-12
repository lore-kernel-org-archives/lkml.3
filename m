Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab3LLMIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:08:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:54633 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab3LLMIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:08:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,877,1378882800"; 
   d="scan'208";a="423531006"
Message-ID: <52A9A71C.50004@intel.com>
Date: Thu, 12 Dec 2013 14:07:56 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: David Ahern <dsahern@gmail.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 07/71] perf tools: Record whether a dso is 64-bit
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-8-git-send-email-alexander.shishkin@linux.intel.com> <52A8BC5D.2030603@gmail.com> <20131211195419.GF1458@ghostprotocols.net>
In-Reply-To: <20131211195419.GF1458@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13 21:54, Arnaldo Carvalho de Melo wrote:
> Em Wed, Dec 11, 2013 at 12:26:21PM -0700, David Ahern escreveu:
>> On 12/11/13, 5:36 AM, Alexander Shishkin wrote:
>>> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
>>> index a0c7c59..80817ec 100644
>>> --- a/tools/perf/util/dso.c
>>> +++ b/tools/perf/util/dso.c
>>> @@ -446,6 +446,7 @@ struct dso *dso__new(const char *name)
>>>  		dso->cache = RB_ROOT;
>>>  		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
>>>  		dso->data_type   = DSO_BINARY_TYPE__NOT_FOUND;
>>> +		dso->is_64_bit = (sizeof(void *) == 8);
>>
>> Isnt' that going to record the bitness of perf when it is compiled?
> 
> Right, it will. Its just a default, I assume this will be reset after
> the DSO is loaded, i.e. the ELF file gets accessed, no?

Yes

> 
> Which then would make this init to be just a distraction, no?

Yes

> 
> I wonder if we couldn't extern PERF_RECORD_MMAP to have the binary type
> encoded there somehow...
> 
>>>  		dso->loaded = 0;
>>>  		dso->rel = 0;
>>>  		dso->sorted_by_name = 0;
>>> diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
>>> index 384f2d9..62680e1 100644
>>> --- a/tools/perf/util/dso.h
>>> +++ b/tools/perf/util/dso.h
>>> @@ -91,6 +91,7 @@ struct dso {
>>>  	u8		 annotate_warned:1;
>>>  	u8		 sname_alloc:1;
>>>  	u8		 lname_alloc:1;
>>> +	u8		 is_64_bit:1;
>>
>> The is_64_bit name seems a bit hardcoded. We need something similar
>> for perf-trace to set the audit machine type for resolving syscalls.
>> How about having this field set a machine type rather than a
>> "64-bit" flag?
>>
>> David
> 
> 

