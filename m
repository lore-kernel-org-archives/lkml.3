Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab3LLOO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:14:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:50627 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab3LLOO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:14:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,878,1378882800"; 
   d="scan'208";a="448957185"
Message-ID: <52A9C4BF.4050206@intel.com>
Date: Thu, 12 Dec 2013 16:14:23 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 14/71] perf tools: Add cpu to struct thread
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-15-git-send-email-alexander.shishkin@linux.intel.com> <20131211141908.GC1458@ghostprotocols.net>
In-Reply-To: <20131211141908.GC1458@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13 16:19, Arnaldo Carvalho de Melo wrote:
> Em Wed, Dec 11, 2013 at 02:36:26PM +0200, Alexander Shishkin escreveu:
>> From: Adrian Hunter <adrian.hunter@intel.com>
>>
>> Tools may wish to track on which cpu a thread
>> is running.  Add 'cpu' to struct thread for
>> that purpose.  Also add machine functions to
>> get / set the cpu for a tid.
>>
>> This will be used to determine the cpu when
>> decoding a per-thread Instruction Trace.
>>
>>
>> +++ b/tools/perf/util/machine.c
>> @@ -1412,3 +1412,29 @@ pid_t machine__get_thread_pid(struct machine *machine, pid_t tid)
>>  
>>  	return thread->pid_;
>>  }
>> +
>> +int machine__get_thread_cpu(struct machine *machine, pid_t tid, pid_t *pid)
>> +{
>> +	struct thread *thread = machine__find_thread(machine, tid);
>> +
>> +	if (!thread)
>> +		return -1;
>> +
>> +	if (pid)
>> +		*pid = thread->pid_;
>> +
>> +	return thread->cpu;
>> +}
> 
> What is the problem with:
> 
> 	struct thread *thread = machine__find_thread(machine, tid);
> 	pid_t pid = thread->pid_;
> 	int cpu = thread->cpu;
> 
> In your case you'll have:
> 
> 	int pid;
> 	int cpu = machine__get_thread_cpu(machine, tid, &pid);
> 
> Which is slightly more compact, but then we end up with a function that
> from its name should just get a 'cpu' but also asks for the pid.
> 
> I think it is better to just use what we have (machine__find_thread),
> have a 'thread' variable and then use any of its members, directly.

OK



