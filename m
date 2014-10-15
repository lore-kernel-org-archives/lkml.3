Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaJOHFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 03:05:20 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:55369 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775AbaJOHFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:05:18 -0400
Message-ID: <1413356714.27272.3.camel@x220>
Subject: Re: [PATCH v4 03/25] virtio-pci: move freeze/restore to virtio core
From: Paul Bolle <pebolle@tiscali.nl>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        linux-s390@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>
Date: Wed, 15 Oct 2014 09:05:14 +0200
In-Reply-To: <1413114332-626-4-git-send-email-mst-v4@redhat.com>
References: <1413114332-626-1-git-send-email-mst-v4@redhat.com>
	 <1413114332-626-4-git-send-email-mst-v4@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2014 07:05:14.0451 (UTC) FILETIME=[5E4D4230:01CFE846]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 10:48 +0300, Michael S. Tsirkin wrote:
> This is in preparation to extending config changed event handling
> in core.
> Wrapping these in an API also seems to make for a cleaner code.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

This patch landed in today's linux-next (next-20141015).

>  include/linux/virtio.h      |  6 +++++
>  drivers/virtio/virtio.c     | 54 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/virtio/virtio_pci.c | 54 ++-------------------------------------------
>  3 files changed, 62 insertions(+), 52 deletions(-)
> 
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 3c19bd3..8df7ba8 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -78,6 +78,7 @@ bool virtqueue_is_broken(struct virtqueue *vq);
>  /**
>   * virtio_device - representation of a device using virtio
>   * @index: unique position on the virtio bus
> + * @failed: saved value for CONFIG_S_FAILED bit (for restore)

s/CONFIG_S_FAILED/VIRTIO_CONFIG_S_FAILED/?

>   * @dev: underlying device.
>   * @id: the device type identification (used to match it with a driver).
>   * @config: the configuration ops for this device.


Paul Bolle

