Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbaKYVil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:38:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaKYVik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:38:40 -0500
Date: Tue, 25 Nov 2014 23:38:23 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v4 09/42] virtio: set FEATURES_OK
Message-ID: <20141125213823.GC22343@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
 <1416933600-21398-10-git-send-email-mst@redhat.com>
 <20141125184811.3191f8db.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125184811.3191f8db.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 06:48:11PM +0100, Cornelia Huck wrote:
> On Tue, 25 Nov 2014 18:42:01 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > set FEATURES_OK as per virtio 1.0 spec
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/uapi/linux/virtio_config.h |  2 ++
> >  drivers/virtio/virtio.c            | 29 ++++++++++++++++++++++-------
> >  2 files changed, 24 insertions(+), 7 deletions(-)
> > 
> 
> > +	if (virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> > +		add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
> > +		status = dev->config->get_status(dev);
> > +		if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
> > +			printk(KERN_ERR "virtio: device refuses features: %x\n",
> > +			       status);
> 
> Can you use dev_err() to include the information which device failed?

I'm not sure - is dev_err OK to use from probe?

If yes then sure ...

I guess I'll experiment with this.

> > +			err = -ENODEV;
> > +			goto err;
> > +		}
> > +	}
