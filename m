Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaL1Hwj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 02:52:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaL1Hwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 02:52:36 -0500
Date: Sun, 28 Dec 2014 09:52:26 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Sharing MSIX irq for tx/rx queue pairs
Message-ID: <20141228075226.GA25704@redhat.com>
References: <1419562425-20614-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419562425-20614-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 10:53:42AM +0800, Jason Wang wrote:
> Hi all:
> 
> This series try to share MSIX irq for each tx/rx queue pair. This is
> done through:
> 
> - introducing virtio pci channel which are group of virtqueues that
>   sharing a single MSIX irq (Patch 1)
> - expose channel setting to virtio core api (Patch 2)
> - try to use channel setting in virtio-net (Patch 3)
> 
> For the transport that does not support channel, channel paramters
> were simply ignored. For devices that does not use channel, it can
> simply pass NULL or zero to virito core.
> 
> With the patch, 1 MSIX irq were saved for each TX/RX queue pair.
> 
> Please review.

How does this sharing affect performance?


> Thanks
> 
> Jason Wang (3):
>   virtio-pci: introduce channels
>   virtio: let vp_find_vqs accept channel setting paramters
>   virtio-net: using single MSIX irq for each TX/RX queue pair
> 
>  drivers/block/virtio_blk.c             |   3 +-
>  drivers/char/virtio_console.c          |   3 +-
>  drivers/lguest/lguest_device.c         |   5 +-
>  drivers/misc/mic/card/mic_virtio.c     |   5 +-
>  drivers/net/caif/caif_virtio.c         |   3 +-
>  drivers/net/virtio_net.c               |  26 ++++-
>  drivers/remoteproc/remoteproc_virtio.c |   5 +-
>  drivers/rpmsg/virtio_rpmsg_bus.c       |   3 +-
>  drivers/s390/kvm/kvm_virtio.c          |   5 +-
>  drivers/s390/kvm/virtio_ccw.c          |   5 +-
>  drivers/scsi/virtio_scsi.c             |   3 +-
>  drivers/virtio/virtio_balloon.c        |   3 +-
>  drivers/virtio/virtio_mmio.c           |   5 +-
>  drivers/virtio/virtio_pci_common.c     | 207 ++++++++++++++++++++-------------
>  drivers/virtio/virtio_pci_common.h     |  19 ++-
>  include/linux/virtio_config.h          |   8 +-
>  16 files changed, 208 insertions(+), 100 deletions(-)
> 
> -- 
> 1.8.3.1
