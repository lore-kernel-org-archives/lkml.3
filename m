Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3GIWLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 18:11:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58452 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3GIWLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 18:11:31 -0400
Date: Tue, 9 Jul 2013 15:11:18 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: mfasheh@suse.com, ocfs2-devel@oss.oracle.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ocfs2/refcounttree: add the missing NULL check of the
 return value of find_or_create_page()
Message-ID: <20130709221117.GB25976@localhost>
Mail-Followup-To: Gu Zheng <guz.fnst@cn.fujitsu.com>, mfasheh@suse.com,
	ocfs2-devel@oss.oracle.com,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <51DA6FD5.8050300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DA6FD5.8050300@cn.fujitsu.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 03:52:53PM +0800, Gu Zheng wrote:
> Add the missing NULL check of the return value of find_or_create_page() in
> function ocfs2_duplicate_clusters_by_page().
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/ocfs2/refcounttree.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 998b17e..456d0e4 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -2965,7 +2965,11 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>  			to = map_end & (PAGE_CACHE_SIZE - 1);
> 
>  		page = find_or_create_page(mapping, page_index, GFP_NOFS);
> -
> +		if (!page) {
> +			ret = -ENOMEM;
> +			mlog_errno(ret);
> +			break;
> +		}
>  		/*
>  		 * In case PAGE_CACHE_SIZE <= CLUSTER_SIZE, This page
>  		 * can't be dirtied before we CoW it out.

Put a blank line between the closing brace and the comment.  Otherwise,
Acked-by: Joel Becker <jlbec@evilplan.org>

Joel
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 

Life's Little Instruction Book #99

	"Think big thoughts, but relish small pleasures."

			http://www.jlbec.org/
			jlbec@evilplan.org
