Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbaGXCqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 22:46:31 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39737 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371AbaGXCq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 22:46:29 -0400
Message-ID: <53D0737C.2030305@linux.vnet.ibm.com>
Date: Thu, 24 Jul 2014 10:46:20 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at kernel/cpuset.c:1139
References: <53CF22F5.6000206@linux.vnet.ibm.com> <20140723151220.GD7103@htj.dyndns.org> <53D052FC.3070409@huawei.com>
In-Reply-To: <53D052FC.3070409@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072402-0260-0000-0000-000005711D60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 08:27 AM, Li Zefan wrote:
> On 2014/7/23 23:12, Tejun Heo wrote:
>> On Wed, Jul 23, 2014 at 10:50:29AM +0800, Mike Qiu wrote:
>>> commit 734d45130cb ("cpuset: update cs->effective_{cpus, mems} when config
>>> changes") introduce the below warning in my server.
>>>
>>> [   35.652137] ------------[ cut here ]------------
>>> [   35.652141] WARNING: at kernel/cpuset.c:1139
>> Hah, can you reproduce it?  If so, can you detail how?
>>
> It's a typo.
>
> WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
> 	nodes_equal(cp->mems_allowed, cp->effective_mems));
>
> should be
>
> WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
> 	!nodes_equal(cp->mems_allowed, cp->effective_mems));

Yes, it is. This warning disappeared after this patch.

Reported-and-Tested-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
>

