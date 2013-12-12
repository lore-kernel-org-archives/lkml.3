Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab3LLQpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:45:32 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:54809 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3LLQpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:45:31 -0500
Message-ID: <52A9E826.1020909@gmail.com>
Date: Thu, 12 Dec 2013 09:45:26 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 07/71] perf tools: Record whether a dso is 64-bit
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-8-git-send-email-alexander.shishkin@linux.intel.com> <52A8BC5D.2030603@gmail.com> <52A9A672.9050509@intel.com>
In-Reply-To: <52A9A672.9050509@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/13, 5:05 AM, Adrian Hunter wrote:

>>> diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
>>> index 384f2d9..62680e1 100644
>>> --- a/tools/perf/util/dso.h
>>> +++ b/tools/perf/util/dso.h
>>> @@ -91,6 +91,7 @@ struct dso {
>>>        u8         annotate_warned:1;
>>>        u8         sname_alloc:1;
>>>        u8         lname_alloc:1;
>>> +    u8         is_64_bit:1;
>>
>> The is_64_bit name seems a bit hardcoded. We need something similar for
>> perf-trace to set the audit machine type for resolving syscalls. How about
>> having this field set a machine type rather than a "64-bit" flag?
>
> I am not sure what you mean by "machine type".  For itrace the
> implementation only deals with its own architecture (e.g. the intel_pt
> pmu is only on Intel architecture) so it is not necessary to record
> the architecture.
>
> is_64_bit corresponds to ELFCLASS64 (vs ELFCLASS32) which is needed
> to determine whether the instruction set is 64-bit.  That should
> work for other architectures too.
>

perf-trace needs something similar -- an audit machine type to know how 
to convert syscall numbers to functions. One of the following per task:

typedef enum {
     MACH_X86=0,
     MACH_86_64,
     MACH_IA64,
     MACH_PPC64,
     MACH_PPC,
     MACH_S390X,
     MACH_S390,
     MACH_ALPHA,
     MACH_ARMEB
} machine_t;

I was pondering how the 2 can be combined into a common flag.

David
