Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaJFPX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:23:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbaJFPX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:23:27 -0400
Date: Mon, 6 Oct 2014 18:26:55 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 03/15] virtio-pci: move freeze/restore to virtio core
Message-ID: <20141006152655.GA32277@redhat.com>
References: <1412608214-31944-1-git-send-email-mst@redhat.com>
 <1412608214-31944-4-git-send-email-mst@redhat.com>
 <20141006172055.6fd0fa20.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006172055.6fd0fa20.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 05:20:55PM +0200, Cornelia Huck wrote:
> On Mon, 6 Oct 2014 18:10:51 +0300
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > This is in preparation to extending config changed event handling
> > in core.
> > Wrapping these in an API also seems to make for a cleaner code.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/linux/virtio.h      |  6 +++++
> >  drivers/virtio/virtio.c     | 53 +++++++++++++++++++++++++++++++++++++++++++
> >  drivers/virtio/virtio_pci.c | 55 ++-------------------------------------------
> >  3 files changed, 61 insertions(+), 53 deletions(-)
> > 
> > diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> > index 3c19bd3..8df7ba8 100644
> > --- a/include/linux/virtio.h
> > +++ b/include/linux/virtio.h
> > @@ -78,6 +78,7 @@ bool virtqueue_is_broken(struct virtqueue *vq);
> >  /**
> >   * virtio_device - representation of a device using virtio
> >   * @index: unique position on the virtio bus
> > + * @failed: saved value for CONFIG_S_FAILED bit (for restore)
> 
> Have you considered s/failed/saved_failed/ ?

I kind of prefer the shorter name, your reviewed tag made me think
you don't cosider this too important?

> >   * @dev: underlying device.
> >   * @id: the device type identification (used to match it with a driver).
> >   * @config: the configuration ops for this device.
> 
> Otherwise, my
> 
> Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> 
> still stands.
