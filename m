Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab3EBPHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:07:43 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:46473 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927Ab3EBPHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:07:42 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <51550460.6050408@gmail.com>
References: <51550460.6050408@gmail.com>
Date: Thu, 2 May 2013 17:07:40 +0200
Message-ID: <CAJfpegs2Mb8AYQ-8aoxn2su0MezxHc=WRvK+t+a5PyPRiTUxUQ@mail.gmail.com>
Subject: Re: [PATCH] fuse: Don't do file_update_time for write_operation.
From: Miklos Szeredi <miklos@szeredi.hu>
To: majianpeng <majianpeng@gmail.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 4:02 AM, majianpeng <majianpeng@gmail.com> wrote:
> For direct-write and normal-write operations, after write they will call fuse_invalidate_attr.
> So it's make no sense to call file_update_time before writing.
>
> In function file_update_time, there is other thing which update version of
> inode.For this i am not sure.

file_update_time will skip the actual file update anyway due to
S_NOCMTIME.  And when we will do cached writes we actually need the
time updates.  So I'm not applying this one.

Thanks,
Miklos

>
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
> fs/fuse/file.c | 4 ----
> 1 file changed, 4 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 34b80ba..214279c 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -988,10 +988,6 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
> if (err)
> goto out;
>
> - err = file_update_time(file);
> - if (err)
> - goto out;
> -
> if (file->f_flags & O_DIRECT) {
> written = generic_file_direct_write(iocb, iov, &nr_segs,
> pos, &iocb->ki_pos,
> --
> 1.8.2.rc2.4.g7799588
>
