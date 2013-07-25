Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab3GYVen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:34:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34396 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab3GYVej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:34:39 -0400
Date: Thu, 25 Jul 2013 23:34:33 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V8 29/33] udf: convert file ops from aio_read/write to
 read/write_iter
Message-ID: <20130725213433.GB18011@quack.suse.cz>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
 <1374774659-13121-30-git-send-email-dave.kleikamp@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374774659-13121-30-git-send-email-dave.kleikamp@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 25-07-13 12:50:55, Dave Kleikamp wrote:
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Cc: Jan Kara <jack@suse.cz>
  Looks good. You can add:
Acked-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/udf/file.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/udf/file.c b/fs/udf/file.c
> index 339df8b..e392d60 100644
> --- a/fs/udf/file.c
> +++ b/fs/udf/file.c
> @@ -133,8 +133,8 @@ const struct address_space_operations udf_adinicb_aops = {
>  	.direct_IO	= udf_adinicb_direct_IO,
>  };
>  
> -static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
> -				  unsigned long nr_segs, loff_t ppos)
> +static ssize_t udf_file_write_iter(struct kiocb *iocb, struct iov_iter *iter,
> +				   loff_t ppos)
>  {
>  	ssize_t retval;
>  	struct file *file = iocb->ki_filp;
> @@ -168,7 +168,7 @@ static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  	} else
>  		up_write(&iinfo->i_data_sem);
>  
> -	retval = generic_file_aio_write(iocb, iov, nr_segs, ppos);
> +	retval = generic_file_write_iter(iocb, iter, ppos);
>  	if (retval > 0)
>  		mark_inode_dirty(inode);
>  
> @@ -242,12 +242,12 @@ static int udf_release_file(struct inode *inode, struct file *filp)
>  
>  const struct file_operations udf_file_operations = {
>  	.read			= do_sync_read,
> -	.aio_read		= generic_file_aio_read,
> +	.read_iter		= generic_file_read_iter,
>  	.unlocked_ioctl		= udf_ioctl,
>  	.open			= generic_file_open,
>  	.mmap			= generic_file_mmap,
>  	.write			= do_sync_write,
> -	.aio_write		= udf_file_aio_write,
> +	.write_iter		= udf_file_write_iter,
>  	.release		= udf_release_file,
>  	.fsync			= generic_file_fsync,
>  	.splice_read		= generic_file_splice_read,
> -- 
> 1.8.3.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
