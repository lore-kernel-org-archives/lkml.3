Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaLANs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:48:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbaLANs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:48:57 -0500
Date: Mon, 1 Dec 2014 15:48:39 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v7 36/46] vhost/net: suppress compiler warning
Message-ID: <20141201134839.GB18305@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
 <1417359787-10138-37-git-send-email-mst@redhat.com>
 <20141201133740.56d7d6d8.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201133740.56d7d6d8.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 01:37:40PM +0100, Cornelia Huck wrote:
> On Sun, 30 Nov 2014 17:12:13 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > len is always initialized since function is called with size > 0.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/vhost/net.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index 984242e..54ffbb0 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -501,7 +501,7 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
> >  	int headcount = 0;
> >  	unsigned d;
> >  	int r, nlogs = 0;
> > -	u32 len;
> > +	u32 uninitialized_var(len);
> > 
> >  	while (datalen > 0 && headcount < quota) {
> >  		if (unlikely(seg >= UIO_MAXIOV)) {
> 
> Want to merge this with the patch introducing the variable and add a
> comment there?

Not really. Warnings in bisect are fine  I think.

-- 
MST
