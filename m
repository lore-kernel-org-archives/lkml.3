Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934395AbaKMWJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:09:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934093AbaKMWJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:09:12 -0500
Date: Thu, 13 Nov 2014 14:09:11 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pieter Smith <pieter@boesman.nl>
Cc: Josh Triplett <josh@joshtriplett.org>, Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 51/56] drivers/char/mem: support compiling out splice
Message-ID: <20141113220911.GA546@kroah.com>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
 <1415913813-362-52-git-send-email-pieter@boesman.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415913813-362-52-git-send-email-pieter@boesman.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 10:23:28PM +0100, Pieter Smith wrote:
> Compile out splice support from mem character driver when the splice-family of
> syscalls is not supported by the system (i.e. CONFIG_SYSCALL_SPLICE is
> undefined).
> 
> add/remove: 0/2 grow/shrink: 0/0 up/down: 0/-28 (-28)
> function                                     old     new   delta
> pipe_to_null                                   4       -      -4
> splice_write_null                             24       -     -24
> 
> Signed-off-by: Pieter Smith <pieter@boesman.nl>
> ---
>  drivers/char/mem.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 917403f..420d651 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -610,6 +610,7 @@ static ssize_t aio_write_null(struct kiocb *iocb, const struct iovec *iov,
>  	return iov_length(iov, nr_segs);
>  }
>  
> +#ifdef CONFIG_SYSCALL_SPLICE
>  static int pipe_to_null(struct pipe_inode_info *info, struct pipe_buffer *buf,
>  			struct splice_desc *sd)
>  {
> @@ -621,6 +622,7 @@ static ssize_t splice_write_null(struct pipe_inode_info *pipe, struct file *out,
>  {
>  	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_null);
>  }
> +#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
>  

Ick, no, not worth the #ifdef mess, sorry.

