Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaF3CdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 22:33:10 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:54662 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753435AbaF3CdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 22:33:08 -0400
X-IronPort-AV: E=Sophos;i="5.00,804,1396972800"; 
   d="scan'208";a="32596876"
Message-ID: <53B0CC45.4080109@cn.fujitsu.com>
Date: Mon, 30 Jun 2014 10:32:37 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH 2/2] workqueue: stronger test in process_one_work()
References: <1401780809-12331-1-git-send-email-laijs@cn.fujitsu.com> <1401780809-12331-2-git-send-email-laijs@cn.fujitsu.com> <20140619194432.GC7390@mtj.dyndns.org> <53AC03AF.9050303@cn.fujitsu.com>
In-Reply-To: <53AC03AF.9050303@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.

Thanks,
Lai

On 06/26/2014 07:27 PM, Lai Jiangshan wrote:
> On 06/20/2014 03:44 AM, Tejun Heo wrote:
>> On Tue, Jun 03, 2014 at 03:33:28PM +0800, Lai Jiangshan wrote:
>>> When POOL_DISASSOCIATED is cleared, the running worker's local CPU should
>>> be the same as pool->cpu without any exception even during cpu-hotplug.
>>>
>>> This fix changes "(proposition_A && proposition_B && proposition_C)"
>>> to "(proposition_B && proposition_C)", so if the old compound proposition
>>> is true, the new one must be true too. so this fix will not hide any
>>> possible bug which can be hit by old test.
>>>
>>> CC: Jason J. Herne <jjherne@linux.vnet.ibm.com>
>>> CC: Sasha Levin <sasha.levin@oracle.com>
>>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>>
>> Applied to wq/for-3.17 with minor updates.
>>
>> Nice set of cleanups.  Thanks!
>>
> 
> Hi,Tejun
> 
> I found the slight earlier 6 patches are in wq/for-3.17.
> But these two patches (in this email thread) are not in wq/for-3.17 yet.
> 
> workqueue: clear POOL_DISASSOCIATED in rebind_workers()
> workqueue: stronger test in process_one_work()
> 
> Thanks,
> Lai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

