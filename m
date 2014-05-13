Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaEMGiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:38:50 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:23784 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751171AbaEMGit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:38:49 -0400
X-IronPort-AV: E=Sophos;i="4.97,1040,1389715200"; 
   d="scan'208";a="30439121"
Message-ID: <5371BEFA.9060902@cn.fujitsu.com>
Date: Tue, 13 May 2014 14:43:06 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10 V2] workqueue: convert worker_idr to worker_ida
References: <20140505150514.GI11231@htj.dyndns.org> <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com> <1399877792-13046-7-git-send-email-laijs@cn.fujitsu.com> <20140512214030.GG18959@mtj.dyndns.org>
In-Reply-To: <20140512214030.GG18959@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 05:40 AM, Tejun Heo wrote:
> On Mon, May 12, 2014 at 02:56:18PM +0800, Lai Jiangshan wrote:
>> @@ -1681,7 +1682,6 @@ static void worker_detach_from_pool(struct worker *worker,
>>  	struct completion *detach_completion = NULL;
>>  
>>  	mutex_lock(&pool->manager_mutex);
>> -	idr_remove(&pool->worker_idr, worker->id);
>>  	list_del(&worker->node);
>>  	if (list_empty(&pool->workers))
>>  		detach_completion = pool->detach_completion;
> 
> Why are we moving ida removal to the caller here?  Does

ida							is for worker ID
pool->workers list and worker_detach_from_pool()	are for attaching/detaching

moving ida removal to the caller removes the unneeded coupling.

> worker_detach_from_pool() get used for something else later?  Up until
> this point, the distinction seems pretty arbitrary.
> 
>> @@ -1757,8 +1754,6 @@ static struct worker *create_worker(struct worker_pool *pool)
>>  	if (pool->flags & POOL_DISASSOCIATED)
>>  		worker->flags |= WORKER_UNBOUND;
>>  
>> -	/* successful, commit the pointer to idr */
>> -	idr_replace(&pool->worker_idr, worker, worker->id);
> 
> Ah, the comment is removed altogether.  Please disregard my previous
> review on the comment.
> 
> Thanks.
> 

