Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbaE3DTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 23:19:18 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:38925 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaE3DTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 23:19:17 -0400
Message-ID: <5387F8B2.1070509@kernel.dk>
Date: Thu, 29 May 2014 21:19:14 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] block: virtio_blk: don't hold spin lock during world
 switch
References: <1401418169-3361-1-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1401418169-3361-1-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-29 20:49, Ming Lei wrote:
> Firstly, it isn't necessary to hold lock of vblk->vq_lock
> when notifying hypervisor about queued I/O.
>
> Secondly, virtqueue_notify() will cause world switch and
> it may take long time on some hypervisors(such as, qemu-arm),
> so it isn't good to hold the lock and block other vCPUs.
>
> On arm64 quad core VM(qemu-kvm), the patch can increase I/O
> performance a lot with VIRTIO_RING_F_EVENT_IDX enabled:
> 	- without the patch: 14K IOPS
> 	- with the patch: 34K IOPS

Patch looks good to me. I don't see a hit on my qemu-kvm testing, but it 
definitely makes sense and I can see it hurting in other places.

-- 
Jens Axboe

