Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab3GQRGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:06:37 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:26344 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab3GQRGf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:06:35 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-fe-51e6cf1aa103
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
Subject: Re: [PATCH v2] power: new trace event to print device suspend and
 resume time
Thread-topic: [PATCH v2] power: new trace event to print device suspend and
 resume time
Thread-index: AQHOgwZvoT2AOKySMUq4xkXZjyv7jA==
Date: Wed, 17 Jul 2013 17:06:33 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6173CB98@sisaex02sj>
References: <1374076659-3444-1-git-send-email-shuah.kh@samsung.com>
 <1374078866.6458.150.camel@gandalf.local.home>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t9hP12p888CDZqP8lrMfN3NZNG8eD2b
	xez7j1ksZk3Zy2RxedccNovPvUcYLS4dWMBkcW3vcWaLu6eOsln0L+xlstjX8YDJ4utPBwce
	j52z7rJ7tOy7xe6xeM9LJo/9c9ewe3xZdY3Z4/2+q2wejxa3MHqsWP2d3ePzJjmP9Vu2MgVw
	RXHZpKTmZJalFunbJXBl/N++mq1gHk/F6XO3mBoYJ3J1MXJySAiYSPT1r2aFsMUkLtxbz9bF
	yMUhJLCMUWJB0wZGCKeXSWLe3lksEM58Rok1K7uZQVrYBNQlPr/ewQ5iiwhoSLQseA5WxCyw
	hUXizrQ5jCAJYYEIiZ7TC9kgiiIlzi+9AGXrSTy5PRlsN4uAqsTN/4fABvEK2EssPX0ZrFdI
	oERiwallYPWMQPd9P7WGCcRmFhCXaG69yQJxt4DEkj3nmSFsUYmXj/8BzeQAshUltq+2gijX
	kli/8zhUq7bEk3cXWCFWCUr8mHyPZQKj2CwkU2chaZmFpGUWkpYFjCyrGMVKi5MLipPSUyuM
	9YoTc4tL89L1kvNzNzFCor5mB+O9rzaHGAU4GJV4eCeEPQ0UYk0sK67MPcQowcGsJMJ7cMmz
	QCHelMTKqtSi/Pii0pzU4kOMTBycUg2MMd+yK5qW77xYeesXT1holPIUFXuh5kmnFyRuFDib
	JmY6Z9ENvUsy18XZFCx3s93UUHvEcHRTxUmek+deNV985iuZ5aTU1T4n/cuUdaxz4wu2y948
	qsjpanhFSK6n/LT1/C7eZOvaEs32h6HvjKR/3jYyXttZ775UaIWf/vr7HSHajN+E274qsRRn
	JBpqMRcVJwIAYFOtxtgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 10:35 AM, Steven Rostedt wrote:
> On Wed, 2013-07-17 at 09:57 -0600, Shuah Khan wrote:
>
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
>> +		__field(s64, ops_time)
>> +		__field(int, error)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__assign_str(device, device);
>> +		__assign_str(driver, driver);
>> +		__assign_str(parent, parent);
>> +		__assign_str(pm_ops, pm_ops);
>> +		__assign_str(pm_event_str, pm_event_str);
>> +		__entry->ops_time = ktime_to_ns(ops_time) >> 10;
>
> You may want to just record the ops_time, and do the conversion in the
> TP_printk(). This is the fast path, and any calculations done here just
> increases the overhead of the trace point.
>
> -- Steve

Thanks for the review and pointing the overhead out. Will fix that.

-- Shuah

-- 
Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
