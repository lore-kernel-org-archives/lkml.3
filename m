Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaLAIQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:16:50 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:34756 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbaLAIQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:16:48 -0500
Date: Mon, 1 Dec 2014 09:16:41 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org,
        pbonzini@redhat.com, thuth@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v7 16/46] virtio_blk: v1.0 support
Message-ID: <20141201091641.3085e682@thinkpad-w530>
In-Reply-To: <1417359787-10138-17-git-send-email-mst@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-17-git-send-email-mst@redhat.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120108-0017-0000-0000-000002090B60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Based on patch by Cornelia Huck.
> 
> Note: for consistency, and to avoid sparse errors,
>       convert all fields, even those no longer in use
>       for virtio v1.0.
> 
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
...
> 
> -static unsigned int features[] = {
> +static unsigned int features_legacy[] = {
>  	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
>  	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE, VIRTIO_BLK_F_SCSI,
>  	VIRTIO_BLK_F_WCE, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE,
>  	VIRTIO_BLK_F_MQ,
> +}
> +;
> +static unsigned int features[] = {
> +	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
> +	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
> +	VIRTIO_BLK_F_TOPOLOGY,
> +	VIRTIO_BLK_F_MQ,
> +	VIRTIO_F_VERSION_1,

We can fit this into less lines, like done for features_legacy.

I was asking myself if we could do the conversion of the statical values
somehow upfront, to reduce the patch size and avoid cpu_to_virtio.* at those
places.

Otherwise looks good to me.


