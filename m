Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab3HFPDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 11:03:11 -0400
Received: from kanga.kvack.org ([205.233.56.17]:47137 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab3HFPDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 11:03:10 -0400
Date: Tue, 6 Aug 2013 11:03:08 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peng Tao <tao.peng@emc.com>,
        Kent Overstreet <koverstreet@google.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-aio@kvack.org
Subject: Re: [PATCH] staging/lustre: kiocb->ki_left is removed
Message-ID: <20130806150308.GB8043@kvack.org>
References: <1375792261-2674-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375792261-2674-1-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 08:31:01PM +0800, Peng Tao wrote:
> From: Peng Tao <tao.peng@emc.com>
> 
> We also missed ki_nbytes...

Applied to the aio-next.git tree.

		-ben

> Cc: Kent Overstreet <koverstreet@google.com>
> Cc: Andreas Dilger <andreas.dilger@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Peng Tao <tao.peng@emc.com>
> ---
> This fixes Lustre build in linux-next and needs to go through
> the aio tree as Kent's AIO patch is not in upstream kernel. 
> 
>  drivers/staging/lustre/lustre/llite/file.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
> index 253f026..bc534db 100644
> --- a/drivers/staging/lustre/lustre/llite/file.c
> +++ b/drivers/staging/lustre/lustre/llite/file.c
> @@ -1009,7 +1009,7 @@ static ssize_t ll_file_read(struct file *file, char *buf, size_t count,
>  	local_iov->iov_len = count;
>  	init_sync_kiocb(kiocb, file);
>  	kiocb->ki_pos = *ppos;
> -	kiocb->ki_left = count;
> +	kiocb->ki_nbytes = count;
>  
>  	result = ll_file_aio_read(kiocb, local_iov, 1, kiocb->ki_pos);
>  	*ppos = kiocb->ki_pos;
> @@ -1068,7 +1068,7 @@ static ssize_t ll_file_write(struct file *file, const char *buf, size_t count,
>  	local_iov->iov_len = count;
>  	init_sync_kiocb(kiocb, file);
>  	kiocb->ki_pos = *ppos;
> -	kiocb->ki_left = count;
> +	kiocb->ki_nbytes = count;
>  
>  	result = ll_file_aio_write(kiocb, local_iov, 1, kiocb->ki_pos);
>  	*ppos = kiocb->ki_pos;
> -- 
> 1.7.9.5

-- 
"Thought is the essence of where you are now."
