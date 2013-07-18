Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab3GRUbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:31:17 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:38965 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab3GRUbP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 16:31:15 -0400
X-AuditID: cbfec37b-b7f306d0000047de-0d-51e850919215
From: Shuah Khan <shuah.kh@samsung.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "len.brown@intel.com" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "joe@perches.com" <joe@perches.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v4] power: new trace event to print device suspend and
 resume time
Thread-topic: [PATCH v4] power: new trace event to print device suspend and
 resume time
Thread-index: AQHOg+xp1u4nsGnKf0ua7hSrlbncAQ==
Date: Thu, 18 Jul 2013 20:31:11 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6173DB58@sisaex02sj>
References: <1374175349-3435-1-git-send-email-shuah.kh@samsung.com>
 <1374176956.6458.265.camel@gandalf.local.home>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t9hP92JAS8CDVYuMLGY+bqbyaJ58Xo2
	i9n3H7NYzJqyl8ni8q45bBafe48wWlw6sIDJ4tre48wWd08dZbPoX9jLZLGv4wGTxdefDg48
	Hjtn3WX3aNl3i91j8Z6XTB77565h9/iy6hqzx/t9V9k8Hi1uYfRYsfo7u8fnTXIe67dsZQrg
	iuKySUnNySxLLdK3S+DKmHj5BHvBIYuKma0d7A2MP3S6GDk4JARMJFoWcHcxcgKZYhIX7q1n
	62Lk4hASWMYocXD5c2YIp5dJ4u+FB6wQznxGic72dewgLWwC6hKfX+8As0UENIAmPWcBKWIW
	2MIicWfaHEaQhLBAhMTmPyeZQNaJCERKPN2uAlGvJ3FzBcQcFgFVibM3XjOB2LwC9hIX97aA
	2UICJRITl29jBrEZgc77fmoNWJxZQFyiufUmC8TZAhJL9pxnhrBFJV4+/scK8ZmixPbVVhDl
	WhLrdx6HatWWePLuAivEKkGJH5PvsUxgFJuFZOosJC2zkLTMQtKygJFlFaNYaXFyQXFSemqF
	kV5xYm5xaV66XnJ+7iZGSMRX72C8+9XmEKMAB6MSD++DL88DhVgTy4orcw8xSnAwK4nwrv0J
	FOJNSaysSi3Kjy8qzUktPsTIxMEp1cAom3AnVDO59bPn3b8frAXbnWcENIoJzXnJ1B3td8zn
	3OpT/vbPPvw4brShv9ib3ya67FJr14XDPlL6/1/9fqIYbX20SO/poxOJVh5HBE7NDXv4ZMrJ
	Q5GBt/fMNHedaJITc9buy8tVlqERS3eu3/C62KOp2/B2tEmQE0/XW4edzBXSLKcUNxkrsRRn
	JBpqMRcVJwIAiS+z+dYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 01:49 PM, Steven Rostedt wrote:
> On Thu, 2013-07-18 at 13:22 -0600, Shuah Khan wrote:
>> A new trace event is added to pm events to print time it takes to suspend and
>> resume a device. It generates trace message that includes device, driver,
>> parent information in addition to the type of pm ops invoked as well as the
>> pm event and error status from the pm ops. Example trace below:
>>
>> bash-2239  [000] ....   290.883035: device_pm_report_time: backlight
>>   acpi_video0 parent=0000:00:02.0 state=freeze ops=class nsecs=332 err=0
>> bash-2239  [000] ....   290.883041: device_pm_report_time: rfkill rf
>> kill3 parent=phy0 state=freeze ops=legacy class nsecs=216 err=0
>> bash-2239  [001] ....   290.973892: device_pm_report_time: ieee80211
>>   phy0 parent=0000:01:00.0 state=freeze ops=legacy class nsecs=90846477 err=0
>>
>> bash-2239  [001] ....   293.660129: device_pm_report_time: ieee80211 phy0 parent=0000:01:00.0 state=restore ops=legacy class nsecs=101295162 err=0
>> bash-2239  [001] ....   293.660147: device_pm_report_time: rfkill rfkill3 parent=phy0 state=restore ops=legacy class nsecs=1804 err=0
>> bash-2239  [001] ....   293.660157: device_pm_report_time: backlight acpi_video0 parent=0000:00:02.0 state=restore ops=class nsecs=757 err=0
>>
>
> I think I'm the thorn in your side.

No worries. I do want to do this right. Since I plan to add a few more 
trace-points, it will be worth your while teaching me :) Thanks for this 
detailed email.

