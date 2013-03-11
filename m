Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab3CKPma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:42:30 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41688 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3CKPm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:42:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130310120113.GC24522@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
	<513C61B9.5030004@cn.fujitsu.com>
	<20130310120113.GC24522@htj.dyndns.org>
Date: Mon, 11 Mar 2013 23:42:29 +0800
Message-ID: <CACvQF523Xeocr-wuu4iBG5ccG4j7K9tK1b687ddqgwszVi6f=A@mail.gmail.com>
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

On Sun, Mar 10, 2013 at 8:01 PM, Tejun Heo <tj@kernel.org> wrote:
> Hey, Lai.
>
> On Sun, Mar 10, 2013 at 06:34:33PM +0800, Lai Jiangshan wrote:
>> > This patchset contains the following 31 patches.
>> >
>> >  0001-workqueue-make-sanity-checks-less-punshing-using-WAR.patch
>>
>> >  0002-workqueue-make-workqueue_lock-irq-safe.patch
>>
>> workqueue_lock protects too many things. We can introduce different locks
>> for different purpose later.
>
> I don't know.  My general attitude toward locking is the simpler the
> better.  None of the paths protected by workqueue_lock are hot.
> There's no actual benefit in making them finer grained.
>
>> >  0023-workqueue-implement-get-put_pwq.patch
>>
>> I guess this patch and patch25 may have very deep issue VS RCU.
>
> Hmmm... scary.  I suppose you're gonna elaborate on the review of the
> actual patch?
>
>> >  0024-workqueue-prepare-flush_workqueue-for-dynamic-creati.patch
>> >  0025-workqueue-perform-non-reentrancy-test-when-queueing-.patch
>> >  0026-workqueue-implement-apply_workqueue_attrs.patch
>> >  0027-workqueue-make-it-clear-that-WQ_DRAINING-is-an-inter.patch
>> >  0028-workqueue-reject-increasing-max_active-for-ordered-w.patch
>> >  0029-cpumask-implement-cpumask_parse.patch
>> >  0030-driver-base-implement-subsys_virtual_register.patch
>> >  0031-workqueue-implement-sysfs-interface-for-workqueues.patch
>>
>>
>> for 1~13,15~22,26~28, please add Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

OK, Also add my Reviewed-by to 23~25.

>
> Done.
>

I didn't see you updated branch in your tree.

Thanks,
Lai

> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
