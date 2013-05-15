Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab3EOCQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 22:16:52 -0400
Received: from intranet.asianux.com ([58.214.24.6]:41404 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3EOCQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 22:16:51 -0400
X-Spam-Score: -100.8
Message-ID: <5192EFE0.4040903@asianux.com>
Date: Wed, 15 May 2013 10:16:00 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/workqueue.c: better to free related resources
 when failure occurs in wq_numa_init()
References: <51922D30.8000809@asianux.com> <20130514151752.GB6795@mtj.dyndns.org>
In-Reply-To: <20130514151752.GB6795@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 11:17 PM, Tejun Heo wrote:
> On Tue, May 14, 2013 at 08:25:20PM +0800, Chen Gang wrote:
>>
>> When NUMA node mapping not available for one cpu, need disabling NUMA
>> support and proceed.
>>
>> Also better to release unused resources (the original code can not
>> cause issue, only waste some memory).
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  kernel/workqueue.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index 1ae6028..a763079 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -4911,6 +4911,9 @@ static void __init wq_numa_init(void)
>>  		if (WARN_ON(node == NUMA_NO_NODE)) {
>>  			pr_warn("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
>>  			/* happens iff arch is bonkers, let's just proceed */
>> +			for_each_node(node)
>> +				free_cpumask_var(tbl[node]);
>> +			kfree(tbl);
> 
> Eh... let's just leave it alone.  The path is taken iff the whole
> thing is seriously broken and we're triggering WARN.  I don't think we
> need to worry about small memory wastage there.
> 
> Thanks.
> 

OK, I can understand. I will continue to try to find and make another
patches.


Thanks.
-- 
Chen Gang

Asianux Corporation
