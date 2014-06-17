Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbaFQPxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:53:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401AbaFQPxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:53:34 -0400
Message-ID: <53A06475.7000308@redhat.com>
Date: Tue, 17 Jun 2014 17:53:25 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, Stefan Hajnoczi <stefanha@gmail.com>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-api@vger.kernel.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [RFC PATCH 2/2] block: virtio-blk: support multi virt queues
 per virtio-blk device
References: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>	<1402680562-8328-3-git-send-email-ming.lei@canonical.com>	<CAJSP0QWaS--gPZ=ONFrXby1DQLw4R0RCro7bpHCdmucyjmqT_w@mail.gmail.com> <CACVXFVO0SybUKArQbKkj2+hbk6q_gt3SBooNNmw1jErRR8d07A@mail.gmail.com>
In-Reply-To: <CACVXFVO0SybUKArQbKkj2+hbk6q_gt3SBooNNmw1jErRR8d07A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/06/2014 17:50, Ming Lei ha scritto:
>> > It would be nice to allocate virtqueues dynamically instead of
>> > hardcoding the limit.  virtio-scsi also allocates virtqueues
>> > dynamically.
> virtio-scsi may have lots of LUN, but virtio-blk only has one disk
> which needn't lots of hardware queues.

If you want to do queue steering based on the guest VCPU number, the 
number of queues must be = to the number of VCPUs shouldn't it?

I tried using a divisor of the number of VCPUs, but couldn't get the 
block layer to deliver interrupts to the right VCPU.

Paolo
