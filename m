Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998Ab3GPWEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 18:04:08 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:57975 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933597Ab3GPWEG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 18:04:06 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-5d-51e5c354d9be
From: Shuah Khan <shuah.kh@samsung.com>
To: Joe Perches <joe@perches.com>
Cc: "len.brown@intel.com" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] power: new trace event to print device suspend and resume
 time
Thread-topic: [PATCH] power: new trace event to print device suspend and resume
 time
Thread-index: AQHOgmrHJCbzC2elLE64FOrYSy+QTQ==
Date: Tue, 16 Jul 2013 22:04:03 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6173C1B6@sisaex02sj>
References: <1374009806-11823-1-git-send-email-shuah.kh@samsung.com>
 <1374010741.1949.46.camel@joe-AO722>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t9hX92Qw08DDRZd47KY+bqbyaJ58Xo2
	i9n3H7NYzJqyl8ni8q45bBafe48wWlw6sIDJ4tre48wWd08dZbPoX9jLZLGv4wGTxdefDg48
	Hjtn3WX3aNl3i91j8Z6XTB77565h9/iy6hqzx/t9V9k8Hi1uYfRYsfo7u8fnTXIe67dsZQrg
	iuKySUnNySxLLdK3S+DKaNqxhrVgg2jF1K2rWBoYLwt2MXJySAiYSFz8v5kFwhaTuHBvPVsX
	IxeHkMAyRon2k3vAEkICvUwSG/dVQdjzGSWa1maB2GwC6hKfX+9g72Lk4BARUJS4u4UfJMws
	sIdFYurNMpCwsECoxKO3nBAVYRK9U3JBKkQE9CT+dzSygdgsAqoSHW8vMoHYvAL2Eu0TnjNB
	LMqWOHnuO9gBjECXfT+1hgliurhEc+tNqIsFJJbsOc8MYYtKvHz8jxVklQTQMdtXW0GUa0ms
	33kcqlVb4sm7C6wQqwQlfky+xzKBUWwWkqmzkLTMQtIyC0nLAkaWVYxipcXJBcVJ6akVhnrF
	ibnFpXnpesn5uZsYIZFetYPxzlebQ4wCHIxKPLwTwp4GCrEmlhVX5h5ilOBgVhLhFdoHFOJN
	SaysSi3Kjy8qzUktPsTIxMEp1cAYVtG2QufiuUj+6r0fTt00zPu+QM1zivlfq/XdQZM/p2h+
	MjhhJji3wLPT0v3hfsbsNRbHOU1zFSUWuyltFy95w1wY7fBsffvHmWKXa+TPJOhtEP/0Rfl2
	8YnXBXuaFjw+HlanXbjXt3vvtZfxi3ndo1cnH9BTbZjVcKnXNHpR6dl9RZP+/bygxFKckWio
	xVxUnAgAGgIUptICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 03:39 PM, Joe Perches wrote:
> On Tue, 2013-07-16 at 15:23 -0600, Shuah Khan wrote:
>> A new trace event is added to pm events to print time it takes to suspend and
>> resume a device. It generates trace message that includes device, driver,
>> parent information in addition to the type of pm ops invoked as well as the
>> pm event and error status from the pm ops. Example trace below:
>
>> diff --git a/include/trace/events/power.h b/include/trace/events/power.h
> []
>> @@ -66,6 +66,41 @@ TRACE_EVENT(machine_suspend,
>>   	TP_printk("state=%lu", (unsigned long)__entry->state)
>>   );
>>
>> +TRACE_EVENT(device_pm_report_time,
>> +
>> +	TP_PROTO(const char *device, const char *driver, const char *parent,
>> +		 const char *pm_ops, ktime_t ops_time, char *pm_event_str,
>> +		 int error),
>> +
>> +	TP_ARGS(device, driver, parent, pm_ops, ops_time, pm_event_str, error),
>> +
>> +	TP_STRUCT__entry(
>> +		__string(device, device)
>> +		__string(driver, driver)
>> +		__string(parent, parent)
>> +		__string(pm_ops, pm_ops)
>> +		__string(pm_event_str, pm_event_str)
>> +		__field(unsigned long long, ops_time)
>
> s64

Followed the ktime_t example in include/trace/events/timer.h - thinking 
it would be the correct way to cast ktime_t :)  I can change it to s64.


>
>> +		__field(int, error)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__assign_str(device, device);
>> +		__assign_str(driver, driver);
>> +		__assign_str(parent, parent);
>> +		__assign_str(pm_ops, pm_ops);
>> +		__assign_str(pm_event_str, pm_event_str);
>> +		__entry->ops_time = (unsigned long long)
>> +					ktime_to_ns(ops_time) >> 10;

Followed the ktime_t example in include/trace/events/timer.h - figured 
it would be the right one. I can change it.

>
> so no need for cast.
>
>> +		__entry->error = error;
>> +	),
>> +
>> +	TP_printk("%s driver(%s) parent(%s) %s %s (%llu usecs) err(%d)\n",
>
> %lld and no newline
>
>> +		__get_str(device), __get_str(driver), __get_str(parent),
>> +		__get_str(pm_event_str), __get_str(pm_ops),
>> +		__entry->ops_time, __entry->error)
>> +);
>> +
>>   DECLARE_EVENT_CLASS(wakeup_source,
>>
>>   	TP_PROTO(const char *name, unsigned int state),
>
>
>

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
