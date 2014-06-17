Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303AbaFQPvC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:51:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50159 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084AbaFQPvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:51:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAJSP0QWaS--gPZ=ONFrXby1DQLw4R0RCro7bpHCdmucyjmqT_w@mail.gmail.com>
References: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>
	<1402680562-8328-3-git-send-email-ming.lei@canonical.com>
	<CAJSP0QWaS--gPZ=ONFrXby1DQLw4R0RCro7bpHCdmucyjmqT_w@mail.gmail.com>
Date: Tue, 17 Jun 2014 23:50:57 +0800
Message-ID: <CACVXFVO0SybUKArQbKkj2+hbk6q_gt3SBooNNmw1jErRR8d07A@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] block: virtio-blk: support multi virt queues per
 virtio-blk device
From: Ming Lei <ming.lei@canonical.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-api@vger.kernel.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 10:40 AM, Stefan Hajnoczi <stefanha@gmail.com> wrote:
> On Sat, Jun 14, 2014 at 1:29 AM, Ming Lei <ming.lei@canonical.com> wrote:
>> Firstly this patch supports more than one virtual queues for virtio-blk
>> device.
>>
>> Secondly this patch maps the virtual queue to blk-mq's hardware queue.
>>
>> With this approach, both scalability and performance problem can be improved.
>>
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>> ---
>>  drivers/block/virtio_blk.c |   75 ++++++++++++++++++++++++++++++++------------
>>  1 file changed, 55 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index f63d358..e0d077d 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -16,6 +16,8 @@
>>
>>  #define PART_BITS 4
>>
>> +#define MAX_NUM_VQ 16
>
> It would be nice to allocate virtqueues dynamically instead of
> hardcoding the limit.  virtio-scsi also allocates virtqueues
> dynamically.

virtio-scsi may have lots of LUN, but virtio-blk only has one disk
which needn't lots of hardware queues.

Also it doesn't matter since it isn't part of ABI.

If change on virtio_blk_config is agreed, both host side and
guest side can choose to support dynamic length or pre-defined
length freely.

Thanks,
--
Ming Lei
