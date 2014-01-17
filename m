Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaAQDi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 22:38:28 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:52264 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaAQDi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 22:38:26 -0500
Message-ID: <52D8A56F.1010507@huawei.com>
Date: Fri, 17 Jan 2014 11:37:19 +0800
From: Weng Meiling <wengmeiling.weng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, Robert Richter <rric@kernel.org>
CC: "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        "wangnan0@huawei.com" <wangnan0@huawei.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>,
        "sdu.liu@huawei.com" <sdu.liu@huawei.com>
Subject: Re: [PATCH] oprofile: check whether oprofile perf enabled in op_overflow_handler()
References: <52B3F66D.6060707@huawei.com> <20140113084555.GU20315@rric.localhost> <52D4984B.9090600@huawei.com> <20140114150553.GC20315@rric.localhost> <52D5EC44.30101@huawei.com> <20140115102445.GE20315@rric.localhost> <52D73148.4090408@huawei.com> <52D7A750.50906@huawei.com> <20140116115245.GB8360@rric.localhost> <20140116193652.GD22105@mudshark.cambridge.arm.com>
In-Reply-To: <20140116193652.GD22105@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.66]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/17 3:36, Will Deacon wrote:
> On Thu, Jan 16, 2014 at 11:52:45AM +0000, Robert Richter wrote:
>> (cc'ing Will)
> 
> Thanks Robert,
> 
>> The problem of too low sample periods could be solved on ARM by using
>> perf's interrupt throttling, you might play around with:
>>
>>  /proc/sys/kernel/perf_event_max_sample_rate:100000
>>
>> I am not quite sure whether this works esp. for kernel counters and

Try to lower the value of perf_event_max_sample_rate, it works. Testing
the following values:
100 500 1000 5000 10000 50000

for the last value, the command start to stall.
Just a simple test. :)


>> how userland can be notified about throttling. Throttling could be
>> worth for operf too, not only for the oprofile kernel driver.
>>

>> From a quick look it seems there is also code in x86 that dynamically
>> adjusts the rate which might be worth being implemented for ARM too.
> 
> Are you referring to the perf_sample_event_took callback? If so, that
> certainly looks worth persuing. I'll stick it on my list, thanks!
> 

Thanks Will for doing this.

Thanks
Weng Meiling

> Will
> 
> .
> 



