Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbaFQAo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:44:27 -0400
Received: from ozlabs.org ([103.22.144.67]:38196 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbaFQAoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:44:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Ming Lei <ming.lei@canonical.com>
Subject: Re: [RFC PATCH 1/2] include/uapi/linux/virtio_blk.h: introduce feature of VIRTIO_BLK_F_MQ
In-Reply-To: <1402680562-8328-2-git-send-email-ming.lei@canonical.com>
References: <1402680562-8328-1-git-send-email-ming.lei@canonical.com> <1402680562-8328-2-git-send-email-ming.lei@canonical.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 16 Jun 2014 22:12:50 +0930
Message-ID: <87a99dnhyt.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <ming.lei@canonical.com> writes:
> Current virtio-blk spec only supports one virtual queue for transfering
> data between VM and host, and inside VM all kinds of operations on
> the virtual queue needs to hold one lock, so cause below problems:
>
> 	- no scalability
>     - bad throughput
>
> So this patch requests to introduce feature of VIRTIO_BLK_F_MQ
> so that more than one virtual queues can be used to virtio-blk
> device, then above problems can be solved or eased.
>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  include/uapi/linux/virtio_blk.h |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/include/uapi/linux/virtio_blk.h b/include/uapi/linux/virtio_blk.h
> index 6d8e61c..c5a2751 100644
> --- a/include/uapi/linux/virtio_blk.h
> +++ b/include/uapi/linux/virtio_blk.h
> @@ -40,6 +40,7 @@
>  #define VIRTIO_BLK_F_WCE	9	/* Writeback mode enabled after reset */
>  #define VIRTIO_BLK_F_TOPOLOGY	10	/* Topology information is available */
>  #define VIRTIO_BLK_F_CONFIG_WCE	11	/* Writeback mode available in config */
> +#define VIRTIO_BLK_F_MQ		12	/* support more than one vq */
>  
>  #ifndef __KERNEL__
>  /* Old (deprecated) name for VIRTIO_BLK_F_WCE. */
> @@ -77,6 +78,9 @@ struct virtio_blk_config {
>  
>  	/* writeback mode (if VIRTIO_BLK_F_CONFIG_WCE) */
>  	__u8 wce;
> +
> +	/* number of vqs, only available when VIRTIO_BLK_F_MQ is set */
> +	__u16 num_queues;
>  } __attribute__((packed));

Hmm, please pad this like so:

        __u8 unused;

        __u16 num_queues;

That avoids weird alignment.

Thanks,
Rusty.
