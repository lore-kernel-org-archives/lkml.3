Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaFMRfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:35:17 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49309 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaFMRfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:35:15 -0400
Message-ID: <539B3653.6040408@kernel.dk>
Date: Fri, 13 Jun 2014 11:35:15 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-api@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 0/2] block: virtio-blk: support multi vq per virtio-blk
References: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 11:29 AM, Ming Lei wrote:
> Hi,
> 
> This patches try to support multi virtual queues(multi-vq) in one
> virtio-blk device, and maps each virtual queue(vq) to blk-mq's
> hardware queue.
> 
> With this approach, both scalability and performance problems on
> virtio-blk device get improved.
> 
> For verifying the improvement, I implements virtio-blk multi-vq over
> qemu's dataplane feature, and both handling host notification
> from each vq and processing host I/O are still kept in the per-device
> iothread context, the changes are based on qemu v2.0.0 release, and
> can be accessed from below tree:
> 
> 	git://kernel.ubuntu.com/ming/qemu.git #v2.0.0-virtblk-dataplane-mq
> 
> For enabling the multi-vq feature, 'num_queues=N' need to be added into
> '-device virtio-blk-pci ...' of qemu command line, and suggest to pass
> 'vectors=N+1' to keep one MSI irq vector per each vq, and the feature
> depends on x-data-plane.
> 
> Fio(libaio, randread, iodepth=64, bs=4K, jobs=N) is run inside VM to
> verify the improvement.
> 
> I just create a small quadcore VM and run fio inside the VM, and
> num_queues of the virtio-blk device is set as 2, but looks the
> improvement is still obvious.
> 
> 1), about scalability
> - without mutli-vq feature
> 	-- jobs=2, thoughput: 145K iops
> 	-- jobs=4, thoughput: 100K iops
> - without mutli-vq feature
> 	-- jobs=2, thoughput: 186K iops
> 	-- jobs=4, thoughput: 199K iops

Awesome! I was hoping someone would do that, and make virtio-blk take
full advantage of blk-mq.

-- 
Jens Axboe

