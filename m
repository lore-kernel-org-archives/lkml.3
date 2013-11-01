Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab3KAJr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:47:28 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36792 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab3KAJrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:47:24 -0400
Message-ID: <1383299242.19864.4.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next V3 2/2] virtio-net: coalesce rx frags when
 possible during rx
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, edumazet@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com,
        mwdalton@google.com, virtualization@lists.linux-foundation.org,
        kmindg@gmail.com
Date: Fri, 01 Nov 2013 02:47:22 -0700
In-Reply-To: <1383286068-10421-2-git-send-email-jasowang@redhat.com>
References: <1383286068-10421-1-git-send-email-jasowang@redhat.com>
	 <1383286068-10421-2-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-01 at 14:07 +0800, Jason Wang wrote:
> Commit 2613af0ed18a11d5c566a81f9a6510b73180660a (virtio_net: migrate mergeable
> rx buffers to page frag allocators) try to increase the payload/truesize for
> MTU-sized traffic. But this will introduce the extra overhead for GSO packets
> received because of the frag list. This commit tries to reduce this issue by
> coalesce the possible rx frags when possible during rx. Test result shows the
> about 15% improvement on full size GSO packet receiving (and even better than
> before commit 2613af0ed18a11d5c566a81f9a6510b73180660a).
> 
> Before this commit:
> ./netperf -H 192.168.100.4
> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.100.4
> () port 0 AF_INET : demo
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
>  87380  16384  16384    10.00    20303.87
> 
> After this commit:
> ./netperf -H 192.168.100.4
> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.100.4
> () port 0 AF_INET : demo
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
>  87380  16384  16384    10.00    23841.26
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Michael Dalton <mwdalton@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes from V2:
> - call put_page() instead of depending on skb_coalesce_rx_frag()
> ---

Yes, very nice improvement, thanks again !

Acked-by: Eric Dumazet <edumazet@google.com>


