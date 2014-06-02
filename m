Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbaFBOPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:15:52 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43395 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbaFBOPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:15:48 -0400
Message-ID: <538C8712.20809@kernel.dk>
Date: Mon, 02 Jun 2014 08:15:46 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, Ming Lei <ming.lei@canonical.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] block: virtio_blk: don't hold spin lock during world
 switch
References: <1401418169-3361-1-git-send-email-ming.lei@canonical.com> <5387F8B2.1070509@kernel.dk> <CACVXFVPoG6_fL_MTRF+616W7UdHpSgjtMLBLeBn4OGR63haw3w@mail.gmail.com> <5387FC96.4030508@kernel.dk> <877g537q6d.fsf@rustcorp.com.au> <53888D08.1050602@kernel.dk> <87sino5cl2.fsf@rustcorp.com.au>
In-Reply-To: <87sino5cl2.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-01 19:23, Rusty Russell wrote:
> Jens Axboe <axboe@kernel.dk> writes:
>> On 2014-05-30 00:10, Rusty Russell wrote:
>>> Jens Axboe <axboe@kernel.dk> writes:
>>>> If Rusty agrees, I'd like to add it for 3.16 with a stable marker.
>>>
>>> Really stable?  It improves performance, which is nice.  But every patch
>>> which goes into the kernel fixes a bug, improves clarity, improves
>>> performance or adds a feature.  I've now seen all four cases get CC'd
>>> into stable.
>>>
>>> Including some of mine explicitly not marked stable which get swept up
>>> by enthusiastic stable maintainers :(
>>>
>>> Is now there *any* patch short of a major rewrite which shouldn't get
>>> cc: stable?
>>
>> I agree that there's sometimes an unfortunate trend there. I didn't
>> check, but my assumption was that this is a regression after the blk-mq
>> conversion, in which case I do think it belongs in stable.
>
> No, it's always been that way.  In the original driver the entire "issue
> requests" function was under the lock.
 >
 > It was your mq conversion which made this optimization possible, and
 > also made it an optimization: now other the queues can continue while
 > this one is going.

Ah, I stand corrected, you are right. I had this recollection that the 
prepare and kick where separate before as well, but apparently just bad 
memory.

>> But in any case, I think the patch is obviously correct and the wins are
>> sufficiently large to warrant a stable inclusion even if it isn't a
>> regression.
>
> If you're running SMP under an emulator where exits are expensive, then
> this wins.  Under KVM it's marginal at best.
>
> Locking changes which are "obviously correct" make me nervous, too :)

I tend to agree. But I think this one is simple enough to warrant doing 
it, when the performance increase is as large as it is.

> But IIRC last KS the argument is that not *enough* is going into stable,
> not that stable isn't stable enough.  So maybe it's a non-problem?

In principle, pushing the patch to stable definitely isn't an issue with 
the stable crew. And yes, they apparently do want more stuff. If you 
look at it from the distro side, having a stable(r) repository is a no 
brainer. And they'd want to pick this patch anyway, so...

-- 
Jens Axboe

