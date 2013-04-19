Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964919Ab3DSWBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 18:01:23 -0400
Received: from cobra.newdream.net ([66.33.216.30]:34469 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933335Ab3DSWBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 18:01:21 -0400
Date: Fri, 19 Apr 2013 15:01:21 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Randy Dunlap <rdunlap@infradead.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH -next] ceph: fix printk format warnings in file.c
In-Reply-To: <5171B507.4030808@infradead.org>
Message-ID: <alpine.DEB.2.00.1304191501160.13036@cobra.newdream.net>
References: <20130419181924.a035efe6d5e73fe0db9ddb84@canb.auug.org.au> <5171B507.4030808@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, thanks!

sage

On Fri, 19 Apr 2013, Randy Dunlap wrote:

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix printk format warnings by using %zd for 'ssize_t' variables:
> 
> fs/ceph/file.c:751:2: warning: format '%ld' expects argument of type 'long int', but argument 11 has type 'ssize_t' [-Wformat]
> fs/ceph/file.c:762:2: warning: format '%ld' expects argument of type 'long int', but argument 11 has type 'ssize_t' [-Wformat]
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc:	Sage Weil <sage@inktank.com>
> Cc:	ceph-devel@vger.kernel.org
> ---
>  fs/ceph/file.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-next-20130419.orig/fs/ceph/file.c
> +++ linux-next-20130419/fs/ceph/file.c
> @@ -748,7 +748,7 @@ retry_snap:
>  		goto out;
>  	}
>  
> -	dout("aio_write %p %llx.%llx %llu~%ld getting caps. i_size %llu\n",
> +	dout("aio_write %p %llx.%llx %llu~%zd getting caps. i_size %llu\n",
>  	     inode, ceph_vinop(inode), pos, count, inode->i_size);
>  	if (fi->fmode & CEPH_FILE_MODE_LAZY)
>  		want = CEPH_CAP_FILE_BUFFER | CEPH_CAP_FILE_LAZYIO;
> @@ -759,7 +759,7 @@ retry_snap:
>  	if (err < 0)
>  		goto out;
>  
> -	dout("aio_write %p %llx.%llx %llu~%ld got cap refs on %s\n",
> +	dout("aio_write %p %llx.%llx %llu~%zd got cap refs on %s\n",
>  	     inode, ceph_vinop(inode), pos, count, ceph_cap_string(got));
>  
>  	if ((got & (CEPH_CAP_FILE_BUFFER|CEPH_CAP_FILE_LAZYIO)) == 0 ||
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
