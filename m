Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505AbaKMWJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:09:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933765AbaKMWJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:09:49 -0500
Date: Thu, 13 Nov 2014 14:09:49 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pieter Smith <pieter@boesman.nl>
Cc: Josh Triplett <josh@joshtriplett.org>, Arnd Bergmann <arnd@arndb.de>,
        Amit Shah <amit.shah@redhat.com>,
        "open list:VIRTIO CONSOLE DR..." 
	<virtualization@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 52/56] drivers/char/virtio: support compiling out splice
Message-ID: <20141113220949.GC546@kroah.com>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
 <1415913813-362-53-git-send-email-pieter@boesman.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415913813-362-53-git-send-email-pieter@boesman.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 10:23:29PM +0100, Pieter Smith wrote:
> Compile out splice support from virtio character driver when the splice-family
> of syscalls is not supported by the system (i.e. CONFIG_SYSCALL_SPLICE is
> undefined).
> 
> Signed-off-by: Pieter Smith <pieter@boesman.nl>
> ---
>  drivers/char/virtio_console.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index b585b47..de5e2cb 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -870,6 +870,7 @@ struct sg_list {
>  	struct scatterlist *sg;
>  };
>  
> +#ifdef CONFIG_SYSCALL_SPLICE
>  static int pipe_to_sg(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
>  			struct splice_desc *sd)
>  {
> @@ -976,6 +977,7 @@ error_out:
>  	pipe_unlock(pipe);
>  	return ret;
>  }
> +#endif /* #ifdef CONFIG_SYSCALL_SPLICE */

Not worth the #ifdef mess.
