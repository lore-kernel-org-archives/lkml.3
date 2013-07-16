Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776Ab3GPW1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 18:27:14 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:24609 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab3GPW1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 18:27:12 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-eb-51e5c8be427a
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
Date: Tue, 16 Jul 2013 22:27:08 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6173C248@sisaex02sj>
References: <1374009806-11823-1-git-send-email-shuah.kh@samsung.com>
 <1374010741.1949.46.camel@joe-AO722>
 <B8EFE96D1287C24090BAD9D858E15E6173C1B6@sisaex02sj>
 <1374013019.1949.52.camel@joe-AO722>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9hP919J54GGjTtFrOY+bqbyaJ58Xo2
	i9n3H7NYzJqyl8ni8q45bBafe48wWlw6sIDJ4tre48wWd08dZbPoX9jLZLGv4wGTxdefDg48
	Hjtn3WX3aNl3i91j8Z6XTB77565h9/iy6hqzx/t9V9k8Hi1uYfRYsfo7u8fnTXIe67dsZQrg
	iuKySUnNySxLLdK3S+DK+NjdyFiwTaji/d8mlgbGfv4uRk4OCQETiR/nVjFB2GISF+6tZ+ti
	5OIQEljGKHFz3XJGCKeXSWLi/BlMEM58Ron5N3aAtbAJqEt8fr2DvYuRg0NEQFHi7hawqcwC
	e1gkpt4sAwkLC4RKPHrLCVERJtE7JRekQkRAT+J/RyMbiM0ioCpx98sudhCbV8BeYtudO+wQ
	m04wSvzqWglWxAh03PdTa5ggxotLNLfeZIE4WkBiyZ7zzBC2qMTLx/9YQXZJAF2zfbUVRLmW
	xPqdx6FatSWevLvACrFLUOLH5HssExjFZiGZOgtJyywkLbOQtCxgZFnFKFZanFxQnJSeWmGo
	V5yYW1yal66XnJ+7iRES71U7GO98tTnEKMDBqMTDOyHsaaAQa2JZcWXuIUYJDmYlEV6hfUAh
	3pTEyqrUovz4otKc1OJDjEwcnFINjCFn+tr9N9uaPJPJSuFMDJzBzyLM4dbXnTHngqu5C5fC
	3GMNGjY5G0uVvgnZHovnsLxrHvt4xk32Kzv3zzvdteWKyLbztpZ7f10u7k+9+WP+1K2K/zzs
	JkzstEneuKb7h5TfiqmVwbr+4mW8PoY25yxFYtuVW32PdqbUptizbUhvVYk56vRHiaU4I9FQ
	i7moOBEAdNwbMdUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 04:17 PM, Joe Perches wrote:
> On Tue, 2013-07-16 at 22:04 +0000, Shuah Khan wrote:
>> On 07/16/2013 03:39 PM, Joe Perches wrote:
>>> On Tue, 2013-07-16 at 15:23 -0600, Shuah Khan wrote:
>>>> A new trace event is added to pm events to print time it takes to suspend and
>>>> resume a device. It generates trace message that includes device, driver,
>>>> parent information in addition to the type of pm ops invoked as well as the
>>>> pm event and error status from the pm ops. Example trace below:
>>>
>>>> diff --git a/include/trace/events/power.h b/include/trace/events/power.h
>>> []
>>>> @@ -66,6 +66,41 @@ TRACE_EVENT(machine_suspend,
>>>>    	TP_printk("state=%lu", (unsigned long)__entry->state)
>>>>    );
>>>>
>>>> +TRACE_EVENT(device_pm_report_time,
>>>> +
>>>> +	TP_PROTO(const char *device, const char *driver, const char *parent,
>>>> +		 const char *pm_ops, ktime_t ops_time, char *pm_event_str,
>>>> +		 int error),
>>>> +
>>>> +	TP_ARGS(device, driver, parent, pm_ops, ops_time, pm_event_str, error),
>>>> +
>>>> +	TP_STRUCT__entry(
>>>> +		__string(device, device)
>>>> +		__string(driver, driver)
>>>> +		__string(parent, parent)
>>>> +		__string(pm_ops, pm_ops)
>>>> +		__string(pm_event_str, pm_event_str)
>>>> +		__field(unsigned long long, ops_time)
>>>
>>> s64
>>
>> Followed the ktime_t example in include/trace/events/timer.h - thinking
>> it would be the correct way to cast ktime_t :)  I can change it to s64.
>
> You mean this one below where s64 is used for the
> variable type?

oh yeah it does have s64.

>
> I do think the %llu is odd below here and it should be
> %lld without the casts.

ok.

>
> I prefer the TP_printk style of "foo=val" over "foo(val)"
> but there's no requirement for one style over another.
>

Existing events in power.h use foo=val convention - I will make the 
change to be consistent.

thanks for the review.
-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
