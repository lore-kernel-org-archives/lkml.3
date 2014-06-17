Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbaFQCk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 22:40:58 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:39555 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbaFQCk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 22:40:57 -0400
MIME-Version: 1.0
In-Reply-To: <1402680562-8328-3-git-send-email-ming.lei@canonical.com>
References: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>
	<1402680562-8328-3-git-send-email-ming.lei@canonical.com>
Date: Tue, 17 Jun 2014 10:40:56 +0800
Message-ID: <CAJSP0QWaS--gPZ=ONFrXby1DQLw4R0RCro7bpHCdmucyjmqT_w@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] block: virtio-blk: support multi virt queues per
 virtio-blk device
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-api@vger.kernel.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 1:29 AM, Ming Lei <ming.lei@canonical.com> wrote:
> Firstly this patch supports more than one virtual queues for virtio-blk
> device.
>
> Secondly this patch maps the virtual queue to blk-mq's hardware queue.
>
> With this approach, both scalability and performance problem can be improved.
>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/block/virtio_blk.c |   75 ++++++++++++++++++++++++++++++++------------
>  1 file changed, 55 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index f63d358..e0d077d 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -16,6 +16,8 @@
>
>  #define PART_BITS 4
>
> +#define MAX_NUM_VQ 16

It would be nice to allocate virtqueues dynamically instead of
hardcoding the limit.  virtio-scsi also allocates virtqueues
dynamically.

Stefan
