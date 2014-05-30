Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaE3HAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:00:47 -0400
Received: from ozlabs.org ([103.22.144.67]:40017 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbaE3HAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:00:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] block: virtio_blk: don't hold spin lock during world switch
In-Reply-To: <1401418169-3361-1-git-send-email-ming.lei@canonical.com>
References: <1401418169-3361-1-git-send-email-ming.lei@canonical.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 30 May 2014 15:35:41 +0930
Message-ID: <87a99z7qdm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <ming.lei@canonical.com> writes:
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
>
> fio script:
> 	[global]
> 	direct=1
> 	bsrange=4k-4k
> 	timeout=10
> 	numjobs=4
> 	ioengine=libaio
> 	iodepth=64
>
> 	filename=/dev/vdc
> 	group_reporting=1
>
> 	[f1]
> 	rw=randread
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
