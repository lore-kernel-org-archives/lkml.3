Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab3LKLdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:33:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab3LKLdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:33:17 -0500
Date: Wed, 11 Dec 2013 06:33:11 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
        <samba-technical@lists.samba.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] fs: cifs: new helper: file_inode(file)
Message-ID: <20131211063311.3382dca2@tlielax.poochiereds.net>
In-Reply-To: <52A7D5C3.6010300@huawei.com>
References: <52A7D5C3.6010300@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013 11:02:27 +0800
Libo Chen <clbchenlibo.chen@huawei.com> wrote:

> 
> Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>
> ---
>  fs/cifs/ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 7749230..45cb59b 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -85,7 +85,7 @@ static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
>  		goto out_fput;
>  	}
> 
> -	src_inode = src_file.file->f_dentry->d_inode;
> +	src_inode = file_inode(src_file.file);
> 
>  	/*
>  	 * Note: cifs case is easier than btrfs since server responsible for

Acked-by: Jeff Layton <jlayton@redhat.com>
