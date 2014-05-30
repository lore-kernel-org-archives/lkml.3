Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaE3Dex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 23:34:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43931 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaE3Dew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 23:34:52 -0400
MIME-Version: 1.0
In-Reply-To: <5387F8B2.1070509@kernel.dk>
References: <1401418169-3361-1-git-send-email-ming.lei@canonical.com>
	<5387F8B2.1070509@kernel.dk>
Date: Fri, 30 May 2014 11:34:49 +0800
Message-ID: <CACVXFVPoG6_fL_MTRF+616W7UdHpSgjtMLBLeBn4OGR63haw3w@mail.gmail.com>
Subject: Re: [PATCH] block: virtio_blk: don't hold spin lock during world switch
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 11:19 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-05-29 20:49, Ming Lei wrote:
>>
>> Firstly, it isn't necessary to hold lock of vblk->vq_lock
>> when notifying hypervisor about queued I/O.
>>
>> Secondly, virtqueue_notify() will cause world switch and
>> it may take long time on some hypervisors(such as, qemu-arm),
>> so it isn't good to hold the lock and block other vCPUs.
>>
>> On arm64 quad core VM(qemu-kvm), the patch can increase I/O
>> performance a lot with VIRTIO_RING_F_EVENT_IDX enabled:
>>         - without the patch: 14K IOPS
>>         - with the patch: 34K IOPS
>
>
> Patch looks good to me. I don't see a hit on my qemu-kvm testing, but it
> definitely makes sense and I can see it hurting in other places.

It isn't easy to observe the improvement on x86 VM, especially
with few vCPUs, because qemu-system-x86_64 only takes
several microseconds to handle the notification, but on arm64, it
may take hundreds of microseconds, so the improvement is
obvious on arm VM.

I hope this patch can be merged, at least arm VM can benefit
from it.


Thanks,
--
Ming Lei
