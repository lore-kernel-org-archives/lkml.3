Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaKJHjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:39:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46294 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaKJHjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:39:16 -0500
X-AuditID: cbfee68f-f791c6d000004834-a3-54606ba103bf
Date: Mon, 10 Nov 2014 16:37:58 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 4/5] f2fs: write node pages if checkpoint is not
 doing
Message-id: <20141110073758.GC14659@lcm>
References: <1415518569-20626-1-git-send-email-jaegeuk@kernel.org>
 <1415518569-20626-4-git-send-email-jaegeuk@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <1415518569-20626-4-git-send-email-jaegeuk@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+Zse7C7IQQg75HphZP1s9itri0yN1i
	z96TLBaXd81hc2Dx2LSqk81j94LPTB6fN8kFMEdx2aSk5mSWpRbp2yVwZcx6MZul4BN3xe/2
	iewNjM84uxg5OSQETCRWndzFBGGLSVy4t56ti5GLQ0hgGaPEoUXn2GGKFs+/xg6RmM4osfTj
	KWYI5yejxN0VP1hAqlgEVCXObGwB62AT0JJoP70WLC4ioAI06TJYnFkgU2JC/wswW1ggXKJt
	7iU2EJtXQEPi68wJzCC2kEC1xJpv71gh4oISPybfY4Ho1ZJYv/M4E4QtLfHo7wywOZwCzhJb
	Zn9iBLFFgXZNObkN7AUJgWXsEj/+tjBDHCcg8W3yIaBBHEAJWYlNB5ghPpOUOLjiBssERrFZ
	SNbNQrJuFpJ1CxiZVzGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmKERFH/Dsa7B6wPMQpwMCrx
	8Hp8iQ8RYk0sK67MPcRoCnTFRGYp0eR8YKzmlcQbGpsZWZiamBobmVuaKYnzLpT6GSwkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qBcc+que9PFU2WyXu0XsdrTVOZ4KyVz/WvdHTlaO6ckR2a
	pPX6Ij/L319SG6VOvfH5lRhzz1fodLBd4UrbLZnKKm4hK8OXT3FnZGgX6ZY54HBFW0/Sf2nh
	hJ1R+RU/Zi5LaL6daNnC5fK2KWbLltMKog5ye6xMzxxecPPZnOjcP4Uth126JZdnKrEUZyQa
	ajEXFScCABVGecGdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jQd2F2QkhBrv6jCyerJ/FbHFpkbvF
	nr0nWSwu75rD5sDisWlVJ5vH7gWfmTw+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8yY9WI2S8En7orf7RPZGxifcXYxcnJICJhILJ5/jR3CFpO4cG89WxcjF4eQ
	wHRGiaUfTzFDOD8ZJe6u+MECUsUioCpxZmMLWAebgJZE++m1YHERARWJQ4sug8WZBTIlJvS/
	ALOFBcIl2uZeYgOxeQU0JL7OnMAMYgsJVEus+faOFSIuKPFj8j0WiF4tifU7jzNB2NISj/7O
	AJvDKeAssWX2J0YQWxRo15ST29gmMArMQtI+C0n7LCTtCxiZVzGKphYkFxQnpeca6hUn5haX
	5qXrJefnbmIEx+gzqR2MKxssDjEKcDAq8fA6vI0PEWJNLCuuzD3EKMHBrCTCW/sfKMSbklhZ
	lVqUH19UmpNafIjRFBgaE5mlRJPzgekjryTe0NjEzMjSyMzCyMTcXEmc90CrdaCQQHpiSWp2
	ampBahFMHxMHp1QDY0t59OUPk1dsfHGx5pevY03z5kqN3fdf/DixWjP9orj1uxmJ91rXvjhy
	VHt7nml2/fbu1gjX57y1YucM8vpTwxtmqpwWXnLz9KfTxybu6NnbrfWvaebFHd1XK9OC7Px6
	ve5Ip4dMf1bt8Sbh+cw5N+ofzJ9zL2On4vRP8/9vjfoTdNOrUNtVzF+JpTgj0VCLuag4EQAy
	0jzS5wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 11:36:08PM -0800, Jaegeuk Kim wrote:
> It needs to write node pages if checkpoint is not doing in order to avoid
> memory pressure.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/node.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 4ea2c47..6f514fb 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1314,10 +1314,12 @@ static int f2fs_write_node_page(struct page *page,
>  		return 0;
>  	}
>  
> -	if (wbc->for_reclaim)
> -		goto redirty_out;
> -
> -	down_read(&sbi->node_write);
> +	if (wbc->for_reclaim) {
> +		if (!down_read_trylock(&sbi->node_write))
> +			goto redirty_out;

Previously, we skipped write_page for reclaim path, but from now on, we
will write out node page to reclaim memory at any time except checkpoint.
We should remember it may occur to break merging bio.
Got it.

Reviewed-by: Changman Lee <cm224.lee@samsung.com>

> +	} else {
> +		down_read(&sbi->node_write);
> +	}
>  	set_page_writeback(page);
>  	write_node_page(sbi, page, &fio, nid, ni.blk_addr, &new_addr);
>  	set_node_addr(sbi, &ni, new_addr, is_fsync_dnode(page));
> -- 
> 2.1.1
> 
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
