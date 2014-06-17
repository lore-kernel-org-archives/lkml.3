Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaFQACV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:02:21 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:54104 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaFQACT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:02:19 -0400
Date: Mon, 16 Jun 2014 17:02:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Fabian Frederick <fabf@skynet.be>
cc: Fengguang Wu <fengguang.wu@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, sage <sage@inktank.com>
Subject: Re: [PATCH 1/1 RESEND] fs/ceph/export.c: add static to local
 function
In-Reply-To: <20140615083422.8d3b4ab0f2b1c70eeef9ae03@skynet.be>
Message-ID: <alpine.DEB.2.02.1406161701370.21018@chino.kir.corp.google.com>
References: <20140615083422.8d3b4ab0f2b1c70eeef9ae03@skynet.be>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jun 2014, Fabian Frederick wrote:

> ceph_get_parent is only used in fs/ceph/export.c
> 
> Cc: Sage Weil <sage@inktank.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/ceph/export.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 00d6af6..8d7d782 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -169,7 +169,7 @@ static struct dentry *__get_parent(struct super_block *sb,
>  	return dentry;
>  }
>  
> -struct dentry *ceph_get_parent(struct dentry *child)
> +static struct dentry *ceph_get_parent(struct dentry *child)
>  {
>  	/* don't re-export snaps */
>  	if (ceph_snap(child->d_inode) != CEPH_NOSNAP)

Not sure what tree you're modifying, this is fixed by commit e84be11c5360 
("ceph: ceph_get_parent() can be static") in Linus's tree.
