Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab3CXQEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 12:04:21 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:54060 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab3CXQEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 12:04:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130320185708.GB31256@htj.dyndns.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
	<20130320185708.GB31256@htj.dyndns.org>
Date: Mon, 25 Mar 2013 00:04:19 +0800
Message-ID: <CACvQF53=qgUHrr944D_70dZpT-EOMtPcz2+0JPp4kOnGPzAptQ@mail.gmail.com>
Subject: Re: [PATCHSET wq/for-3.10] workqueue: NUMA affinity for unbound workqueues
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: laijs@cn.fujitsu.com, axboe@kernel.dk, jack@suse.cz,
        fengguang.wu@intel.com, jmoyer@redhat.com, zab@redhat.com,
        linux-kernel@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, TJ

After long time(again) thought.

I think this patchset has this problem:
the work may be running on wrong CPU when
there is online cpu in its wq's cpumask.

example:
node0(cpu0,cpu1),node1(cpu2,cpu3),
wq's cpumask: 1,3
the pwq of this wq on the node1's cpumask: 3
current online cpu: 0-2.
so the cpumask of worker tasks of the pwq on node1 is actually cpu_all_mask.
so the work scheduled from cpu2 can be executed on cpu0 or cpu2.
we expect it is executed on cpu1 only.

It can be fixed by swapping pwqs(node's pwq <-> default pwq)
when cpuhotplug. But could you reschedule this patchset to wq/for-3.11?
the whole patchset is more complicated than my brain.

If you agree, I will rebase my patches again.

Thanks,
Lai

On Thu, Mar 21, 2013 at 2:57 AM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Mar 19, 2013 at 05:00:19PM -0700, Tejun Heo wrote:
>> and also available in the following git branch.
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-numa
>
> Branch rebased on top of the current wq/for-3.10 with updated patches.
> The new comit ID is 9555fbc12d786a9eae7cf7701a6718a0c029173e.
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
