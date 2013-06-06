Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab3FFKAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:00:08 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:37093 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3FFKAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:00:06 -0400
Message-ID: <51B05D54.4080205@huawei.com>
Date: Thu, 6 Jun 2013 17:58:44 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH v2 06/10] cpuset: record old_mems_allowed in struct cpuset
References: <51AF0183.8070602@huawei.com> <51AF01E8.8080205@huawei.com> <20130605194522.GG10693@mtj.dyndns.org>
In-Reply-To: <20130605194522.GG10693@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/6 3:45, Tejun Heo wrote:
> Hello, Li.
> 
> On Wed, Jun 05, 2013 at 05:16:24PM +0800, Li Zefan wrote:
>> @@ -1425,7 +1435,6 @@ static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
>>  	 * Change mm, possibly for multiple threads in a threadgroup. This is
>>  	 * expensive and may sleep.
>>  	 */
>> -	cpuset_attach_nodemask_to = cs->mems_allowed;
>>  	mm = get_task_mm(leader);
>>  	if (mm) {
>>  		mpol_rebind_mm(mm, &cpuset_attach_nodemask_to);
> 
> This looks a bit suspicious to me.  Now we're setting mm's nodemask to
> guarantee_online_mems() output rather than cs->mems_allowed.  Is this
> change intended?  If so, it probably deserves an explanation in the
> description?
> 

It's possible that cs->mems_allowed is empty, but I should have left
it as it is, as it's not related to this patch.

