Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaLOJKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 04:10:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:38475 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaLOJKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 04:10:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="429019874"
Message-ID: <548EA52B.5060401@intel.com>
Date: Mon, 15 Dec 2014 11:08:59 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
        David Ahern <dsahern@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V3 00/22] perf tools: Introduce an abstraction for Instruction
 Tracing
References: <1418392089-5568-1-git-send-email-adrian.hunter@intel.com> <548B1425.7090500@gmail.com> <20141212185324.GF9845@kernel.org>
In-Reply-To: <20141212185324.GF9845@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/14 20:53, Arnaldo Carvalho de Melo wrote:
> Em Fri, Dec 12, 2014 at 09:13:25AM -0700, David Ahern escreveu:
>> On 12/12/14 6:47 AM, Adrian Hunter wrote:
>>> Here is V3 of some more preparatory patches for Intel PT
>>> that introduce an abstraction for Instruction tracing.
> 
>> This is an x86-Intel only feature correct? If that is the case then the code
>> should be not compiled for other architectures.

It is not that simple. In the case of recording, it is not needed for
architectures that don't support it, but in the case of session processing
any architecture can (or should be able to) process the perf.data file of
any other architecture.

I could add config options:

	NO_ITRACE_RECORD
	NO_ITRACE_PROCESS

And later:

	NO_INTEL_PT
	NO_INTEL_BTS

Arnaldo?

> 
> 
> My view so far is that what has been pushed for inclusion facilitates
> supporting an event stream that is so huge that needs to be mapped
> directly from hardware to tools, that would receive it in a special
> area obtained from perf_mmap(). What comes in those events? In this
> case, this Intel PT stuff, but noving (should) prevent it from being
> used for similar situations for other architectures.

That is true, although the only other potential user at the moment is ARM
ETM which is also tracing the instruction flow.

> 
> I wonder if we could somehow rename this from 'itrace' to some other
> more meaningful name given the above understanding of this being just
> a way to directly funnel events from hardware to userspace together with
> perf metadata (PERF_RECORD_FORK, PERF_RECORD_MMAP, etc) + other events.

It is hardware-generated architecture-specific large-volume trace data.

What about 'atrace' short for architecture-specific trace?

I don't think the name matters, so long as it is fairly unique.

> 
> In the kernel this was called a "AUX" thing, which I also think is
> vague...

I agree that AUX is too vague and also gets mixed up with lots of other
things called aux.
