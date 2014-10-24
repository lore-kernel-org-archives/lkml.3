Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbaJXOHC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:07:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbaJXOHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:07:00 -0400
Date: Fri, 24 Oct 2014 17:10:23 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cornelia.huck@de.ibm.com" <cornelia.huck@de.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC 1/4] virtio_net: pass vi around
Message-ID: <20141024141023.GA7939@redhat.com>
References: <1414099656-28090-1-git-send-email-mst@redhat.com>
 <063D6719AE5E284EB5DD2968C1650D6D1C9DE6C2@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1C9DE6C2@AcuExch.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 10:02:15AM +0000, David Laight wrote:
> From: Michael S. Tsirkin
>  
> > Too many places poke at [rs]q->vq->vdev->priv just to get
> > the the vi structure.  Let's just pass the pointer around: seems
> > cleaner, and might even be faster.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/net/virtio_net.c | 36 +++++++++++++++++++-----------------
> >  1 file changed, 19 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 57cbc7d..36f3dfc 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> ...
> >  static struct sk_buff *receive_big(struct net_device *dev,
> > +				   struct virtnet_info *vi,
> 
> Do you need to pass 'dev' here?
> Looks like it is obtainable from vi->dev (as below).
> 
> 	David
> 
> >  				   struct receive_queue *rq,
> >  				   void *buf,
> >  				   unsigned int len)
> >  {
> >  	struct page *page = buf;
> > -	struct sk_buff *skb = page_to_skb(rq, page, 0, len, PAGE_SIZE);
> > +	struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len, PAGE_SIZE);
> ...
> > -static void receive_buf(struct receive_queue *rq, void *buf, unsigned int len)
> > +static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
> > +			void *buf, unsigned int len)
> >  {
> > -	struct virtnet_info *vi = rq->vq->vdev->priv;
> >  	struct net_device *dev = vi->dev;
> ...

It's a matter of style, isn't it?
We have dev to hand, it seems cleaner to just pass it around.

-- 
MST
