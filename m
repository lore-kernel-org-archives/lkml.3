Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936701Ab3DIBad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 21:30:33 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:21925 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936307Ab3DIBab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 21:30:31 -0400
Message-ID: <51636F0D.5060000@huawei.com>
Date: Tue, 9 Apr 2013 09:29:49 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] cpuacct, cgroup: Kill cgroup_subsys.active
References: <51553813.10004@huawei.com> <1364553360.5053.84.camel@laptop>
In-Reply-To: <1364553360.5053.84.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Any chance for this patchset and the other one to be queued for 3.10?

Both of them has been acked by Peter.

On 2013/3/29 18:36, Peter Zijlstra wrote:
> On Fri, 2013-03-29 at 14:43 +0800, Li Zefan wrote:
>> cpuacct is the only user of cgroup_subsys.active flag.
>>
>> The flag is needed because cpuacct_charge() and
>> cpuacct_account_field() can
>> be called when cpuacct hasn't been initialized during system bootup.
>>
>> This patch initializes cpuacct earlier, and the result is we don't
>> have
>> to check the flag in scheduler hot path.
>>
>> Note, this patchset is based on "[PATCH v2 0/7] sched: Split cpuacct"
>>
>>         http://lkml.org/lkml/2013/3/28/1
>>
>> 0001-cpuacct-allocate-per_cpu-cpuusage-for-root-cpuacct-s.patch
>> 0002-cpuacct-Initialize-root-cpuacct-earlier.patch
>> 0003-cpuacct-Initialize-cpuacct-subsystem-earlier.patch
>> 0004-cpuacct-No-need-to-check-subsys-active-state.patch
>> 0005-cgroup-Remove-subsys.active-flag.patch
> 
> 
> Seems sane enough
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 

