Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762147Ab3EBVwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:52:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40918 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab3EBVv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:51:59 -0400
Date: Thu, 2 May 2013 14:51:53 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] configfs: use capped length for ->store_attribute()
Message-ID: <20130502215152.GB26770@localhost>
Mail-Followup-To: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20130430072813.GC7237@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430072813.GC7237@elgon.mountain>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 10:28:14AM +0300, Dan Carpenter wrote:
> The difference between "count" and "len" is that "len" is capped at
> 4095.  Changing it like this makes it match how sysfs_write_file() is
> implemented.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Joel Becker <jlbec@evilplan.org>

Do you want me to push this up, or will you be sending it?

Joel


> ---
> This is a static analysis patch.  I haven't found any store_attribute()
> functions where this change makes a difference.
> 
> diff --git a/fs/configfs/file.c b/fs/configfs/file.c
> index 2b6cb23..1d1c41f 100644
> --- a/fs/configfs/file.c
> +++ b/fs/configfs/file.c
> @@ -203,7 +203,7 @@ configfs_write_file(struct file *file, const char __user *buf, size_t count, lof
>  	mutex_lock(&buffer->mutex);
>  	len = fill_write_buffer(buffer, buf, count);
>  	if (len > 0)
> -		len = flush_write_buffer(file->f_path.dentry, buffer, count);
> +		len = flush_write_buffer(file->f_path.dentry, buffer, len);
>  	if (len > 0)
>  		*ppos += len;
>  	mutex_unlock(&buffer->mutex);

-- 

"In the room the women come and go
 Talking of Michaelangelo."

			http://www.jlbec.org/
			jlbec@evilplan.org
