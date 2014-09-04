Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaIDKOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:14:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33393 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaIDKOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:14:50 -0400
Message-ID: <54083BA9.4030800@arm.com>
Date: Thu, 04 Sep 2014 11:15:05 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Henrik Austad <henrik@austad.us>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "luca.abeni@unitn.it" <luca.abeni@unitn.it>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "raistlin@linux.it" <raistlin@linux.it>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] Documentation/scheduler/sched-deadline.txt: add
 tests suite appendix
References: <1409220029-9002-1-git-send-email-juri.lelli@arm.com> <1409220029-9002-5-git-send-email-juri.lelli@arm.com> <20140902215332.GD22581@sisyphus.home.austad.us>
In-Reply-To: <20140902215332.GD22581@sisyphus.home.austad.us>
X-OriginalArrivalTime: 04 Sep 2014 10:14:44.0598 (UTC) FILETIME=[0C804160:01CFC829]
X-MC-Unique: 114090411144706101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On 02/09/14 22:53, Henrik Austad wrote:
> On Thu, Aug 28, 2014 at 11:00:29AM +0100, Juri Lelli wrote:
>> Add an appendix briefly describing tools that can be used to test SCHED_DEADLINE
>> (and the scheduler in general). Links to where source code of the tools is hosted
>> are also provided.
>>
>> Signed-off-by: Juri Lelli <juri.lelli@arm.com>
>> Cc: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Henrik Austad <henrik@austad.us>
>> Cc: Dario Faggioli <raistlin@linux.it>
>> Cc: Juri Lelli <juri.lelli@gmail.com>
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  Documentation/scheduler/sched-deadline.txt | 52 ++++++++++++++++++++++++++++++
>>  1 file changed, 52 insertions(+)
>>
>> diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
>> index 641395e..2f5b174 100644
>> --- a/Documentation/scheduler/sched-deadline.txt
>> +++ b/Documentation/scheduler/sched-deadline.txt
>> @@ -15,6 +15,7 @@ CONTENTS
>>   5. Tasks CPU affinity
>>     5.1 SCHED_DEADLINE and cpusets HOWTO
>>   6. Future plans
>> + A. Test suite
>>  
>>  
>>  0. WARNING
>> @@ -341,3 +342,54 @@ CONTENTS
>>   throttling patches [https://lkml.org/lkml/2010/2/23/239] but we still are in
>>   the preliminary phases of the merge and we really seek feedback that would
>>   help us decide on the direction it should take.
>> +
>> +Appendix A. Test suite
>> +======================
>> +
>> + The SCHED_DEADLINE policy can be easily tested using two applications that
>> + are part of a wider Linux Scheduler validation suite. The suite is
>> + available as a GitHub repository: https://github.com/scheduler-tools.
>> +
>> + The first testing application is called rt-app and can be used to
>> + start multiple threads with specific parameters. rt-app supports
>> + SCHED_{OTHER,FIFO,RR,DEADLINE} scheduling policies and their related
>> + parameters (e.g., niceness, priority, runtime/deadline/period). rt-app
>> + is a valuable tool, as it can be used to synthetically recreate certain
>> + workloads (maybe mimicking real use-cases) and evaluate how the scheduler
>> + behaves under such workloads. In this way, results are easily reproducible.
>> + rt-app is available at: https://github.com/scheduler-tools/rt-app.
>> +
>> + Thread parameters can be specified from the command line, with something like
>> + this:
>> +
>> +  # rt-app -t 100000:10000:d -t 150000:20000:f:10 -D5
>> +
>> + The above creates two threads. The first one, scheduled by SCHED_DEADLINE,
>> + executes for 10ms every 100ms and the second one, scheduled at RT priority 10
>> + with SCHED_FIFO, executes for 20ms every 150ms. The configuration runs
>> + for 5 seconds.
> 
> I'd prefer
> 
> The above creates 2 threads, T1 and T2. T1 is scheduled by SCHED_DEADLINE 
> with a 100ms period and 10ms WCET. T2 is handled by SCHED_FIFO priority 10, 
> 150ms period and 20ms WCET. The test will run for a total of 5 seconds.
> 
> One can expect the eager reader to have at least a grasp of the terminology 
> at this stage, using WCET should be acceptable.
> 

Not sure that naming the two threads T1 and T2 won't induce the reader to look
for such names in the system when the test is running. And the actual comms are
subject to change in future versions of rt-app. Also, giving the distinction
between tasks WCET (and BCET in this case) and the runtime you choose to
schedule them, I'd rather remain more general. So, what about this instead?

The above creates 2 threads. The first one, scheduled by SCHED_DEADLINE,
executes for 10ms every 100ms. The second one, scheduled at SCHED_FIFO
priority 10, executes for 20ms every 150ms. The test will run for a total
of 5 seconds.

>> +
>> + More interestingly, configurations can be described with a json file that
>> + can be passed as input to rt-app with something like this:
>> +
>> +  # rt-app my_config.json
>> +
>> + The parameters that can be specified with the second method are a superset
>> + of the command line options. Please refer to rt-app documentation for more
>> + details.
> 
> This can be found that this url: ....
> 

There is not a url yet (apart from the github repo). But, I can add:

(doc/*.json)

>> +
>> + The second testing application is a modification of schedtool, called
>> + schedtool-dl, which can be used to setup SCHED_DEADLINE parameters for a
>> + certain pid/application. schedtool-dl is available at:
>> + https://github.com/scheduler-tools/schedtool-dl.git.
>> +
>> + The usage is straightforward:
>> +
>> +  # schedtool -E -t 10000000:100000000 -e ./my_cpuhog_app
>> +
>> + With this, my_cpuhog_app is put to run inside a SCHED_DEADLINE reservation
>> + of 10ms every 100ms (note that parameters are expressed in microseconds).
>> + You can also use schedtool to create a reservation for an already running
>> + application, given that you know its pid:
>> +
>> +  # schedtool -E -t 10000000:100000000 my_app_pid
>> -- 
>> 2.0.4
> 
> Would it make sense to add an appendix B with a minimal SCHED_DEADLINE 
> main() ? I for one like to invent my own wheels.
> 

Ok, that could look like what follows (in a separate patch). What you
think?

Thanks,

- Juri

Appendix B. Minimal main()
==========================

We provide in what follows a simple (ugly) self-contained code snippet
showing how SCHED_DEADLINE reservations can be created by a real-time
application developer.

#define _GNU_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <linux/unistd.h>
#include <linux/kernel.h>
#include <linux/types.h>
#include <sys/syscall.h>
#include <pthread.h>

#define gettid() syscall(__NR_gettid)

#define SCHED_DEADLINE	6

/* XXX use the proper syscall numbers */
#ifdef __x86_64__
#define __NR_sched_setattr		314
#define __NR_sched_getattr		315
#endif

#ifdef __i386__
#define __NR_sched_setattr		351
#define __NR_sched_getattr		352
#endif

#ifdef __arm__
#define __NR_sched_setattr		380
#define __NR_sched_getattr		381
#endif

static volatile int done;

struct sched_attr {
	__u32 size;
	
	__u32 sched_policy;
	__u64 sched_flags;
	
	/* SCHED_NORMAL, SCHED_BATCH */
	__s32 sched_nice;
	
	/* SCHED_FIFO, SCHED_RR */
	__u32 sched_priority;
	
	/* SCHED_DEADLINE (nsec) */
	__u64 sched_runtime;
	__u64 sched_deadline;
	__u64 sched_period;
};

int sched_setattr(pid_t pid,
		  const struct sched_attr *attr,
		  unsigned int flags)
{
	return syscall(__NR_sched_setattr, pid, attr, flags);
}

int sched_getattr(pid_t pid,
		  struct sched_attr *attr,
		  unsigned int size,
		  unsigned int flags)
{
	return syscall(__NR_sched_getattr, pid, attr, size, flags);
}

void *run_deadline(void *data)
{
	struct sched_attr attr;
	int x = 0;
	int ret;
	unsigned int flags = 0;

	printf("deadline thread started [%ld]\n", gettid());

	attr.size = sizeof(attr);
	attr.sched_flags = 0;
	attr.sched_nice = 0;
	attr.sched_priority = 0;

	/* This creates a 10ms/30ms reservation */
	attr.sched_policy = SCHED_DEADLINE;
	attr.sched_runtime = 10 * 1000 * 1000;
	attr.sched_period = attr.sched_deadline = 30 * 1000 * 1000;

	ret = sched_setattr(0, &attr, flags);
	if (ret < 0) {
		done = 0;
		perror("sched_setattr");
		exit(-1);
	}

	while (!done) {
		x++;
	}

	printf("deadline thread dies [%ld]\n", gettid());
	return NULL;
}

int main (int argc, char **argv)
{
	pthread_t thread;

	printf("main thread [%ld]\n", gettid());

	pthread_create(&thread, NULL, run_deadline, NULL);

	sleep(10);

	done = 1;
	pthread_join(thread, NULL);

	printf("main dies [%ld]\n", gettid());
	return 0;
}

