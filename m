Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665AbaFQQAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:00:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50223 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933335AbaFQQAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:00:09 -0400
MIME-Version: 1.0
In-Reply-To: <53A06475.7000308@redhat.com>
References: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>
	<1402680562-8328-3-git-send-email-ming.lei@canonical.com>
	<CAJSP0QWaS--gPZ=ONFrXby1DQLw4R0RCro7bpHCdmucyjmqT_w@mail.gmail.com>
	<CACVXFVO0SybUKArQbKkj2+hbk6q_gt3SBooNNmw1jErRR8d07A@mail.gmail.com>
	<53A06475.7000308@redhat.com>
Date: Wed, 18 Jun 2014 00:00:07 +0800
Message-ID: <CACVXFVO6GDu7Cp=s7kn_XBE2EFnuh+XQs4UQKTFaCLi4_9jcgg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] block: virtio-blk: support multi virt queues per
 virtio-blk device
From: Ming Lei <ming.lei@canonical.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-api@vger.kernel.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 11:53 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 17/06/2014 17:50, Ming Lei ha scritto:
>
>>> > It would be nice to allocate virtqueues dynamically instead of
>>> > hardcoding the limit.  virtio-scsi also allocates virtqueues
>>> > dynamically.
>>
>> virtio-scsi may have lots of LUN, but virtio-blk only has one disk
>> which needn't lots of hardware queues.
>
>
> If you want to do queue steering based on the guest VCPU number, the number
> of queues must be = to the number of VCPUs shouldn't it?
>
> I tried using a divisor of the number of VCPUs, but couldn't get the block
> layer to deliver interrupts to the right VCPU.

For blk-mq's hardware queue, that won't be necessary to equal to
VCPUs number, and irq affinity per hw queue can be simply set as
blk_mq_hw_ctx->cpumask.

Thanks,
--
Ming Lei
