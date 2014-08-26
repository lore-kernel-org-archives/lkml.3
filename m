Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219AbaHZIbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:31:17 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37485 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744AbaHZIbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:31:13 -0400
Message-ID: <53FC45DB.5070006@arm.com>
Date: Tue, 26 Aug 2014 09:31:23 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "luca.abeni@unitn.it" <luca.abeni@unitn.it>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "henrik@austad.us" <henrik@austad.us>,
        "raistlin@linux.it" <raistlin@linux.it>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] Documentation/scheduler/sched-deadline.txt: Rewrite
 section 4 intro
References: <1408611700-9420-1-git-send-email-juri.lelli@arm.com> <1408611700-9420-3-git-send-email-juri.lelli@arm.com> <20140821134625.GB29495@gmail.com>
In-Reply-To: <20140821134625.GB29495@gmail.com>
X-OriginalArrivalTime: 26 Aug 2014 08:31:08.0460 (UTC) FILETIME=[15AD1EC0:01CFC108]
X-MC-Unique: 114082609311011301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/08/14 14:46, Ingo Molnar wrote:
> * Juri Lelli <juri.lelli@arm.com> wrote:
> 
>> Section 4 intro was still describing the old interface. Rewrite it.
>>
>> Signed-off-by: Juri Lelli <juri.lelli@arm.com>
>> Signed-off-by: Luca Abeni <luca.abeni@unitn.it>
>> Cc: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Henrik Austad <henrik@austad.us>
>> Cc: Dario Faggioli <raistlin@linux.it>
>> Cc: Juri Lelli <juri.lelli@gmail.com>
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  Documentation/scheduler/sched-deadline.txt | 49 +++++++++++++++---------------
>>  1 file changed, 24 insertions(+), 25 deletions(-)
>>
>> diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
>> index dce6d63..8372c3d 100644
>> --- a/Documentation/scheduler/sched-deadline.txt
>> +++ b/Documentation/scheduler/sched-deadline.txt
>> @@ -165,39 +165,38 @@ CONTENTS
>>  
>>   In order for the -deadline scheduling to be effective and useful, it is
>>   important to have some method to keep the allocation of the available CPU
>> - bandwidth to the tasks under control.
>> - This is usually called "admission control" and if it is not performed at all,
>> - no guarantee can be given on the actual scheduling of the -deadline tasks.
>> -
>> - Since when RT-throttling has been introduced each task group has a bandwidth
>> - associated, calculated as a certain amount of runtime over a period.
>> - Moreover, to make it possible to manipulate such bandwidth, readable/writable
>> - controls have been added to both procfs (for system wide settings) and cgroupfs
>> - (for per-group settings).
>> - Therefore, the same interface is being used for controlling the bandwidth
>> - distrubution to -deadline tasks.
>> -
>> - However, more discussion is needed in order to figure out how we want to manage
>> - SCHED_DEADLINE bandwidth at the task group level. Therefore, SCHED_DEADLINE
>> - uses (for now) a less sophisticated, but actually very sensible, mechanism to
>> - ensure that a certain utilization cap is not overcome per each root_domain.
>> -
>> - Another main difference between deadline bandwidth management and RT-throttling
>> + bandwidth to the tasks under control. This is usually called "admission
>> + control" and if it is not performed at all, no guarantee can be given on
>> + the actual scheduling of the -deadline tasks.
>> +
>> + The interface used to control the fraction of CPU bandwidth that can be
>> + allocated to -deadline tasks is similar to the one already used for -rt
>> + tasks with real-time group scheduling (a.k.a. RT-throttling - see
>> + Documentation/scheduler/sched-rt-group.txt), and is based on readable/
>> + writable control files located in procfs (for system wide settings).
>> + Notice that per-group settings (controlled through cgroupfs) are still not
>> + defined for -deadline tasks, because more discussion is needed in order to
>> + figure out how we want to manage SCHED_DEADLINE bandwidth at the task group
>> + level.
>> +
>> + A main difference between deadline bandwidth management and RT-throttling
>>   is that -deadline tasks have bandwidth on their own (while -rt ones don't!),
>>   and thus we don't need an higher level throttling mechanism to enforce the
> 
> s/an higher/a higher
> 
>> - desired bandwidth.
>> + desired bandwidth. Therefore, using this simple interface, we can put a cap
> 
> s/interface, we/interface we
> 
>> + on total utilization of -deadline tasks (i.e., \Sum (runtime_i / period_i) <
>> + some_desired_value).
>

Fixed.

Thanks a lot,

- Juri

