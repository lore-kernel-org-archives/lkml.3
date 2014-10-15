Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaJOKVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:21:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbaJOKVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:21:54 -0400
Message-ID: <543E4AB8.6090005@redhat.com>
Date: Wed, 15 Oct 2014 18:21:44 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [RFC PATCH net-next 5/6] virtio-net: enable tx interrupt
References: <1413357930-45302-1-git-send-email-jasowang@redhat.com>	 <1413357930-45302-6-git-send-email-jasowang@redhat.com> <1413365865.12304.55.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1413365865.12304.55.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 05:37 PM, Eric Dumazet wrote:
> On Wed, 2014-10-15 at 15:25 +0800, Jason Wang wrote:
>
> ...
>
>> +static int free_old_xmit_skbs(struct send_queue *sq, int budget)
>> +{
>> +	struct sk_buff *skb;
>> +	unsigned int len;
>> +	struct virtnet_info *vi = sq->vq->vdev->priv;
>> +	struct virtnet_stats *stats = this_cpu_ptr(vi->stats);
>> +	u64 tx_bytes = 0, tx_packets = 0;
>> +
>> +	while (tx_packets < budget &&
>> +	       (skb = virtqueue_get_buf(sq->vq, &len)) != NULL) {
>> +		pr_debug("Sent skb %p\n", skb);
>> +
>> +		tx_bytes += skb->len;
>> +		tx_packets++;
>> +
>> +		dev_kfree_skb_any(skb);
>> +	}
>> +
>> +	u64_stats_update_begin(&stats->tx_syncp);
>> +	stats->tx_bytes += tx_bytes;
>> +	stats->tx_packets =+ tx_packets;
> 	
> 	stats->tx_packets += tx_packets;

My bad, will correct it in next version.

Thanks
