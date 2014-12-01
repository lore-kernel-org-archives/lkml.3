Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaLAJ3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:29:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbaLAJ3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:29:11 -0500
Date: Mon, 1 Dec 2014 11:28:50 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org,
        pbonzini@redhat.com, thuth@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v7 16/46] virtio_blk: v1.0 support
Message-ID: <20141201092850.GD15607@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
 <1417359787-10138-17-git-send-email-mst@redhat.com>
 <20141201091641.3085e682@thinkpad-w530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201091641.3085e682@thinkpad-w530>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 09:16:41AM +0100, David Hildenbrand wrote:
> > Based on patch by Cornelia Huck.
> > 
> > Note: for consistency, and to avoid sparse errors,
> >       convert all fields, even those no longer in use
> >       for virtio v1.0.
> > 
> > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ...
> > 
> > -static unsigned int features[] = {
> > +static unsigned int features_legacy[] = {
> >  	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
> >  	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE, VIRTIO_BLK_F_SCSI,
> >  	VIRTIO_BLK_F_WCE, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE,
> >  	VIRTIO_BLK_F_MQ,
> > +}
> > +;
> > +static unsigned int features[] = {
> > +	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
> > +	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
> > +	VIRTIO_BLK_F_TOPOLOGY,
> > +	VIRTIO_BLK_F_MQ,
> > +	VIRTIO_F_VERSION_1,
> 
> We can fit this into less lines, like done for features_legacy.

Wrt packing code more tightly, I did it like this to
make it easier to compare the arrays.
Each flag is on the same line in original and new array.

> I was asking myself if we could do the conversion of the statical values
> somehow upfront, to reduce the patch size and avoid cpu_to_virtio.* at those
> places.
> 
> Otherwise looks good to me.
> 
