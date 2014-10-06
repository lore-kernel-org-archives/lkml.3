Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaJFLxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 07:53:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbaJFLxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 07:53:12 -0400
Date: Mon, 6 Oct 2014 14:56:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 09/16] virtio-net: drop config_mutex
Message-ID: <20141006115636.GA26184@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
 <1412525038-15871-10-git-send-email-mst@redhat.com>
 <54328107.5090400@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54328107.5090400@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 03:46:15PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 10/5/2014 8:07 PM, Michael S. Tsirkin wrote:
> 
> >config_mutex served two purposes: prevent multiple concurrent config
> >change handlers, and synchronize access to config_enable flag.
> 
> >Since commit dbf2576e37da0fcc7aacbfbb9fd5d3de7888a3c1
> >     workqueue: make all workqueues non-reentrant
> >all workqueues are non-reentrant, and config_enable
> >is now gone.
> 
> >Get rid of the unnecessary lock.
> 
> >Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >---
> >  drivers/net/virtio_net.c | 7 +------
> >  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> >diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >index fa17afa..d80fef4 100644
> >--- a/drivers/net/virtio_net.c
> >+++ b/drivers/net/virtio_net.c
> [...]
> >@@ -1430,7 +1426,7 @@ static void virtnet_config_changed_work(struct work_struct *work)
> >  		netif_tx_stop_all_queues(vi->dev);
> >  	}
> >  done:
> >-	mutex_unlock(&vi->config_lock);
> >+	return;
> 
>    There's no need for this *return*.
>

I know - it's removed by the follow-up patch.
It's formatted like this to make diff smaller
and make review easier.
 
> >  }
> >
> >  static void virtnet_config_changed(struct virtio_device *vdev)
> 
> WBR, Sergei
