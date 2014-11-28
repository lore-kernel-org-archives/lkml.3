Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbaK1MpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 07:45:09 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:49656 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaK1MpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 07:45:06 -0500
Date: Fri, 28 Nov 2014 13:44:57 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
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
Message-ID: <20141128134457.37e427ce.cornelia.huck@de.ibm.com>
In-Reply-To: <1417118789-18231-3-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
	<1417118789-18231-3-git-send-email-mst@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112812-0029-0000-0000-000001EB6957
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014 22:07:41 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> It seemed like a good idea to use bitmap for features
> in struct virtio_device, but it's actually a pain,
> and seems to become even more painful when we get more
> than 32 feature bits.  Just change it to a u32 for now.
> 
> Based on patch by Rusty.
> 
> Suggested-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> index d34ebfa..ab95a4c 100644
> --- a/drivers/virtio/virtio_pci.c
> +++ b/drivers/virtio/virtio_pci.c
> @@ -120,8 +120,7 @@ static void vp_finalize_features(struct virtio_device *vdev)
>  	vring_transport_features(vdev);
> 
>  	/* We only support 32 feature bits. */

I think you can kill this comment...

> -	BUILD_BUG_ON(ARRAY_SIZE(vdev->features) != 1);
> -	iowrite32(vdev->features[0], vp_dev->ioaddr+VIRTIO_PCI_GUEST_FEATURES);
> +	iowrite32(vdev->features, vp_dev->ioaddr+VIRTIO_PCI_GUEST_FEATURES);

...and add blanks around '+', as you're touching this line anyway.

>  }
> 
>  /* virtio config->get() implementation */

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

