Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbaLDVNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:13:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbaLDVNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:13:43 -0500
Date: Thu, 4 Dec 2014 13:13:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tom Van Braeckel <tomvanbraeckel@gmail.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Misc: pass miscdevice through file's private_data
Message-ID: <20141204211342.GA22293@kroah.com>
References: <1417727295-18989-1-git-send-email-tomvanbraeckel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417727295-18989-1-git-send-email-tomvanbraeckel@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 10:08:15PM +0100, Tom Van Braeckel wrote:
> Place the miscdevice in the file's private_data to be used by the file operations.
> 
> Previously, this was done only when an open() operation had been registered.
> But it is also useful in the other file operations, so we pass it on unconditionally.
> 
> Signed-off-by: Tom Van Braeckel <tomvanbraeckel@gmail.com>
> ---
>  drivers/char/misc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/misc.c b/drivers/char/misc.c
> index ffa97d2..c3681fb 100644
> --- a/drivers/char/misc.c
> +++ b/drivers/char/misc.c
> @@ -140,10 +140,16 @@ static int misc_open(struct inode * inode, struct file * file)
>  			goto fail;
>  	}
>  
> +	/*
> +	 * Place the miscdevice in the file's
> +	 * private_data so it can be used by the
> +	 * file operations, including f_op->open below
> +	 */
> +	file->private_data = c;
> +
>  	err = 0;
>  	replace_fops(file, new_fops);
>  	if (file->f_op->open) {
> -		file->private_data = c;
>  		err = file->f_op->open(inode,file);
>  	}

These braces aren't needed anymore, right?

Also, what is this now going to break?  :)

thanks,

greg k-h
