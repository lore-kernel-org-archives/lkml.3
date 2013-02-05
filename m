Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3BEPSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:18:54 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:50278 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab3BEPSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:18:53 -0500
MIME-Version: 1.0
In-Reply-To: <20130204221203.GA8068@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
	<1359657696-2767-14-git-send-email-laijs@cn.fujitsu.com>
	<20130204221203.GA8068@mtj.dyndns.org>
Date: Tue, 5 Feb 2013 23:18:52 +0800
Message-ID: <CACvQF50Wt+_U2cZewOTfZthNGOLe4fL66D9tRdKnTxet-iTscg@mail.gmail.com>
Subject: Re: [PATCH 13/13] workqueue: record global worker ID instead of pool
 ID in work->data when off-queue
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 6:12 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> One more thing.
>
> On Fri, Feb 01, 2013 at 02:41:36AM +0800, Lai Jiangshan wrote:
>> @@ -1216,7 +1198,11 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
>>               list_del_init(&work->entry);
>>               cwq_dec_nr_in_flight(get_work_cwq(work), get_work_color(work));
>>
>> -             clear_work_cwq(work, pool->id);
>> +             /* Does the work is still running? */
>> +             worker = find_worker_executing_work(pool, work);
>> +             worker_gwid = worker ? worker->gwid: WORK_OFFQ_WORKER_NONE;
>> +             clear_work_cwq(work, worker_gwid);
>
> Any chance we can remove the busy_hash?  Having to keep it around
> isn't a big deal but it would be nice if can get rid of it.

It is very possible, but it needs a different trade-off.
And I didn't plan to implement it in the series.
I will discus it when this series is settled down.

Thanks,
lai

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
