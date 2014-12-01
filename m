Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaLAMuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:50:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbaLAMuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:50:15 -0500
Date: Mon, 1 Dec 2014 14:49:57 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v7 31/46] vhost: virtio 1.0 endian-ness support
Message-ID: <20141201124957.GA18106@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
 <1417359787-10138-32-git-send-email-mst@redhat.com>
 <20141201133353.0bbaa2e1.cornelia.huck@de.ibm.com>
 <20141201123701.GB17958@redhat.com>
 <20141201134247.55e68161.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201134247.55e68161.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 01:42:47PM +0100, Cornelia Huck wrote:
> On Mon, 1 Dec 2014 14:37:01 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > On Mon, Dec 01, 2014 at 01:33:53PM +0100, Cornelia Huck wrote:
> > > On Sun, 30 Nov 2014 17:11:49 +0200
> > > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > 
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > ---
> > > >  drivers/vhost/vhost.c | 93 +++++++++++++++++++++++++++++++--------------------
> > > >  1 file changed, 56 insertions(+), 37 deletions(-)
> > > > 
> > > 
> > > > @@ -1113,18 +1120,19 @@ static int get_indirect(struct vhost_virtqueue *vq,
> > > >  {
> > > >  	struct vring_desc desc;
> > > >  	unsigned int i = 0, count, found = 0;
> > > > +	u32 len = vhost32_to_cpu(vq, indirect->len);
> > > >  	int ret;
> > > > 
> > > >  	/* Sanity check */
> > > > -	if (unlikely(indirect->len % sizeof desc)) {
> > > > +	if (unlikely(len % sizeof desc)) {
> > > >  		vq_err(vq, "Invalid length in indirect descriptor: "
> > > >  		       "len 0x%llx not multiple of 0x%zx\n",
> > > > -		       (unsigned long long)indirect->len,
> > > > +		       (unsigned long long)vhost32_to_cpu(vq, indirect->len),
> > > 
> > > Can't you use len here?
> > 
> > Not if I want error message to be readable.
> 
> Huh? Both have the same value.

Ah, good point.
