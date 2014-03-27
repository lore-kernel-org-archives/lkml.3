Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbaC0ROQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 13:14:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55463 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbaC0ROO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 13:14:14 -0400
Date: Thu, 27 Mar 2014 13:14:11 -0400 (EDT)
Message-Id: <20140327.131411.1257894502376926151.davem@davemloft.net>
To: jasowang@redhat.com
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, graalfs@linux.vnet.ibm.com
Subject: Re: [PATCH net] virtio-net: correct error handling of
 virtqueue_kick()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395810180-35169-1-git-send-email-jasowang@redhat.com>
References: <1395810180-35169-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Mar 2014 10:14:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed, 26 Mar 2014 13:03:00 +0800

> Current error handling of virtqueue_kick() was wrong in two places:
> - The skb were freed immediately when virtqueue_kick() fail during
>   xmit. This may lead double free since the skb was not detached from
>   the virtqueue.
> - try_fill_recv() returns false when virtqueue_kick() fail. This will
>   lead unnecessary rescheduling of refill work.
> 
> Actually, it's safe to just ignore the kick failure in those two
> places. So this patch fixes this by partially revert commit
> 67975901183799af8e93ec60e322f9e2a1940b9b.
> 
> Fixes 67975901183799af8e93ec60e322f9e2a1940b9b
> (virtio_net: verify if virtqueue_kick() succeeded).
> 
> Cc: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied and queued up for -stable, thanks.
