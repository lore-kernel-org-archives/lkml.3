Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3KEBEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 20:04:42 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55867 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab3KEBEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 20:04:40 -0500
Date: Mon, 04 Nov 2013 20:04:38 -0500 (EST)
Message-Id: <20131104.200438.1658727667787717171.davem@davemloft.net>
To: jasowang@redhat.com
Cc: edumazet@google.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, mst@redhat.com, mwdalton@google.com,
        virtualization@lists.linux-foundation.org, kmindg@gmail.com
Subject: Re: [PATCH net-next V3 2/2] virtio-net: coalesce rx frags when
 possible during rx
From: David Miller <davem@davemloft.net>
In-Reply-To: <1383286068-10421-2-git-send-email-jasowang@redhat.com>
References: <1383286068-10421-1-git-send-email-jasowang@redhat.com>
	<1383286068-10421-2-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 04 Nov 2013 17:04:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri,  1 Nov 2013 14:07:48 +0800

> Commit 2613af0ed18a11d5c566a81f9a6510b73180660a (virtio_net: migrate mergeable
> rx buffers to page frag allocators) try to increase the payload/truesize for
> MTU-sized traffic. But this will introduce the extra overhead for GSO packets
> received because of the frag list. This commit tries to reduce this issue by
> coalesce the possible rx frags when possible during rx. Test result shows the
> about 15% improvement on full size GSO packet receiving (and even better than
> before commit 2613af0ed18a11d5c566a81f9a6510b73180660a).
...
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

Looks fantastic, applied, thanks Jason!
