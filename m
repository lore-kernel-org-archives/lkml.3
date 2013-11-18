Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab3KRKHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 05:07:53 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:61612 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3KRKHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 05:07:45 -0500
MIME-Version: 1.0
In-Reply-To: <20131118095043.GA3470@redhat.com>
References: <1384764380-16832-1-git-send-email-zwu.kernel@gmail.com>
	<20131118095043.GA3470@redhat.com>
Date: Mon, 18 Nov 2013 18:07:45 +0800
Message-ID: <CAEH94Ljbu-gJ3SCHYErNEPucV=rR9PHz5COrOp3B-iw+db=LDQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] net, virtio_net: replace the magic value
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 5:50 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Mon, Nov 18, 2013 at 04:46:20PM +0800, Zhi Yong Wu wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> It is more appropriate to use # of queue pairs currently used by
>> the driver instead of a magic value.
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
> I don't mind, but driver should be submitted separately
> from qemu patches. As it is only patch 4/4 made it to netdev.
ok, i will sent v2. By the way, can you help take a look at the
following patches? Maybe i can send their v2 together.
[PATCH 1/3] vhost: remove the dead branch
[PATCH 2/3] vhost: adjust vhost_dev_init() to be void
[PATCH 3/3] vhost: fix the wrong log descriptions


>
>> ---
>>  drivers/net/virtio_net.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index cdc7c90..e0cb2d1 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -1619,8 +1619,8 @@ static int virtnet_probe(struct virtio_device *vdev)
>>       if (err)
>>               goto free_stats;
>>
>> -     netif_set_real_num_tx_queues(dev, 1);
>> -     netif_set_real_num_rx_queues(dev, 1);
>> +     netif_set_real_num_tx_queues(dev, vi->curr_queue_pairs);
>> +     netif_set_real_num_rx_queues(dev, vi->curr_queue_pairs);
>>
>>       err = register_netdev(dev);
>>       if (err) {
>> --
>> 1.7.6.5
>>



-- 
Regards,

Zhi Yong Wu
