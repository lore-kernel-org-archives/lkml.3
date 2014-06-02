Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaFBD5t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 23:57:49 -0400
Received: from ozlabs.org ([103.22.144.67]:36102 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbaFBD5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 23:57:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] block: virtio_blk: don't hold spin lock during world switch
In-Reply-To: <53888D08.1050602@kernel.dk>
References: <1401418169-3361-1-git-send-email-ming.lei@canonical.com> <5387F8B2.1070509@kernel.dk> <CACVXFVPoG6_fL_MTRF+616W7UdHpSgjtMLBLeBn4OGR63haw3w@mail.gmail.com> <5387FC96.4030508@kernel.dk> <877g537q6d.fsf@rustcorp.com.au> <53888D08.1050602@kernel.dk>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 02 Jun 2014 10:53:21 +0930
Message-ID: <87sino5cl2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:
> On 2014-05-30 00:10, Rusty Russell wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>>> If Rusty agrees, I'd like to add it for 3.16 with a stable marker.
>>
>> Really stable?  It improves performance, which is nice.  But every patch
>> which goes into the kernel fixes a bug, improves clarity, improves
>> performance or adds a feature.  I've now seen all four cases get CC'd
>> into stable.
>>
>> Including some of mine explicitly not marked stable which get swept up
>> by enthusiastic stable maintainers :(
>>
>> Is now there *any* patch short of a major rewrite which shouldn't get
>> cc: stable?
>
> I agree that there's sometimes an unfortunate trend there. I didn't 
> check, but my assumption was that this is a regression after the blk-mq 
> conversion, in which case I do think it belongs in stable.

No, it's always been that way.  In the original driver the entire "issue
requests" function was under the lock.

It was your mq conversion which made this optimization possible, and
also made it an optimization: now other the queues can continue while
this one is going.

> But in any case, I think the patch is obviously correct and the wins are 
> sufficiently large to warrant a stable inclusion even if it isn't a 
> regression.

If you're running SMP under an emulator where exits are expensive, then
this wins.  Under KVM it's marginal at best.

Locking changes which are "obviously correct" make me nervous, too :)

But IIRC last KS the argument is that not *enough* is going into stable,
not that stable isn't stable enough.  So maybe it's a non-problem?

Cheers,
Rusty.
