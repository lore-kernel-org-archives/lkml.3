Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3EHKgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:36:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49782 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3EHKgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:36:15 -0400
Date: Wed, 8 May 2013 11:36:11 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Chen Gang'" <gang.chen@asianux.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3.8-stable]  kernel/audit_tree.c: tree will leak memory
 when failure occurs in audit_trim_trees()
Message-ID: <20130508103611.GB3763@hercules>
References: <007001ce457e$dcfff1c0$96ffd540$%choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007001ce457e$dcfff1c0$96ffd540$%choi@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 05:44:01PM +0900, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.8-stable tree, should we apply
> it?

This commit seems to be applicable to other stable trees as well (3.0,
3.2, 3.5, ...).

Cheers,
--
Luis


> 
> ------------------
> 
> From: "Chen Gang <gang.chen@asianux.com>"
> 
> commit 12b2f117f3bf738c1a00a6f64393f1953a740bd4 upstream
> 
> audit_trim_trees() calls get_tree().  If a failure occurs we must call
> put_tree().
> 
> [akpm@linux-foundation.org: run put_tree() before mutex_lock() for small
> scalability improvement]
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Eric Paris <eparis@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  kernel/audit_tree.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
> index 642a89c..a291aa2 100644
> --- a/kernel/audit_tree.c
> +++ b/kernel/audit_tree.c
> @@ -617,9 +617,9 @@ void audit_trim_trees(void)
>  		}
>  		spin_unlock(&hash_lock);
>  		trim_marked(tree);
> -		put_tree(tree);
>  		drop_collected_mounts(root_mnt);
>  skip_it:
> +		put_tree(tree);
>  		mutex_lock(&audit_filter_mutex);
>  	}
>  	list_del(&cursor);
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
