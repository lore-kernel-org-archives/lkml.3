Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaJMGzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 02:55:24 -0400
Received: from ozlabs.org ([103.22.144.67]:52927 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbaJMGyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 02:54:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        linux-s390@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 10/25] virtio: add API to enable VQs early
In-Reply-To: <1413114332-626-11-git-send-email-mst@redhat.com>
References: <1413114332-626-1-git-send-email-mst@redhat.com> <1413114332-626-11-git-send-email-mst@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 13 Oct 2014 17:22:39 +1030
Message-ID: <8738asea14.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> virtio spec 0.9.X requires DRIVER_OK to be set before
> VQs are used, but some drivers use VQs before probe
> function returns.
> Since DRIVER_OK is set after probe, this violates the spec.
>
> Even though under virtio 1.0 transitional devices support this
> behaviour, we want to make it possible for those early callers to become
> spec compliant and eventually support non-transitional devices.
>
> Add API for drivers to call before using VQs.
>
> Sets DRIVER_OK internally.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

OK, this all looks good, but I think we should do two things:

1) rename virtio_enable_vqs_early() to virtio_device_ready().
2) Add a BUG_ON in the virtio_ring code to make sure device is ready
   before any ops are called.

Cheers,
Rusty.
