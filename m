Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965566AbaFQQe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:34:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965552AbaFQQeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:34:23 -0400
Message-ID: <53A06E05.9060708@redhat.com>
Date: Tue, 17 Jun 2014 18:34:13 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Stefan Hajnoczi <stefanha@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-api@vger.kernel.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [RFC PATCH 2/2] block: virtio-blk: support multi virt queues
 per virtio-blk device
References: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>	<1402680562-8328-3-git-send-email-ming.lei@canonical.com>	<CAJSP0QWaS--gPZ=ONFrXby1DQLw4R0RCro7bpHCdmucyjmqT_w@mail.gmail.com>	<CACVXFVO0SybUKArQbKkj2+hbk6q_gt3SBooNNmw1jErRR8d07A@mail.gmail.com>	<53A06475.7000308@redhat.com> <CACVXFVO6GDu7Cp=s7kn_XBE2EFnuh+XQs4UQKTFaCLi4_9jcgg@mail.gmail.com>
In-Reply-To: <CACVXFVO6GDu7Cp=s7kn_XBE2EFnuh+XQs4UQKTFaCLi4_9jcgg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/06/2014 18:00, Ming Lei ha scritto:
>> > If you want to do queue steering based on the guest VCPU number, the number
>> > of queues must be = to the number of VCPUs shouldn't it?
>> >
>> > I tried using a divisor of the number of VCPUs, but couldn't get the block
>> > layer to deliver interrupts to the right VCPU.
> For blk-mq's hardware queue, that won't be necessary to equal to
> VCPUs number, and irq affinity per hw queue can be simply set as
> blk_mq_hw_ctx->cpumask.

Yes, but on top of that you want to have each request processed exactly 
by the CPU that sent it.  Unless the cpumasks are singletons, most of 
the benefit went away in my virtio-scsi tests.  Perhaps blk-mq is smarter.

Can you try benchmarking a 16 VCPU guest with 8 and 16 queues?

Paolo
