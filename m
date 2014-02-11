Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbaBKUsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:48:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbaBKUst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:48:49 -0500
Date: Tue, 11 Feb 2014 21:48:47 +0100
From: Jan Kara <jack@suse.cz>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH 07/21] fs: Mark function as static in
 ext2/xattr_security.c
Message-ID: <20140211204847.GC22835@quack.suse.cz>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
 <5db9dc03c6c316665e9fd1c6253e9c29ab3a39cf.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5db9dc03c6c316665e9fd1c6253e9c29ab3a39cf.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 09-02-14 18:34:10, Rashika Kheria wrote:
> Mark function as static in ext2/xattr_security.c because it is not
> used outside this file.
> 
> This also elimiantes the following warning in ext2/xattr_security.c:
> fs/ext2/xattr_security.c:45:5: warning: no previous prototype for ‘ext2_initxattrs’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
  Thanks. I've merged the patch.

								Honza
> ---
>  fs/ext2/xattr_security.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/xattr_security.c b/fs/ext2/xattr_security.c
> index cfedb2c..c0ebc4d 100644
> --- a/fs/ext2/xattr_security.c
> +++ b/fs/ext2/xattr_security.c
> @@ -42,8 +42,8 @@ ext2_xattr_security_set(struct dentry *dentry, const char *name,
>  			      value, size, flags);
>  }
>  
> -int ext2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
> -		    void *fs_info)
> +static int ext2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
> +			   void *fs_info)
>  {
>  	const struct xattr *xattr;
>  	int err = 0;
> -- 
> 1.7.9.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
