Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab3BLWQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:16:30 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:60117 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab3BLWQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:16:29 -0500
MIME-Version: 1.0
In-Reply-To: <1360685171-3792-4-git-send-email-pbonzini@redhat.com>
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com>
	<1360685171-3792-4-git-send-email-pbonzini@redhat.com>
Date: Tue, 12 Feb 2013 17:16:28 -0500
Message-ID: <CAECXXi67L+Oo0W6bwoKqr_AY95HHcsXbK=XrK6H_iT8Ca6T14A@mail.gmail.com>
Subject: Re: [PATCH 3/3] nbd: show read-only state in sysfs
From: Paul Clements <paul.clements@us.sios.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, nbd-general@lists.sf.net,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 11:06 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Pass the read-only flag to set_device_ro, so that it will be
> visible to the block layer and in sysfs.

Looks good


> Cc: <nbd-general@lists.sf.net>
> Cc: Paul Clements <Paul.Clements@steeleye.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/block/nbd.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index a9c5c7a..ef17c2e 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -703,6 +703,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
>
>                 mutex_unlock(&nbd->tx_lock);
>
> +               if (nbd->flags & NBD_FLAG_READ_ONLY)
> +                       set_device_ro(bdev, true);
>                 if (nbd->flags & NBD_FLAG_SEND_TRIM)
>                         queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
>                                 nbd->disk->queue);
> @@ -730,6 +732,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
>                 dev_warn(disk_to_dev(nbd->disk), "queue cleared\n");
>                 kill_bdev(bdev);
>                 queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, nbd->disk->queue);
> +               set_device_ro(bdev, false);
>                 if (file)
>                         fput(file);
>                 nbd->flags = 0;
> --
> 1.7.1
>
