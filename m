Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab3AYC3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:29:20 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:48250 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3AYC3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:29:12 -0500
Message-ID: <5101ED8C.9030205@huawei.com>
Date: Fri, 25 Jan 2013 10:27:24 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 6/6] cgroup: remove bogus comments in cgroup_diput()
References: <5100D4FE.9080205@huawei.com> <5100D562.6050407@huawei.com> <20130124214917.GU2373@mtj.dyndns.org>
In-Reply-To: <20130124214917.GU2373@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jan 24, 2013 at 02:32:02PM +0800, Li Zefan wrote:
>> Since commit 48ddbe194623ae089cc0576e60363f2d2e85662a
>> ("cgroup: make css->refcnt clearing on cgroup removal optional"),
>> each css holds a ref on cgroup's dentry, so cgroup_diput() won't be
>> called until all css' refs go down to 0, which invalids the comments.
>>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
>> ---
>>  kernel/cgroup.c | 6 ------
>>  1 file changed, 6 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index f18b0d9..368cff1 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -899,12 +899,6 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
>>  		struct cgroup *cgrp = dentry->d_fsdata;
>>  
>>  		BUG_ON(!(cgroup_is_removed(cgrp)));
>> -		/* It's possible for external users to be holding css
>> -		 * reference counts on a cgroup; css_put() needs to
>> -		 * be able to access the cgroup after decrementing
>> -		 * the reference count in order to know if it needs to
>> -		 * queue the cgroup to be handled by the release
>> -		 * agent */
> 
> The latter half is still true tho.  I applied the patch anyway as the
> comment isn't all that useful without covering everything intended to
> be covered with RCU.  Can you please write up another patch
> documenting what's covered by RCU (stuff that we intend to keep
> guaranteeing to be safe to access only w/ RCU)?
> 

Sure. I'll try.

