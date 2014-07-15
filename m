Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbaGOR6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:58:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:11316 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523AbaGOR6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:58:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,667,1400050800"; 
   d="scan'208";a="573565978"
Message-ID: <53C56BB0.7000805@intel.com>
Date: Tue, 15 Jul 2014 20:58:08 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 24/41] perf tools: Add cpu to struct thread
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com> <1405332185-4050-25-git-send-email-adrian.hunter@intel.com> <20140715142421.GD3301@kernel.org>
In-Reply-To: <20140715142421.GD3301@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/2014 5:24 p.m., Arnaldo Carvalho de Melo wrote:
> Em Mon, Jul 14, 2014 at 01:02:48PM +0300, Adrian Hunter escreveu:
>> Tools may wish to track on which cpu a thread
>> is running.  Add 'cpu' to struct thread for
>> that purpose.
>>
>> This will be used to determine the cpu when
>> decoding a per-thread Instruction Trace.
>
> Humm, is this the last cpu we got some event telling the cpu was running
> on? Continuing looking at the patches...

Yes.  Intel PT decoding uses sched_switch events to determine which
task is running on which cpu.  The Intel PT data comes straight
from the hardware which doesn't know about linux threads.

>
> - Arnaldo
>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>   tools/perf/util/thread.c | 1 +
>>   tools/perf/util/thread.h | 1 +
>>   2 files changed, 2 insertions(+)
>>
>> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
>> index b9a3ee4..2f8c0c1 100644
>> --- a/tools/perf/util/thread.c
>> +++ b/tools/perf/util/thread.c
>> @@ -69,6 +69,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
>>   		thread->pid_ = pid;
>>   		thread->tid = tid;
>>   		thread->ppid = -1;
>> +		thread->cpu = -1;
>>   		INIT_LIST_HEAD(&thread->comm_list);
>>
>>   		comm_str = malloc(32);
>> diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
>> index b4269af..e4920ff 100644
>> --- a/tools/perf/util/thread.h
>> +++ b/tools/perf/util/thread.h
>> @@ -17,6 +17,7 @@ struct thread {
>>   	pid_t			pid_; /* Not all tools update this */
>>   	pid_t			tid;
>>   	pid_t			ppid;
>> +	int			cpu;
>>   	char			shortname[3];
>>   	bool			comm_set;
>>   	bool			dead; /* if set thread has exited */
>> --
>> 1.8.3.2
