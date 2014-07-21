Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaGUDPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 23:15:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbaGUDPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 23:15:09 -0400
Message-ID: <53CC85B4.8070203@redhat.com>
Date: Mon, 21 Jul 2014 11:15:00 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V2 0/3] rx busy polling support for virtio-net
References: <1405491707-22706-1-git-send-email-jasowang@redhat.com> <20140720203417.GF2536@redhat.com>
In-Reply-To: <20140720203417.GF2536@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 04:34 AM, Michael S. Tsirkin wrote:
> On Wed, Jul 16, 2014 at 02:21:44PM +0800, Jason Wang wrote:
>> Hi all:
>>
>> This series introduces the support for rx busy polling support. This
>> was useful for reduing the latency for a kvm guest. Patch 1-2
>> introduces helpers which is used for rx busy polling. Patch 3
>> implement the main function.
>>
>> Test was done between a kvm guest and an external host. Two hosts were
>> connected through 40gb mlx4 cards. With both busy_poll and busy_read are
>> set to 50 in guest, 1 byte netperf tcp_rr shows 116% improvement:
>> transaction rate was increased from 9151.94 to 19787.37.
>>
>> Changes from V1:
>> - split the patch info smaller ones
>> - add more details about test setup/configuration
>>
>> Please review.
> Generally I think we should let host know we are polling.
> For example, kick the rq or something. Or maybe add another
> io address.

Yes, I'm also working on busy polling for tun and vhost which may also
help here.
> Something like this would need a new feature flag though, so I'm fine
> with just polling in guest until that is available.

Yes.
>
>> Jason Wang (3):
>>   virtio-net: introduce helpers to enable and disable all NAPIs
>>   virtio-net: introduce virtnet_receive()
>>   virtio-net: rx busy polling support
>>
>>  drivers/net/virtio_net.c | 234 ++++++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 221 insertions(+), 13 deletions(-)
>>
>> -- 
>> 1.8.3.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

