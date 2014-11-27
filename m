Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbaK0KzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:55:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbaK0KzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:55:10 -0500
Date: Thu, 27 Nov 2014 12:54:34 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Pawel Moll <pawel.moll@arm.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>, lguest@lists.ozlabs.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 04/42] virtio: disable virtio 1.0 in transports
Message-ID: <20141127105434.GA10037@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
 <1416933600-21398-5-git-send-email-mst@redhat.com>
 <20141125182942.3890fe7b.cornelia.huck@de.ibm.com>
 <20141125212011.GA22343@redhat.com>
 <20141126100954.3811e594.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126100954.3811e594.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 10:09:54AM +0100, Cornelia Huck wrote:
> On Tue, 25 Nov 2014 23:20:11 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > On Tue, Nov 25, 2014 at 06:29:42PM +0100, Cornelia Huck wrote:
> > > On Tue, 25 Nov 2014 18:41:35 +0200
> > > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > 
> > > > disable virtio 1.0 in transports that don't
> > > > support it yet.
> > > 
> > > I'd prefer if you disabled it for _every_ transport in this patch,
> > > until the needed infrastructure is in place. Else this is a bit
> > > confusing.
> > 
> > Well the only transports left are pci and rpoc, and these only
> > read the low 32 bit of the features from the device -
> > so there's nothing to clear.
> > 
> > E.g. the following would be even more confusing, would it not:
> > 
> > 	u32 features;
> > 	....
> > 	features &= ~BIT_ULL(VIRTIO_F_VERSION_1);
> > 
> > Agree?
> 
> Maybe you should tweak the patch description a bit and mention that you
> only disable virtio 1.0 for transports where it is actually needed?
> 
> (...)

Yes, I did that now.

> > > FWIW, as negotiating a revision >= 1 is a pre-req for virtio 1.0
> > > support on ccw, virtio 1.0 is already implicitly disabled.
> > 
> > Ah, you mean device guarantees that VIRTIO_F_VERSION_1 isn't set
> > if guest sets revision to 0?
> 
> Yes, the bit will not be offered if the revision is 0 or has not been
> set at all.
> 
> > In that case it's probably best to drop this from both ccw
> > devices.
> 
> There's only one ccw transport :)
> 
> The old s390 virtio transport in kvm_virtio.c is not part of virtio 1.0.

It might or might not be a good idea to add code in kvm_virtio.c
blacklisting VIRTIO_F_VERSION_1, just in case there's a buggy device
that sets it.
As correct devices won't set it, I don't think we need to
worry about it too much. We can make it a patch on top later
if we want.

-- 
MST
