Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaJLVHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 17:07:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36040 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbaJLVHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 17:07:15 -0400
Date: Sun, 12 Oct 2014 22:07:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] fs/anon_inodes.c: Simplify control flow in
 anon_inode_getfd()
Message-ID: <20141012210712.GT7996@ZenIV.linux.org.uk>
References: <1413146562-18147-1-git-send-email-ebiggers3@gmail.com>
 <1413146562-18147-2-git-send-email-ebiggers3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413146562-18147-2-git-send-email-ebiggers3@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 03:42:39PM -0500, Eric Biggers wrote:

>  	file = anon_inode_getfile(name, fops, priv, flags);
>  	if (IS_ERR(file)) {
> -		error = PTR_ERR(file);
> -		goto err_put_unused_fd;
> +		put_unused_fd(fd);
> +		return PTR_ERR(file);
>  	}
>  	fd_install(fd, file);

at least slap unlikely() on that if (IS_ERR(...))...
