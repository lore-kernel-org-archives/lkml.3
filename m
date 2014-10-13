Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaJMHck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:32:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaJMHce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:32:34 -0400
Date: Mon, 13 Oct 2014 10:35:44 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Amit Shah <amit.shah@redhat.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 10/25] virtio: add API to enable VQs early
Message-ID: <20141013073544.GA10433@redhat.com>
References: <1413114332-626-1-git-send-email-mst@redhat.com>
 <1413114332-626-11-git-send-email-mst@redhat.com>
 <8738asea14.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738asea14.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 05:22:39PM +1030, Rusty Russell wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> > virtio spec 0.9.X requires DRIVER_OK to be set before
> > VQs are used, but some drivers use VQs before probe
> > function returns.
> > Since DRIVER_OK is set after probe, this violates the spec.
> >
> > Even though under virtio 1.0 transitional devices support this
> > behaviour, we want to make it possible for those early callers to become
> > spec compliant and eventually support non-transitional devices.
> >
> > Add API for drivers to call before using VQs.
> >
> > Sets DRIVER_OK internally.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> 
> OK, this all looks good, but I think we should do two things:
> 
> 1) rename virtio_enable_vqs_early() to virtio_device_ready().

I considered this, I was concerned that the usage isn't clear from name:
- this has to be called before VQs are used
- this is optional, happens automatically after probe

device_ready seems to imply driver is fully initialized,
if it was it could just call probe.

But it's easy enough to make the change, so I'll go ahead and
post V4. It will be up to you which one to apply then.

> 2) Add a BUG_ON in the virtio_ring code to make sure device is ready
>    before any ops are called.
> 
> Cheers,
> Rusty.

On kick? This seems too expensive, especially considering that
we don't track the status.

Anyway, can be a patch on top?

-- 
MST