>
>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>> ---
>>   drivers/base/power/main.c    |   33 +++++++++++++++++++++++----------
>>   include/trace/events/power.h |   35 +++++++++++++++++++++++++++++++++++
>>   2 files changed, 58 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
>> index 5a9b656..e7401c6 100644
>> --- a/drivers/base/power/main.c
>> +++ b/drivers/base/power/main.c
>> @@ -28,6 +28,7 @@
>>   #include <linux/sched.h>
>>   #include <linux/async.h>
>>   #include <linux/suspend.h>
>> +#include <trace/events/power.h>
>>   #include <linux/cpuidle.h>
>>   #include "../base.h"
>>   #include "power.h"
>> @@ -56,6 +57,8 @@ static pm_message_t pm_transition;
>>
>>   static int async_error;
>>
>> +static char *pm_verb(int);
>> +
>>   /**
>>    * device_pm_sleep_init - Initialize system suspend-related device fields.
>>    * @dev: Device object being initialized.
>> @@ -172,16 +175,23 @@ static ktime_t initcall_debug_start(struct device *dev)
>>   }
>>
>>   static void initcall_debug_report(struct device *dev, ktime_t calltime,
>> -				  int error)
>> +				  int error, pm_message_t state, char *info)
>>   {
>> -	ktime_t delta, rettime;
>> +	ktime_t rettime;
>> +	s64 nsecs;
>> +
>> +	rettime = ktime_get();
>> +	nsecs = (s64) ktime_to_ns(ktime_sub(rettime, calltime));
>
> You still are calling this from the fast path. Why not put the
> conversion into TP_printk()? Or is this just called once in a while and
> you don't really care?

If enabled, this code will execute several times in suspend and resume 
path. So it does make perfect sense to optimize it.

>
>>
>>   	if (pm_print_times_enabled) {
>> -		rettime = ktime_get();
>> -		delta = ktime_sub(rettime, calltime);
>>   		pr_info("call %s+ returned %d after %Ld usecs\n", dev_name(dev),
>> -			error, (unsigned long long)ktime_to_ns(delta) >> 10);
>> +			error, (unsigned long long)nsecs >> 10);
>>   	}
>> +
>> +	trace_device_pm_report_time(dev_name(dev), dev_driver_string(dev),
>> +				dev->parent ? dev_name(dev->parent) : "none",
>> +				info ? info : "none ",
>> +				nsecs, pm_verb(state.event), error);
>
> I'd like to see this disassembled.
>
> The tracepoints use jump-labels which is basically a code modification
> of a branch.
>
>
>     [ code ]
>     nop
> back:
>     [ code ]
>     return;
>
> tracepoint:
>     [ tracepoint code ]
>     jmp back;
>
>
> And when we enable the tracepoint, the code is modified to be:
>
>    [ code ]
>    jmp tracepoint
>    [ code ]
>
> tracepoint:
>    [ tracepoint code ]
>    jmp back;
>
> Cool, eh?
>
> But we sometimes have seen gcc getting confused it its optimization, and
> process some of the work of the tracepoint parameters in the [ code ]
> part, which is bad, because that's just overhead even when the
> tracepoint is disabled.
>
> Thus, it's usually better to do as much work in the TRACE_EVENT() macro
> as possible. In otherwords:
>
> 	trace_device_pm_report_time(dev, info, nsecs,
> 		 pm_verb(state.event), error);
>
> And in the TP_fast_assign, have:
>
> 	TP_fast_assign(
> 		char *tmp_dev = dev->parent ? dev_name(dev->parent) : "none";
> 		char *tmp_info = info ? info : "none ";
>
> 		__assign_str(tmp_dev, parent);
> 		__assign_str(tmp_info, info);
> 		[...]
>

The very first version I started testing was in fact passing in struct 
device *dev and do all calculations in the trace-point code itself:


       TP_STRUCT__entry(
                 __string(driver_name, dev_driver_string(dev))
                 __string(device_name, dev_name(dev))
                 __string(parent, dev->parent ? dev_name(dev->parent) : 
"none")
                 __string(pm_ops, pm_ops)
                 __field(unsigned long long, ops_time)
                 __field(int, event)
                 __field(int, error)
         ),


       TP_fast_assign(
                 __assign_str(driver_name, dev_driver_string(dev));
                 __assign_str(device_name, dev_name(dev));
                 __assign_str(parent, dev->parent ? 
dev_name(dev->parent) : "none");
                 __assign_str(pm_ops, pm_ops);


What I was missing was the tmp_dev, tmp_info in my TP_fast_assign and 
started seeing hangs. Of course, now it all makes sense.

I decided to simplify the logic in trace-point code, and pass in the 
strings instead. It does become hard to figure out compilation errors in 
this framework.

I am glad you took the time to explain. :) I have this older version 
saved and I am going to back to it and get it to work and move all the 
work into the TP code.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
