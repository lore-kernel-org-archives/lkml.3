Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbaCQXYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 19:24:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaCQXYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 19:24:44 -0400
Date: Mon, 17 Mar 2014 16:26:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio: Fix memory size check with vma in
 uio_mmap_physical()
Message-ID: <20140317232645.GA11450@kroah.com>
References: <1394587461-8574-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394587461-8574-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 10:24:21AM +0900, Nobuhiro Iwamatsu wrote:
> Register for the device are mapped in uio_mmap_physical().
> In this case, it might not be the same as the size of VMA always.

Why wouldn't this be the case?

> This uses PAGE_ALIGN to memory size, fix the check of the memory size
> to be mapped.
> 
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
> ---
>  drivers/uio/uio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index a673e5b..e371f5a 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -655,7 +655,7 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
>  
>  	if (mem->addr & ~PAGE_MASK)
>  		return -ENODEV;
> -	if (vma->vm_end - vma->vm_start > mem->size)
> +	if (vma->vm_end - vma->vm_start > PAGE_ALIGN(mem->size))

You just increased the size for the check, that seems wrong.  Why
wouldn't mem->size be correct here?

What hardware is failing for this with a valid size and end/start
addresses?

thanks,

greg k-h
