Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486Ab3CNQlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:41:21 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:40431 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933724Ab3CNQlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:41:19 -0400
MIME-Version: 1.0
In-Reply-To: <CACvQF51pwb=63j3Q_U8=Kr2f4-6NE8+1qckMeo95Dws4iwPTVA@mail.gmail.com>
References: <1363229845-6831-1-git-send-email-tj@kernel.org>
	<1363229845-6831-2-git-send-email-tj@kernel.org>
	<CACvQF51pwb=63j3Q_U8=Kr2f4-6NE8+1qckMeo95Dws4iwPTVA@mail.gmail.com>
Date: Thu, 14 Mar 2013 09:41:18 -0700
X-Google-Sender-Auth: ipaBHTeXFjXJqR44XjYCSM4xpOc
Message-ID: <CAOS58YNSWsjaRpqnwL81=DJebs+ZHth9LDwnKdV_09t08AqL0Q@mail.gmail.com>
Subject: Re: [PATCH 1/7] workqueue: rename worker_pool->assoc_mutex to ->manager_mutex
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Lai.

On Thu, Mar 14, 2013 at 9:00 AM, Lai Jiangshan <eag0628@gmail.com> wrote:
>> @@ -4095,7 +4109,7 @@ static void wq_unbind_fn(struct work_struct *work)
>>                 pool->flags |= POOL_DISASSOCIATED;
>>
>>                 spin_unlock_irq(&pool->lock);
>> -               mutex_unlock(&pool->assoc_mutex);
>> +               mutex_unlock(&pool->manager_mutex);
>
> Hi, Tejun
>
> It must conflicts with wq/for-3.9-fixes.

Yeah, the resolution is trivial. I'll be carrying it in for-next once
this makes for-3.10.

Thanks.

-- 
tejun
