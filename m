Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaLJMaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 07:30:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:26688 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaLJMaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:30:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,552,1413270000"; 
   d="scan'208";a="651532503"
Message-ID: <54883C75.2080409@intel.com>
Date: Wed, 10 Dec 2014 14:28:37 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 02/22] perf evlist: Add initial support for mmapping
 an Instruction Trace buffer
References: <1416489808-4489-1-git-send-email-adrian.hunter@intel.com> <1416489808-4489-3-git-send-email-adrian.hunter@intel.com> <20141125165752.GB563@krava.brq.redhat.com> <5475D174.50402@intel.com> <20141209132414.GD4189@kernel.org>
In-Reply-To: <20141209132414.GD4189@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/14 15:24, Arnaldo Carvalho de Melo wrote:
> Em Wed, Nov 26, 2014 at 03:11:16PM +0200, Adrian Hunter escreveu:
>> On 25/11/14 18:57, Jiri Olsa wrote:
>>> On Thu, Nov 20, 2014 at 03:23:08PM +0200, Adrian Hunter wrote:
>>>
>>> SNIP
>>>
>>>> +			bool per_cpu __maybe_unused)
>>>> +{
>>>> +}
>>>> +
>>>>  static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
>>>>  {
>>>>  	if (evlist->mmap[idx].base != NULL) {
>>>> @@ -731,6 +759,7 @@ static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
>>>>  		evlist->mmap[idx].base = NULL;
>>>>  		evlist->mmap[idx].refcnt = 0;
>>>>  	}
>>>> +	itrace_mmap__munmap(&evlist->mmap[idx].itrace_mmap);
>>>>  }
>>>>  
>>>>  void perf_evlist__munmap(struct perf_evlist *evlist)
>>>> @@ -758,6 +787,7 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
>>>>  struct mmap_params {
>>>>  	int prot;
>>>>  	int mask;
>>>> +	struct itrace_mmap_params itrace_mp;
>>>>  };
>>>>  
>>>>  static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
>>>> @@ -788,6 +818,10 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
>>>>  		return -1;
>>>>  	}
>>>>  
>>>> +	if (itrace_mmap__mmap(&evlist->mmap[idx].itrace_mmap,
>>>> +			      &mp->itrace_mp, evlist->mmap[idx].base, fd))
>>>> +		return -1;
>>>> +
>>>
>>> so the itrace mmap is mmaped with right after event mmap for event fd..?
>>
>> The AUX area support is not implemented yet.  The AUX mmap size and offset
>> are set through the mmap page via aux_offset and aux_size.
> 
>>From a quick look the user bits looks nicely done, step by step
> introducing stuff, but I would like to try it all together, where can I
> get the kernel bits so that I can try to find some machine where to test
> the whole thing?

Thanks for looking at the patches.

I am making a small change at the moment, so I will send a V3 and an
updated link to a git tree with all the patches - hopefully tomorrow.

> 
> - Arnaldo
>  
>>> is there any latest version of kernel changes, so I could check with
>>> kernel's perf_mmap? hum.. or you just use the same mmap?
>>
>> I re-based and pushed to:
>>
>> 	git://git.infradead.org/users/ahunter/linux-perf.git
>>
>> The missing AUX bits are added in this patch:
>>
>> 	http://git.infradead.org/users/ahunter/linux-perf.git/commitdiff/f1be40371b5600a5c4a20f88adff9595bdf5e7ec
> 
> 

