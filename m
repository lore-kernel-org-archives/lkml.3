Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab3GRPMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:12:44 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:43418 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab3GRPMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:12:42 -0400
X-AuditID: cbfec37d-b7f036d000004805-2d-51e805e88b4a
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
Subject: Re: [PATCH v3] power: new trace event to print device suspend and
 resume time
Thread-topic: [PATCH v3] power: new trace event to print device suspend and
 resume time
Thread-index: AQHOg0HorBqjVjepfkmuD47qGxcMYg==
Date: Thu, 18 Jul 2013 15:12:39 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6173D634@sisaex02sj>
References: <1374102201-2937-1-git-send-email-shuah.kh@samsung.com>
 <1374110574.6458.201.camel@gandalf.local.home>
 <B8EFE96D1287C24090BAD9D858E15E6173D4A9@sisaex02sj>
 <1374157309.6458.232.camel@gandalf.local.home>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t9hP90XrC8CDV7dkrKY+bqbyaJ58Xo2
	i9n3H7NYzJqyl8ni8q45bBafe48wWlw6sIDJ4tre48wWd08dZbPoX9jLZLGv4wGTxdefDg48
	Hjtn3WX3aNl3i91j8Z6XTB77565h9/iy6hqzx/t9V9k8Hi1uYfRYsfo7u8fnTXIe67dsZQrg
	iuKySUnNySxLLdK3S+DK2Dl7OmPBI66KrksHWBoYP3F0MXJySAiYSDx7eoEFwhaTuHBvPVsX
	IxeHkMAyRomVzw4zQzi9TBKL73RDOfMZJf5NOg7WwiagLvH59Q52EFtEQEOiZcFzFpAiZoEt
	LBJ3ps1hBEkIC0RInH57hBmiKFLi+M75jBC2nkRH3zqgOAcHi4CqxNLb3CBhXgF7iaffdoOV
	CwncZpSYtyYexGYEOu/7qTVMIDazgLhEc+tNqLMFJJbsOc8MYYtKvHz8jxVkpISAosT21VYQ
	5VoS63ceh2rVlnjy7gIrxCpBiR+T77FMYBSbhWTqLCQts5C0zELSsoCRZRWjWGlxckFxUnpq
	hYlecWJucWleul5yfu4mRkjM1+5gvP/V5hCjAAejEg/vgy/PA4VYE8uKK3MPMUpwMCuJ8K79
	CRTiTUmsrEotyo8vKs1JLT7EyMTBKdXAuGV7ouGz9j0NKad+Te7injf/5METXPeVMpdpaZ5O
	nJOX2Nxtxxk7ZaXGpK9PbsofnrHH5vDEW/efHp52jcNjMduUOousADabSWLLmlocK6e59vpd
	N4yScdrJrLaqd++MI6cLlpvO570QO7Wlbtb8iu9yqkcmC7s32vZE3vM22XBBWfIIS8vTY0os
	xRmJhlrMRcWJABkgVr7XAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 08:21 AM, Steven Rostedt wrote:
> On Thu, 2013-07-18 at 14:00 +0000, Shuah Khan wrote:
>
>>>
>>> Don't you want to convert the ops_time on display? You can have:
>>>
>>> 	TP_printk("%s %s parent=%s state=%s ops=%snsecs=%lld err=%d",
>>> 		__get_str(driver), __get_str(device), __get_str(parent),
>>> 		__get_str(pm_event_str), __get_str(pm_ops),
>>> 		ktime_to_ns(__entry->ops_time), __entry->error)
>>>
>>>
>>> -- Steve
>>
>> I decided to pass in the converted value to the tracepoint. Please see
>> the drivers/base/power/main.c call to trace_device_pm_report_time()
>
> But why? You are still doing the calculation in the fast path. The
> TP_printk() is in the slow path. Why add overhead to the execution of
> the code?
>
> -- Steve

Yes. You are right. I want to avoid passing in ktime_t, I can still do 
that without doing the conversion in fast path. I could pass in tv64 
value and do the conversion in TP_printk.

Hopefully I will get this right this time. This is my first tracepoint. 
Thanks for your patience.

-- Shuah

-- 
Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
