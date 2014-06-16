Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbaFQAo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:44:26 -0400
Received: from ozlabs.org ([103.22.144.67]:43801 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbaFQAoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:44:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Ming Lei <ming.lei@canonical.com>
Subject: Re: [RFC PATCH 2/2] block: virtio-blk: support multi virt queues per virtio-blk device
In-Reply-To: <1402680562-8328-3-git-send-email-ming.lei@canonical.com>
References: <1402680562-8328-1-git-send-email-ming.lei@canonical.com> <1402680562-8328-3-git-send-email-ming.lei@canonical.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 16 Jun 2014 22:17:05 +0930
Message-ID: <877g4hnhrq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <ming.lei@canonical.com> writes:
> +	if (virtio_has_feature(vdev, VIRTIO_BLK_F_MQ))
> +		err = virtio_cread_feature(vdev, VIRTIO_BLK_F_MQ,
> +				   struct virtio_blk_config, num_queues,
> +				   &num_vqs);
> +	else
> +		num_vqs = 1;

This is redundant: virtio_cread_feature() checks the feature.

So, either:
        if (virtio_has_feature(vdev, VIRTIO_BLK_F_MQ))
                virtio_cread(vdev, struct virtio_blk_config, num_queues,
          		     &num_vqs);
        else
                num_vqs = 1;

Or:
	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_MQ,
			   struct virtio_blk_config, num_queues,
			   &num_vqs);
        if (err)
                num_vqs = 1;

Otherwise, the patch looks pretty straight-forward.

Cheers,
Rusty.
