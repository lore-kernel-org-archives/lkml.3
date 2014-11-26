Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaKZOFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:05:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbaKZOFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:05:53 -0500
Date: Wed, 26 Nov 2014 16:05:39 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 25/42] vhost: add memory access wrappers
Message-ID: <20141126140539.GA5528@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
 <1416933600-21398-26-git-send-email-mst@redhat.com>
 <20141126145438.4421c00d.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126145438.4421c00d.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 02:54:38PM +0100, Cornelia Huck wrote:
> On Tue, 25 Nov 2014 18:43:10 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> "These wrappers are needed to handle virtio endianness conversions."
> 
> ?

yes, it's same as virtio ones. I'll add this text, thanks.

> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/vhost/vhost.h | 33 ++++++++++++++++++++++++++++++++-
> >  1 file changed, 32 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index 3eda654..b9032e8 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -174,6 +174,37 @@ enum {
> > 
> >  static inline int vhost_has_feature(struct vhost_virtqueue *vq, int bit)
> >  {
> > -	return vq->acked_features & (1 << bit);
> > +	return vq->acked_features & (1ULL << bit);
> 
> Should this hunk go into patch 28?

Well, this is needed here since 1 << 32 is not legal C.

I can move it - this means patch 28 will have to move earlier
in series though.



> > +}
