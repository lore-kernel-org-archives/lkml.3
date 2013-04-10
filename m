Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936914Ab3DJOYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:24:41 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:55632 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936896Ab3DJOYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:24:39 -0400
MIME-Version: 1.0
In-Reply-To: <0000013df43c9afa-0cba04ce-4a5b-435e-acc4-5ee5a1cfeb6b-000000@email.amazonses.com>
References: <1365470478-645-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1365470478-645-2-git-send-email-iamjoonsoo.kim@lge.com>
	<0000013def3255c0-87577820-0ad9-46ac-8498-0589db4e7180-000000@email.amazonses.com>
	<20130410052619.GD5872@lge.com>
	<0000013df43c9afa-0cba04ce-4a5b-435e-acc4-5ee5a1cfeb6b-000000@email.amazonses.com>
Date: Wed, 10 Apr 2013 23:24:38 +0900
Message-ID: <CAAmzW4PZ4ODR5gjYczmoNBYP-yk7q6MTNdOO4A_qux0xCFH_Gg@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm, slub: count freed pages via rcu as this task's reclaimed_slab
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/10 Christoph Lameter <cl@linux.com>:
> On Wed, 10 Apr 2013, Joonsoo Kim wrote:
>
>> Hello, Christoph.
>>
>> On Tue, Apr 09, 2013 at 02:28:06PM +0000, Christoph Lameter wrote:
>> > On Tue, 9 Apr 2013, Joonsoo Kim wrote:
>> >
>> > > Currently, freed pages via rcu is not counted for reclaimed_slab, because
>> > > it is freed in rcu context, not current task context. But, this free is
>> > > initiated by this task, so counting this into this task's reclaimed_slab
>> > > is meaningful to decide whether we continue reclaim, or not.
>> > > So change code to count these pages for this task's reclaimed_slab.
>> >
>> > slab->reclaim_state guides the reclaim actions in vmscan.c. With this
>> > patch slab->reclaim_state could get quite a high value without new pages being
>> > available for allocation. slab->reclaim_state will only be updated
>> > when the RCU period ends.
>>
>> Okay.
>>
>> In addition, there is a little place who use SLAB_DESTROY_BY_RCU.
>> I will drop this patch[2/3] and [3/3] for next spin.
>
> What you have discoverd is an issue that we have so far overlooked. Could
> you add comments to both places explaining the situation?

Yes, I can.

> RCU is used for
> some inode and the dentry cache. Failing to account for these frees could
> pose a problem. One solution would be to ensure that we get through an RCU
> quiescent period in the slabs reclaim. If we can ensure that then your
> patch may be ok.

Hmm... I don't perfectly understand RCU code and it's quiescent
period. But, yes, it
can be one of possible solutions in my quick thought. Currently, I
have no ability to
do that, so I skip to think about this.

Thanks.

>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
