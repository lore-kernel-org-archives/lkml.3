Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaKXTMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:12:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbaKXTMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:12:19 -0500
Date: Mon, 24 Nov 2014 21:12:05 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 00/41] linux: towards virtio-1 guest support
Message-ID: <20141124191205.GA8049@redhat.com>
References: <1416829787-14252-1-git-send-email-mst@redhat.com>
 <20141124194831.252318e4.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124194831.252318e4.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 07:48:31PM +0100, Cornelia Huck wrote:
> On Mon, 24 Nov 2014 13:52:32 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > Based on patches by Cornelia Rusty and others, but
> > with an API that should allow better static checking of code,
> > and slightly more concervative changes in vring,net and blk.
> > 
> > Based on patches by Cornelia and others, but
> > with an API that should allow better static checking of code,
> > slightly more concervative changes in vring and drivers,
> > and compatibility for existing drivers so that
> > this series be applied before all drivers are converted.
> > 
> > virtio net,blk and scsi drivers have been converted.
> > They now pass sparse without warnings.
> > 
> > net and blk patches have been tested on s390.
> 
> vring_transport_features() seems to knock off the version 1 bit (I
> wonder why I did not see that before, maybe VIRTIO_TRANSPORT_F_END had
> not been increased before?). If I add VIRTIO_F_VERSION_1 in this
> function, virtio-net and virtio-blk seem to work fine with version 1 on
> virtio-ccw (tested with my old virtio-1 qemu branch).

What if we just move VIRTIO_TRANSPORT_F_END back for now?
Does patch below fix it for you?

> I'll try to do a bit of reviewing tomorrow.

BTW could you post your latest qemu bits please?



diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index a6d0cde..0071de9 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -47,7 +47,7 @@
  * transport being used (eg. virtio_ring), the rest are per-device feature
  * bits. */
 #define VIRTIO_TRANSPORT_F_START	28
-#define VIRTIO_TRANSPORT_F_END		33
+#define VIRTIO_TRANSPORT_F_END		32
 
 /* Do we get callbacks when the ring is completely used, even if we've
  * suppressed them? */
-- 
MST
