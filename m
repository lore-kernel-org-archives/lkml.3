Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165Ab3FWIBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 04:01:43 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:58360 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab3FWIBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 04:01:42 -0400
MIME-Version: 1.0
In-Reply-To: <51BF1AE7.8040300@gmail.com>
References: <51BF1AE7.8040300@gmail.com>
Date: Sun, 23 Jun 2013 16:01:40 +0800
Message-ID: <CAAM7YAkp0OZJeU+vaat7wwZScRRu+M1DPNZA1HOyEchcFoHkfw@mail.gmail.com>
Subject: Re: [PATCH] ceph: remove sb_start/end_write in ceph_aio_write.
From: "Yan, Zheng" <ukernel@gmail.com>
To: majianpeng <majianpeng@gmail.com>
Cc: Sage Weil <sage@inktank.com>, ceph-devel <ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 10:19 PM, majianpeng <majianpeng@gmail.com> wrote:
>
> Either in vfs_write or io_submit,it call file_start/end_write.
> The different between file_start/end_write and sb_start/end_write is
> file_ only handle regular file.But i think in ceph_aio_write,it only
> for regular file.
>
> Signed-off-by: Jianpeng Ma<majianpeng@gmail.com>
> ---
>  fs/ceph/file.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 656e169..7c69f4f 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -716,7 +716,6 @@ static ssize_t ceph_aio_write(struct kiocb *iocb, const struct iovec *iov,
>         if (ceph_snap(inode) != CEPH_NOSNAP)
>                 return -EROFS;
>  -      sb_start_write(inode->i_sb);
>         mutex_lock(&inode->i_mutex);
>         hold_mutex = true;
>  @@ -809,7 +808,6 @@ retry_snap:
>  out:
>         if (hold_mutex)
>                 mutex_unlock(&inode->i_mutex);
> -       sb_end_write(inode->i_sb);
>         current->backing_dev_info = NULL;
>         return written ? written : err;
> -- 1.8.3.rc1.44.gb387c77
>


It looks that my commit 03d254edeb (ceph: apply write checks in
ceph_aio_write) conflicts with
Al Viro's commit 8d71db4f08 (lift sb_start_write/sb_end_write out of
->aio_write())

Acked-by: Yan, Zheng <zheng.z.yan@intel.com>
