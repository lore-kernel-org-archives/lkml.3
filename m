Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077Ab3HTLCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 07:02:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab3HTLCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 07:02:53 -0400
Date: Tue, 20 Aug 2013 13:02:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: bcrl@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] page_migrate: Fix wrong comment in
 address_space_operations->migratepage()
In-Reply-To: <1371723023-4060-3-git-send-email-tangchen@cn.fujitsu.com>
Message-ID: <alpine.LNX.2.00.1308201302290.21654@pobox.suse.cz>
References: <1371723023-4060-1-git-send-email-tangchen@cn.fujitsu.com> <1371723023-4060-3-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, Tang Chen wrote:

> There is no parameter "sync" in address_space_operations->migratepage().
> It should be mograte_mode. And the comment is for MIGRATE_ASYNC.

I am fixing this typo in changelog :) and applying the series.

> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  include/linux/fs.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 43db02e..c1a76ac 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -372,8 +372,8 @@ struct address_space_operations {
>  	int (*get_xip_mem)(struct address_space *, pgoff_t, int,
>  						void **, unsigned long *);
>  	/*
> -	 * migrate the contents of a page to the specified target. If sync
> -	 * is false, it must not block.
> +	 * migrate the contents of a page to the specified target. If
> +	 * migrate_mode is MIGRATE_ASYNC, it must not block.
>  	 */
>  	int (*migratepage) (struct address_space *,
>  			struct page *, struct page *, enum migrate_mode);
> -- 
> 1.7.1
> 

-- 
Jiri Kosina
SUSE Labs
