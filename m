Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab3DTQMR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 12:12:17 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:38329 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab3DTQMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 12:12:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130404141229.GD9425@htj.dyndns.org>
References: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
	<20130404141229.GD9425@htj.dyndns.org>
Date: Sun, 21 Apr 2013 00:12:14 +0800
Message-ID: <CACvQF53uo0KCY20PyO8LKhs9g0Mt-OSJdv4F0P-cODWyL-TxQg@mail.gmail.com>
Subject: Re: [PATCH 1/7] workqueue: add __WQ_FREEZING and remove POOL_FREEZING
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please forget all my other patches.

But these 1/7 and 2/7 __WQ_FREEZING patches can be in 3.10

On Thu, Apr 4, 2013 at 10:12 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Lai.
>
> On Thu, Apr 04, 2013 at 10:05:32AM +0800, Lai Jiangshan wrote:
>> @@ -4757,25 +4747,16 @@ void thaw_workqueues(void)
>>  {
>>       struct workqueue_struct *wq;
>>       struct pool_workqueue *pwq;
>> -     struct worker_pool *pool;
>> -     int pi;
>>
>>       mutex_lock(&wq_pool_mutex);
>>
>>       if (!workqueue_freezing)
>>               goto out_unlock;
>>
>> -     /* clear FREEZING */
>> -     for_each_pool(pool, pi) {
>> -             spin_lock_irq(&pool->lock);
>> -             WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
>> -             pool->flags &= ~POOL_FREEZING;
>> -             spin_unlock_irq(&pool->lock);
>> -     }
>> -
>>       /* restore max_active and repopulate worklist */
>>       list_for_each_entry(wq, &workqueues, list) {
>>               mutex_lock(&wq->mutex);
>> +             wq->flags &= ~__WQ_FREEZING;
>
> I want an assertion here.

freezing codes is very simple for verifying.

> Maybe we can fold the next patch into this
> one and add WARN_ON_ONCE() here?

I consider the two patches are different intent.

Thanks,
Lai

>
>>               for_each_pwq(pwq, wq)
>>                       pwq_adjust_max_active(pwq);
>>               mutex_unlock(&wq->mutex);
>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
