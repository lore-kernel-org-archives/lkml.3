Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab3HWHq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:46:59 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:54868 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab3HWHq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:46:57 -0400
Message-ID: <52171367.90005@huawei.com>
Date: Fri, 23 Aug 2013 15:46:47 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 08/11] cpuset: separate configured masks and efffective
 masks
References: <52148F52.0@huawei.com> <52148FCA.8010704@huawei.com> <20130821140846.GH19286@mtj.dyndns.org>
In-Reply-To: <20130821140846.GH19286@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/21 22:08, Tejun Heo wrote:
> On Wed, Aug 21, 2013 at 06:00:42PM +0800, Li Zefan wrote:
>> @@ -2261,7 +2271,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
>>  	/* synchronize mems_allowed to N_MEMORY */
>>  	if (mems_updated) {
>>  		mutex_lock(&callback_mutex);
>> -		top_cpuset.mems_allowed = new_mems;
>> +		if (!sane)
>> +			top_cpuset.mems_allowed = new_mems;
> 
> Can you please further explain how the top cgroup behaves?
> 

top_cpuset.cpus_allowed will always be cpu_active_mask if sane_behavior
is not set, otherwise it will always be cpu_possible_mask. While
top_cpuset.effective_cpus will always be cpu_active_mask in either
case.

