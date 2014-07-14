Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaGNC3V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 22:29:21 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:2799 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752204AbaGNC3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 22:29:14 -0400
X-IronPort-AV: E=Sophos;i="5.00,886,1396972800"; 
   d="scan'208";a="33217948"
Message-ID: <53C340B3.5040209@cn.fujitsu.com>
Date: Mon, 14 Jul 2014 10:30:11 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] workqueue: remove the first check and the return
 value of maybe_create_worker()
References: <1405008074-11031-1-git-send-email-laijs@cn.fujitsu.com> <1405008074-11031-2-git-send-email-laijs@cn.fujitsu.com> <20140711150327.GF27706@htj.dyndns.org>
In-Reply-To: <20140711150327.GF27706@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 11:03 PM, Tejun Heo wrote:
> On Fri, Jul 11, 2014 at 12:01:03AM +0800, Lai Jiangshan wrote:
>> @@ -1887,17 +1887,11 @@ static void pool_mayday_timeout(unsigned long __pool)
>>   * spin_lock_irq(pool->lock) which may be released and regrabbed
>>   * multiple times.  Does GFP_KERNEL allocations.  Called only from
>>   * manager.
>> - *
>> - * Return:
>> - * %false if no action was taken and pool->lock stayed locked, %true
>> - * otherwise.
>>   */
>> -static bool maybe_create_worker(struct worker_pool *pool)
>> +static void maybe_create_worker(struct worker_pool *pool)
> 
> We probably should drop "maybe_" from the function name?
> 

We already have create_worker(). And maybe_create_worker() does not always create worker.
maybe_create_worker() may not create worker if the condition is changed after
it fails at the first time, 
