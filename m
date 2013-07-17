Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab3GQQao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:30:44 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:10451 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3GQQal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:30:41 -0400
X-AuditID: cbfec37d-b7f036d000004805-12-51e6c6b09f68
From: Shuah Khan <shuah.kh@samsung.com>
To: Joe Perches <joe@perches.com>, "rjw@sisk.pl" <rjw@sisk.pl>
Cc: "len.brown@intel.com" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2] power: new trace event to print device suspend and
 resume time
Thread-topic: [PATCH v2] power: new trace event to print device suspend and
 resume time
Thread-index: AQHOgwZvoT2AOKySMUq4xkXZjyv7jA==
Date: Wed, 17 Jul 2013 16:30:38 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6173CA8D@sisaex02sj>
References: <1374076659-3444-1-git-send-email-shuah.kh@samsung.com>
 <1374077325.1949.94.camel@joe-AO722>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t9hP90Nx54FGlx+KGIx83U3k0Xz4vVs
	FrPvP2axmDVlL5PF5V1z2Cw+9x5htLh0YAGTxbW9x5kt7p46ymbRv7CXyWJfxwMmi68/HRx4
	PHbOusvu0bLvFrvH4j0vmTz2z13D7vFl1TVmj/f7rrJ5PFrcwuixYvV3do/Pm+Q81m/ZyhTA
	FcVlk5Kak1mWWqRvl8CV8XPFGpaCHWIVd181sTQwzhHqYuTkkBAwkZh4aDUThC0mceHeerYu
	Ri4OIYFljBK/F/xmgnB6mSQW/TvPAuHMZ5Q4dWcvM0gLm4C6xOfXO9hBbBEBO4lLFxvARjEL
	zGWR6O3TAbGFBSIkek4vZIOoiZQ4v/QClK0n8eT2ZFYQm0VAVWLi7hNACzg4eAXsJR7PzAYJ
	CwlkSWw/c5oRxGYEuu77qTVQ48UlmltvskBcLSCxZM95ZghbVOLl43+sIGMkBBQltq+2gijX
	kli/8zhUq7bEk3cXwLbyCghK/Jh8j2UCo9gsJFNnIWmZhaRlFpKWBYwsqxjFSouTC4qT0lMr
	TPSKE3OLS/PS9ZLzczcxQiK+dgfj/a82hxgFOBiVeHgnhD0NFGJNLCuuzD3EKMHBrCTCe3DJ
	s0Ah3pTEyqrUovz4otKc1OJDjEwcnFINjFmnlPvbJL7rMDkH8SbFi8+58THq9Bfzj18/xJ7w
	U5kd5qf9V0ez49G2jdvlHidMCPv5b68686x09cV/zd/Pmp2b/7ZqquSCRVKKN25JFy8TYuGc
	wvsqvsC226C2sua6fmLKDDtmHrUFKevWR9xZeUZw94vdAaExcrwf/XYJ+2YlOgToPZusrcRS
	nJFoqMVcVJwIAFAXG/vWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 10:09 AM, Joe Perches wrote:
> On Wed, 2013-07-17 at 09:57 -0600, Shuah Khan wrote:
>> A new trace event is added to pm events to print time it takes to suspend and
>> resume a device. It generates trace message that includes device, driver,
>> parent information in addition to the type of pm ops invoked as well as the
>> pm event and error status from the pm ops. Example trace below:
>>
>> bash-2484  [001] ....   907.330148: device_pm_report_time: backlight acpi_video0 parent=0000:00:02.0 state=freeze ops=class  usecs=0 err=0
>>
>> bash-2484  [001] ....   909.906743: device_pm_report_time: backlight acpi_video0 parent=0000:00:02.0 state=restore ops=class  usecs=0 err=0
>

Hi Joe,

> Hi again Shuah.
>
> A few things:
>
>> diff --git a/include/trace/events/power.h b/include/trace/events/power.h
> []
>> +	TP_printk("%s %s parent=%s state=%s ops=%s usecs=%lld err=%d\n",
>
> As I wrote before, do not end a TP_printk with "\n",
>
> All TP_printks are self-contained and are not possible
> to use a thing like pr_cont so no newline is ever used.
>
> Use:
>
> 	TP_printk("%s %s parent=%s state=%s ops=%s usecs=%lld err=%d",

Sorry. Missed that one. Not intentional, just an oversight. :) I should 
fix that one.

>
> Given the data is in nsecs, why use usecs for the time?
> I think full resolution would be better.

My intent to was to match the time units to the original pm_print_times.

Rafael! Do you have any preference as to usecs vs. nsecs?

>
> Why are there two spaces after "ops=class"? One would be more normal.
>
>

This one is tough. The ops string that gets generated in conditionals in 
__device_suspend() and device_resume() routines, has an extra space at 
the end. I am not sure why that was done and the subsequent pr_* that 
print that string also depend on that extra space at the end. I don't 
have an easy way to fix it without changing lots of code where this 
string is generated. Hence, I chose to leave the extra space in. I also 
didn't want to propagate that assumption that there is an extra space 
into this new tracepoint.

I could truncate the string before I pass it to the new tracepoint 
routine, however I don't like that idea. One thing I can do is, generate 
separate patch that fixes the extra space issue. That would address the 
extra space in all cases.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
