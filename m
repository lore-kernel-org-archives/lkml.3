Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbaFYJOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:14:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbaFYJON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:14:13 -0400
Date: Wed, 25 Jun 2014 10:31:42 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lczerner@localhost.localdomain
To: Eric Biggers <ebiggers3@gmail.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix check for fallocate on active swapfile
In-Reply-To: <1403671508-371-1-git-send-email-ebiggers3@gmail.com>
Message-ID: <alpine.LFD.2.00.1406251030500.2171@localhost.localdomain>
References: <1403671508-371-1-git-send-email-ebiggers3@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Eric Biggers wrote:

> Date: Tue, 24 Jun 2014 23:45:08 -0500
> From: Eric Biggers <ebiggers3@gmail.com>
> To: linux-fsdevel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>
> Subject: [PATCH] vfs: fix check for fallocate on active swapfile
> 
> Fix the broken check for calling sys_fallocate() on an active swapfile,
> introduced by commit 0790b31b69374ddadefe ("fs: disallow all fallocate
> operation on active swapfile").

Oops, good catch, Thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
> ---
>  fs/open.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 36662d0..d6fd3ac 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -263,11 +263,10 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  		return -EPERM;
>  
>  	/*
> -	 * We can not allow to do any fallocate operation on an active
> -	 * swapfile
> +	 * We cannot allow any fallocate operation on an active swapfile
>  	 */
>  	if (IS_SWAPFILE(inode))
> -		ret = -ETXTBSY;
> +		return -ETXTBSY;
>  
>  	/*
>  	 * Revalidate the write permissions, in case security policy has
> 
