Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaK2Re6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 12:34:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaK2Re4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 12:34:56 -0500
Date: Sat, 29 Nov 2014 19:34:12 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit.shah@redhat.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        virtualization@lists.linux-foundation.org, lguest@lists.ozlabs.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v6 02/46] virtio: use u32, not bitmap for features
Message-ID: <20141129173412.GH22746@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
 <1417118789-18231-3-git-send-email-mst@redhat.com>
 <20141128134457.37e427ce.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141128134457.37e427ce.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 01:44:57PM +0100, Cornelia Huck wrote:
> On Thu, 27 Nov 2014 22:07:41 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > It seemed like a good idea to use bitmap for features
> > in struct virtio_device, but it's actually a pain,
> > and seems to become even more painful when we get more
> > than 32 feature bits.  Just change it to a u32 for now.
> > 
> > Based on patch by Rusty.
> > 
> > Suggested-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> > diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> > index d34ebfa..ab95a4c 100644
> > --- a/drivers/virtio/virtio_pci.c
> > +++ b/drivers/virtio/virtio_pci.c
> > @@ -120,8 +120,7 @@ static void vp_finalize_features(struct virtio_device *vdev)
> >  	vring_transport_features(vdev);
> > 
> >  	/* We only support 32 feature bits. */
> 
> I think you can kill this comment...

Why? It's still true for virtio pci at this point, that's why we
just do iowrite32 here.

> > -	BUILD_BUG_ON(ARRAY_SIZE(vdev->features) != 1);
> > -	iowrite32(vdev->features[0], vp_dev->ioaddr+VIRTIO_PCI_GUEST_FEATURES);
> > +	iowrite32(vdev->features, vp_dev->ioaddr+VIRTIO_PCI_GUEST_FEATURES);
> 
> ...and add blanks around '+', as you're touching this line anyway.
> 
> >  }
> > 
> >  /* virtio config->get() implementation */
> 
> Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
