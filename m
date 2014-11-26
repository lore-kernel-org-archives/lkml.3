Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaKZQ5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:57:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbaKZQ5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:57:33 -0500
Date: Wed, 26 Nov 2014 18:56:53 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, rusty@au1.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        virtualization@lists.linux-foundation.org, linux-s390@vger.kernel.org,
        lguest@lists.ozlabs.org, Pawel Moll <pawel.moll@arm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Arnd Bergmann <arnd@arndb.de>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, pbonzini@redhat.com,
        Brian Swetland <swetland@google.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit.shah@redhat.com>, linux390@de.ibm.com,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH v4 02/42] virtio: add support for 64 bit features.
Message-ID: <20141126165653.GB11202@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
 <1416933600-21398-3-git-send-email-mst@redhat.com>
 <20141126174809.24f6be4d@bahia.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126174809.24f6be4d@bahia.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 05:48:09PM +0100, Greg Kurz wrote:
> On Tue, 25 Nov 2014 18:41:22 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > From: Rusty Russell <rusty@rustcorp.com.au>
> > 
> > Change the u32 to a u64, and make sure to use 1ULL everywhere!
> > 
> > Cc: Brian Swetland <swetland@google.com>
> > Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> > [Thomas Huth: fix up virtio-ccw get_features]
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > Acked-by: Pawel Moll <pawel.moll@arm.com>
> > Acked-by: Ohad Ben-Cohen <ohad@wizery.com>
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

...

> > @@ -86,14 +86,14 @@ static inline bool virtio_has_feature(const struct virtio_device *vdev,
> >  {
> >  	/* Did you forget to fix assumptions on max features? */
> >  	if (__builtin_constant_p(fbit))
> > -		BUILD_BUG_ON(fbit >= 32);
> > +		BUILD_BUG_ON(fbit >= 64);
> 
> 
> While you're here, maybe you could derive the max value from the .features field ?
> 
> -               BUILD_BUG_ON(fbit >= 64);
> +               BUILD_BUG_ON(fbit >= (sizeof(vdev->features) << 3));

I don't see how that will help.
All that 1ULL math only works up to 64 bit.
So this only makes it look like we support any size,
but doesn't really.

No?
