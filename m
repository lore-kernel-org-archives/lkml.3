Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3JVLQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 07:16:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24060 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3JVLQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 07:16:19 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f3d6d000001c4a-d7-52665e8135a8
Content-transfer-encoding: 8BIT
Message-id: <1382440544.992.64.camel@kjgkr>
Subject: Re: [PATCH] f2fs: delete and free dirty dir freeing inode entry when
 sync dirty dir inodes
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 22 Oct 2013 20:15:44 +0900
In-reply-to: <5264D574.6000105@cn.fujitsu.com>
References: <5264D574.6000105@cn.fujitsu.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t8zY93GuLQgg7tXdS2etx9gtri0yN1i
	z96TLBaXd81hc2Dx+H9wErPH7gWfmTw+b5ILYI7isklJzcksSy3St0vgypgy8SRjQQdXRc/u
	C2wNjE0cXYycHBICJhJzbzSwQdhiEhfurQeyuTiEBJYxSkxrOMnYxcgBVjR9Dj9IjZDAIkaJ
	o389QWxeAUGJH5PvsYCUMAvISxy5lA0SZhZQl5g0bxEzRPkrRomriyQhyrUlpt99wARiCwuk
	ShxY/5kVpJUNKL55vwFEuaLE2/13WUFsEQE1iWfvLjGBXMMs0M0ocXb9K3aQBIuAqsSE7XfB
	bE4BPYmfi9tYIZp1JRofNoLN5xcQlTi8cDszxFtKErvbO9lBBkkIHGKXOLOxjwVikIDEt8mH
	WCBelJXYdACqXlLi4IobLBMYJWYh+XIWwpezkHy5gJF5FaNoakFyQXFSepGJXnFibnFpXrpe
	cn7uJkZIrE3YwXjvgPUhxmSgjROZpUST84GxmlcSb2hsZmRhamJqbGRuaUaasJI4r9qjpCAh
	gfTEktTs1NSC1KL4otKc1OJDjEwcnFINjFZrbih9XvD5Xx3vVEae50mnWy0Cp9zYfiLg4OQt
	vN1N8w76RMz7FpbIVy0ieuHZqtm7vTun2rxffpXdmc2uu9F8aoNqgXK4qPa6ynRmOa3nLb22
	ryynLQ+2+bN6o61fi0tDoZ1TTYdSqUHG7rg9661ablnOPbys+saXUxwc79ttW2+mWJ0xVGIp
	zkg01GIuKk4EAJwCJIjLAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAd3GuLQgg/+PNC2etx9gtri0yN1i
	z96TLBaXd81hc2Dx+H9wErPH7gWfmTw+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8yYMvEkY0EHV0XP7gtsDYxNHF2MHBwSAiYS0+fwdzFyApliEhfurWcDsYUE
	FjFKHP3rCWLzCghK/Jh8jwWknFlAXuLIpWyQMLOAusSkeYuYIcpfMUpcXSQJUa4tMf3uAyYQ
	W1ggVeLA+s+sIK1sQPHN+w0gyhUl3u6/ywpiiwioSTx7dwmonAtoZDejxNn1r9hBEiwCqhIT
	tt8FszkF9CR+Lm5jhWjWlWh82Ag2n19AVOLwwu3MEOcrSexu72SfwCg0C8nVsxCunoXk6gWM
	zKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgiP5mfQOxlUNFocYBTgYlXh4M6xSg4RYE8uK
	K3MPMUpwMCuJ8Db7pgUJ8aYkVlalFuXHF5XmpBYfYkwGOnwis5Rocj4wyeSVxBsam5gZWRqZ
	WRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2NgOF/AetsjkyY1yO66Nu/KwR/n
	Kxf+/hHv92Kp371vJnyhR2cGlqtrxDUxVc7PSI3izLzDU76O9cp9dwXP3g3LnpQ93pG77NXn
	th1nmiYn884WOqsW8/ax4rTTmz6Vi8oc9jff1iM0f/88ebulMY8WKJ8IzjWxODFzrSC7/Ipd
	C7/pW53o/rheiaU4I9FQi7moOBEAJFgKRCgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-10-21 (월), 15:19 +0800, Gu Zheng:
> In sync_dirty_dir_inodes(), remove_dirty_dir_inode() will be called
> in the callback of filemap_flush to delete and free dirty dir inode entry.
> But for the freeing inode entry, missed this step after sbumit data bio,
> and this may lead to a dead loop if these is freeing inode entry in
> dir_inode_list. So add the delete and free step to fix it.

Hi Gu,

This dirty inode will be removed by f2fs_evict_inode() after submitting
any pending bio, f2fs_submit_bio().
Thanks,

> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/f2fs/checkpoint.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 8d16071..f61838f 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -600,7 +600,16 @@ retry:
>  		 * wribacking dentry pages in the freeing inode.
>  		 */
>  		f2fs_submit_bio(sbi, DATA, true);
> +
> +		spin_lock(&sbi->dir_inode_lock);
> +		list_del(&entry->list);
> +#ifdef CONFIG_F2FS_STAT_FS
> +		sbi->n_dirty_dirs--;
> +#endif
> +		spin_unlock(&sbi->dir_inode_lock);
> +		kmem_cache_free(inode_entry_slab, entry);
>  	}
> +
>  	goto retry;
>  }
>  

-- 
Jaegeuk Kim
Samsung

