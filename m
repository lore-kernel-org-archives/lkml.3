Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbaJXCNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 22:13:05 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:42944 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaJXCND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 22:13:03 -0400
MIME-Version: 1.0
In-Reply-To: <1414080703-4547-1-git-send-email-mst@redhat.com>
References: <1414080703-4547-1-git-send-email-mst@redhat.com>
Date: Fri, 24 Oct 2014 10:13:01 +0800
Message-ID: <CACVXFVMP9yLfUhwh6MH=q6a11Z8AeJ8aso7R+LNb-QoDfD5UVw@mail.gmail.com>
Subject: Re: [PATCH] virtio_blk: fix race at module removal
From: Ming Lei <tom.leiming@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 12:12 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> If a device appears while module is being removed,
> driver will get a callback after we've given up
> on the major number.
>
> In theory this means this major number can get reused
> by something else, resulting in a conflict.

Yes, there is a tiny race window.

>
> To fix, cleanup in reverse order of initialization.

Reviewed-by: Ming Lei <ming.lei@canonical.com>

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/block/virtio_blk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 56aadbc..adfba9f 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -883,8 +883,8 @@ out_destroy_workqueue:
>
>  static void __exit fini(void)
>  {
> -       unregister_blkdev(major, "virtblk");
>         unregister_virtio_driver(&virtio_blk);
> +       unregister_blkdev(major, "virtblk");
>         destroy_workqueue(virtblk_wq);
>  }
>  module_init(init);

Thanks,
-- 
Ming Lei
