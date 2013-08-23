Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab3HWH5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:57:24 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:2304 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab3HWH5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:57:20 -0400
Message-ID: <52171128.3070206@huawei.com>
Date: Fri, 23 Aug 2013 15:37:12 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 10/11] cpuset: allow writing offlined masks to cpuset.cpus/mems
References: <52148F52.0@huawei.com> <52148FF1.5060503@huawei.com> <20130821141851.GJ19286@mtj.dyndns.org>
In-Reply-To: <20130821141851.GJ19286@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/21 22:18, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 21, 2013 at 06:01:21PM +0800, Li Zefan wrote:
>> -		if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
>> +		if (!cpumask_subset(trialcs->cpus_allowed,
>> +				    top_cpuset.cpus_allowed))
> 
> Hmmm... top_cpuset.cpus_allowed is filled using cpumask_setall(),
> which may include more bits than cpu_possible_mask, which is kinda
> weird.  We probably wanna initialize it with cpu_possible_mask and
> also maybe using cpu_possible_mask in the above would be clearer?

In cpuset_init(), all the bits in cpus_allowed are set. Then in
cpuset_init_smp(), it's set to cpu_active_mask.

so we should set top_cpuset.cpus_allowed to possible_mask if mount
with sane_behavior, otherwise set it to active_mask.

> 
> Also, shouldn't this be dependent upon sane_behavior?
> 

We already treat top_cpus.cpus_allowed differently depending on
save_behavior, so the if statement works correctly.

