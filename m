Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbaFBNGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:06:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36455 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbaFBNGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:06:08 -0400
MIME-Version: 1.0
In-Reply-To: <87sino5cl2.fsf@rustcorp.com.au>
References: <1401418169-3361-1-git-send-email-ming.lei@canonical.com>
	<5387F8B2.1070509@kernel.dk>
	<CACVXFVPoG6_fL_MTRF+616W7UdHpSgjtMLBLeBn4OGR63haw3w@mail.gmail.com>
	<5387FC96.4030508@kernel.dk>
	<877g537q6d.fsf@rustcorp.com.au>
	<53888D08.1050602@kernel.dk>
	<87sino5cl2.fsf@rustcorp.com.au>
Date: Mon, 2 Jun 2014 21:06:05 +0800
Message-ID: <CACVXFVN9aBrdmeAQJ6YadF_6grSjm9raiLV1=eUMAL20uUeeCw@mail.gmail.com>
Subject: Re: [PATCH] block: virtio_blk: don't hold spin lock during world switch
From: Ming Lei <ming.lei@canonical.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 9:23 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
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
>
>> But in any case, I think the patch is obviously correct and the wins are
>> sufficiently large to warrant a stable inclusion even if it isn't a
>> regression.
>
> If you're running SMP under an emulator where exits are expensive, then
> this wins.  Under KVM it's marginal at best.

Both my tests on arm64 and x86 are under KVM, and looks the
patch can improve performance a lot. IMO, even though under
KVM, virtio-blk performance still depends how well hypervisor(
qemu, ...) emulates the device, and basically speaking, it is
expensive to switch from guest to host and let host handle the
notification.


Thanks,
--
Ming Lei
