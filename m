Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbbAPIei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 03:34:38 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:34905 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbbAPIeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 03:34:37 -0500
Date: Fri, 16 Jan 2015 09:34:33 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: David Howells <dhowells@redhat.com>
Cc: Jesper Nilsson <jespern@axis.com>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH] VFS: Convert file->f_dentry->d_inode to file_inode()
 [ver #2]
Message-ID: <20150116083433.GZ26817@axis.com>
References: <20150113175753.29073.20788.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113175753.29073.20788.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 06:57:53PM +0100, David Howells wrote:
> Convert file->f_dentry->d_inode to file_inode() so as to get layered
> filesystems right.
> 
> Found with: git grep '[.>]f_dentry'

Yes, compile works with this patch. Do you want me to take it through
the CRIS tree or do you have any other tree in mind?

> Signed-off-by: David Howells <dhowells@redhat.com>

In any case:

Reviewed-by: Jesper Nilsson <jesper.nilsson@axis.com>

>  arch/cris/arch-v32/drivers/sync_serial.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
> index 08a313fc2241..f772068d9e79 100644
> --- a/arch/cris/arch-v32/drivers/sync_serial.c
> +++ b/arch/cris/arch-v32/drivers/sync_serial.c
> @@ -604,7 +604,7 @@ static ssize_t __sync_serial_read(struct file *file,
>  				  struct timespec *ts)
>  {
>  	unsigned long flags;
> -	int dev = MINOR(file->f_dentry->d_inode->i_rdev);
> +	int dev = MINOR(file_inode(file)->i_rdev);
>  	int avail;
>  	struct sync_port *port;
>  	unsigned char *start;
> 

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
