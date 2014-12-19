Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaLUWb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 17:31:58 -0500
Received: from ozlabs.org ([103.22.144.67]:46823 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbaLUWb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 17:31:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 6/6] virtio: core support for config generation
In-Reply-To: <1418678575-31755-7-git-send-email-mst@redhat.com>
References: <1418678575-31755-1-git-send-email-mst@redhat.com> <1418678575-31755-7-git-send-email-mst@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 19 Dec 2014 13:31:53 +1030
Message-ID: <87mw6ks5pa.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> virtio 1.0 spec says:
>
> Drivers MUST NOT assume reads from fields greater than 32 bits wide are
> atomic, nor are reads from multiple fields: drivers SHOULD read device
> configuration space fields like so:
> 	u32 before, after;
> 	do {
> 		before = get_config_generation(device);
> 		// read config entry/entries.
> 		after = get_config_generation(device);
> 	} while (after != before);
>
> Do exactly this, for transports that support it.

>  static inline void virtio_cwrite8(struct virtio_device *vdev,
> @@ -352,6 +375,7 @@ static inline u64 virtio_cread64(struct virtio_device *vdev,
>  {
>  	u64 ret;
>  	vdev->config->get(vdev, offset, &ret, sizeof(ret));
> +	__virtio_cread_many(vdev, offset, &ret, 1, sizeof(ret));
>  	return virtio64_to_cpu(vdev, (__force __virtio64)ret);
>  }

The "vdev->config->get(vdev, offset, &ret, sizeof(ret));" should
be deleted.  Harmless if not, though.

Cheers,
Rusty.
