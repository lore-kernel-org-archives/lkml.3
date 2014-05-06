Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaEFQdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:33:37 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:63071 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaEFQde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:33:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140505145912.GG11231@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
	<1398571754-12443-7-git-send-email-laijs@cn.fujitsu.com>
	<20140505145912.GG11231@htj.dyndns.org>
Date: Wed, 7 May 2014 00:33:34 +0800
X-Google-Sender-Auth: CoAyU9wWzqVMnPsjv69rCCsgLL8
Message-ID: <CACvQF50=qe2p06iR1kLv6jU2K2VJQR4Tux0nXM1=MArZabWs4A@mail.gmail.com>
Subject: Re: [PATCH 06/10] workqueue: convert worker_idr to worker_ida
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 10:59 PM, Tejun Heo <tj@kernel.org> wrote:
> On Sun, Apr 27, 2014 at 12:09:01PM +0800, Lai Jiangshan wrote:
>> @@ -2224,6 +2220,9 @@ woke_up:
>>               spin_unlock_irq(&pool->lock);
>>               WARN_ON_ONCE(!list_empty(&worker->entry));
>>               worker->task->flags &= ~PF_WQ_WORKER;
>> +
>> +             set_task_comm(worker->task, "kworker_die");
>> +             ida_simple_remove(&pool->worker_ida, worker->id);
>>               worker_unbind_pool(worker);
>>               kfree(worker);
>>               return 0;
>
> Does this chunk belong to this patch?  Why no description about this
> change?

"set_task_comm()" doesn't belong to this patch. it avoids two workers
have the same name.(one is dying, the other one is newly created"

"ida_simple_remove()" does belong to this patch. and it is needed to
be removed out from  worker_unbind_pool() to here.

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
