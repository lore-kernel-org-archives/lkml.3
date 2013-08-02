Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3HBRtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:49:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34171 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751627Ab3HBRty convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:49:54 -0400
From: Dan Williams <djbw@fb.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        "Blin, Jerome" <jerome.blin@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [PATCH 1/3] dmatest: make module parameters writable
Thread-Topic: [PATCH 1/3] dmatest: make module parameters writable
Thread-Index: AQHOh7p6sYhbiZEqiE253lzrXOCaM5l/WkAAgALnlYA=
Date: Fri, 2 Aug 2013 17:49:32 +0000
Message-ID: <CE2134A4.1D1FD%djbw@fb.com>
In-Reply-To: <1375280890.31118.69.camel@smile>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.5.130515
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <C8EE06080085EE499B5111842C790C71@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-02_06:2013-08-02,2013-08-02,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 7/31/13 7:28 AM, "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>
wrote:

>On Tue, 2013-07-23 at 18:36 +0300, Andy Shevchenko wrote:
>> The debugfs interface brought a copy of the test case parameters. This
>>makes
>> different set of values under /sys/module/dmatest/parameters/ and
>> /sys/kernel/debug/dmatest/. The user might be confused by the
>>divergence of
>> values.
>> 
>> The proposed solution in this patch is to make module parameters
>>writable and
>> remove them from the debugfs. Though we're still using debugfs to
>>control test
>> runner and getting results.
>> 
>> Documentation part is updated accordingly.
>> 
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Suggested-by: Dan Williams <djbw@fb.com>
>
>Dan, do you have any comments against this series?
>I'd like to have this incorporated into v3.12.

I like this direction, and these can go in as is.  But I think with a bit
more work we can eventually trim the Œresults' file and the
thread_{add|get}_result infrastructure.  Ideally we could move all result
reporting to ftrace and let a module parameter control which errors are
reported.

However, unless I missed it, I don¹t see this support[1] upstream yet.


--
Dan

[1]: https://lwn.net/Articles/432186/

