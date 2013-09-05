Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3IEFMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 01:12:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56828 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753553Ab3IEFMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 01:12:07 -0400
X-Greylist: delayed 1575 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Sep 2013 01:12:07 EDT
Message-ID: <52280C73.9080209@fb.com>
Date: Thu, 5 Sep 2013 10:15:39 +0530
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
        Kumar Sundararajan <kumar@fb.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: clock_gettime_ns
References: <5226FAE1.5070201@fb.com> <CANcMJZAv_-nGkjt8r8cp+BhnSfhL2roKZpodN+vLKfmpTVLhrQ@mail.gmail.com>
In-Reply-To: <CANcMJZAv_-nGkjt8r8cp+BhnSfhL2roKZpodN+vLKfmpTVLhrQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-09-05_02:2013-09-05,2013-09-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/5/13 12:47 AM, John Stultz wrote:
> If we're going to add a new interface that uses something other then a
> timespec, we likely need to put some serious thought into that new
> type, and see how it could be used across a number of syscalls. Some
> of the discussion around dealing with the 2038 issue touched on this.

[ I know you're not asking for perf data, but may be useful for new 
readers ]

Here's the benchmarking I did in 2011:

http://thread.gmane.org/gmane.linux.kernel/1233758/focus=1233781

Switching from timespec to s64 was worth 21%. My experience over the 
years is that this performance delta causes userspace guys to implement 
their own TSC based timers, against the advice from kernel developers.

http://code.ohloh.net/search?s=wall%20now%20tsc%20hz&pp=0&fl=C&fl=C%2B%2B&ff=1&mp=1&ml=1&me=1&md=1&filterChecked=true

I worry that trying to solve other clock problems will cause the kernel 
to continue to pass the time in memory instead of registers, giving the 
userspace TSC based implementations a reason to exist.

  -Arun
