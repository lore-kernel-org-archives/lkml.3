Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbaBKUtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:49:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337AbaBKUtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:49:17 -0500
Date: Tue, 11 Feb 2014 21:49:16 +0100
From: Jan Kara <jack@suse.cz>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH 09/21] fs: Mark function as static in
 ext3/xattr_security.c
Message-ID: <20140211204916.GE22835@quack.suse.cz>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
 <bcf66d9631e4094a46e539950331f79289e4d85a.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bcf66d9631e4094a46e539950331f79289e4d85a.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 09-02-14 18:39:11, Rashika Kheria wrote:
> Mark function as static in ext3/xattr_security.c because it is not used
> outside this file.
> 
> This eliminates the following warning in ext3/xattr_security.c:
> fs/ext3/xattr_security.c:46:5: warning: no previous prototype for ‘ext3_initxattrs’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
  Thanks. I've merged the patch.

								Honza
> ---
>  fs/ext3/xattr_security.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/xattr_security.c b/fs/ext3/xattr_security.c
> index 3387664..722c2bf 100644
> --- a/fs/ext3/xattr_security.c
> +++ b/fs/ext3/xattr_security.c
> @@ -43,8 +43,9 @@ ext3_xattr_security_set(struct dentry *dentry, const char *name,
>  			      name, value, size, flags);
>  }
>  
> -int ext3_initxattrs(struct inode *inode, const struct xattr *xattr_array,
> -		    void *fs_info)
> +static int ext3_initxattrs(struct inode *inode,
> +			   const struct xattr *xattr_array,
> +			   void *fs_info)
>  {
>  	const struct xattr *xattr;
>  	handle_t *handle = fs_info;
> -- 
> 1.7.9.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
