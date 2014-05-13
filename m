Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaEMGD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:03:56 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:11782 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750837AbaEMGDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:03:55 -0400
X-IronPort-AV: E=Sophos;i="4.97,1040,1389715200"; 
   d="scan'208";a="30437930"
Message-ID: <5371B6CB.3090301@cn.fujitsu.com>
Date: Tue, 13 May 2014 14:08:11 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10 V2] workqueue: destroy_worker() should destroy idle
 workers only
References: <20140505150514.GI11231@htj.dyndns.org> <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com> <1399877792-13046-3-git-send-email-laijs@cn.fujitsu.com> <20140512210811.GB18959@mtj.dyndns.org>
In-Reply-To: <20140512210811.GB18959@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 05:08 AM, Tejun Heo wrote:
> On Mon, May 12, 2014 at 02:56:14PM +0800, Lai Jiangshan wrote:
>> @@ -1692,9 +1691,8 @@ static struct worker *alloc_worker(void)
>>   * create_worker - create a new workqueue worker
>>   * @pool: pool the new worker will belong to
>>   *
>> - * Create a new worker which is bound to @pool.  The returned worker
>> - * can be started by calling start_worker() or destroyed using
>> - * destroy_worker().
>> + * Create a new worker which is attached to @pool.
>> + * The new worker must be started and enter idle via start_worker().
> 
> Please always fill the comment paragarphs to 75 column or so.  Also,

> do we even need start_worker() separate anymore?  Maybe we can just
> fold alloc_and_create_worker() into alloc_worker()?

We should do this I think. but it is just cleanup, I will do it after
this core patchset is accepted.

> 
>> @@ -1815,6 +1812,7 @@ static int create_and_start_worker(struct worker_pool *pool)
>>   * @worker: worker to be destroyed
>>   *
>>   * Destroy @worker and adjust @pool stats accordingly.
>> + * The worker should be idle.
> 
> Ditto about filling.
> 
> Looks good otherwise.
> 
> Thanks.
> 

