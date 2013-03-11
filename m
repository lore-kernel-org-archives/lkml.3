Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3CKPka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:40:30 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:55090 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab3CKPk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:40:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130311152400.GK24522@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
	<513C61B9.5030004@cn.fujitsu.com>
	<20130310120113.GC24522@htj.dyndns.org>
	<20130311152400.GK24522@htj.dyndns.org>
Date: Mon, 11 Mar 2013 23:40:28 +0800
Message-ID: <CACvQF5204P6YdWvkVuwjbTFmO=vFckOUNJq36UjZJmRwxWHfTQ@mail.gmail.com>
Subject: Re: [PATCHSET wq/for-3.10-tmp] workqueue: implement workqueue with
 custom worker attributes
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 11:24 PM, Tejun Heo <tj@kernel.org> wrote:
> On Sun, Mar 10, 2013 at 05:01:13AM -0700, Tejun Heo wrote:
>> Hey, Lai.
>>
>> On Sun, Mar 10, 2013 at 06:34:33PM +0800, Lai Jiangshan wrote:
>> > > This patchset contains the following 31 patches.
>> > >
>> > >  0001-workqueue-make-sanity-checks-less-punshing-using-WAR.patch
>> >
>> > >  0002-workqueue-make-workqueue_lock-irq-safe.patch
>> >
>> > workqueue_lock protects too many things. We can introduce different locks
>> > for different purpose later.
>>
>> I don't know.  My general attitude toward locking is the simpler the
>> better.  None of the paths protected by workqueue_lock are hot.
>> There's no actual benefit in making them finer grained.
>
> Heh, I need to make workqueues and pools protected by a mutex rather
> than spinlock, so I'm breaking out the locking after all.  This is
> gonna be a separate series of patches and it seems like there are
> gonna be three locks - wq_mutex (pool and workqueues), pwq_lock
> (spinlock protecting pwqs), wq_mayday_lock (lock for the mayday list).

Glad to hear this.
wq_mayday_lock is needed at least. spin_lock_irq(workqueue_lock)
with long loop in its C.S hurts RT people.

Thanks,
Lai

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
