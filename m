Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbaJXKEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:04:23 -0400
Received: from mx0.aculab.com ([213.249.233.131]:53305 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751751AbaJXKEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:04:22 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Michael S. Tsirkin'" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "cornelia.huck@de.ibm.com" <cornelia.huck@de.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH RFC 1/4] virtio_net: pass vi around
Thread-Topic: [PATCH RFC 1/4] virtio_net: pass vi around
Thread-Index: AQHP7wd+TdJMgeK6ik+HuyFC2fd60pw/BFxA
Date: Fri, 24 Oct 2014 10:02:15 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1C9DE6C2@AcuExch.aculab.com>
References: <1414099656-28090-1-git-send-email-mst@redhat.com>
In-Reply-To: <1414099656-28090-1-git-send-email-mst@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael S. Tsirkin
 
> Too many places poke at [rs]q->vq->vdev->priv just to get
> the the vi structure.  Let's just pass the pointer around: seems
> cleaner, and might even be faster.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/net/virtio_net.c | 36 +++++++++++++++++++-----------------
>  1 file changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 57cbc7d..36f3dfc 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
...
>  static struct sk_buff *receive_big(struct net_device *dev,
> +				   struct virtnet_info *vi,

Do you need to pass 'dev' here?
Looks like it is obtainable from vi->dev (as below).

	David

>  				   struct receive_queue *rq,
>  				   void *buf,
>  				   unsigned int len)
>  {
>  	struct page *page = buf;
> -	struct sk_buff *skb = page_to_skb(rq, page, 0, len, PAGE_SIZE);
> +	struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len, PAGE_SIZE);
...
> -static void receive_buf(struct receive_queue *rq, void *buf, unsigned int len)
> +static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
> +			void *buf, unsigned int len)
>  {
> -	struct virtnet_info *vi = rq->vq->vdev->priv;
>  	struct net_device *dev = vi->dev;
...


