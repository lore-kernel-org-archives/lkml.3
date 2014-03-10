Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaCJEwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 00:52:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26873 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaCJEwH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 00:52:07 -0400
X-AuditID: cbfee690-b7f266d00000287c-f8-531d44f4de1a
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1394427024.3870.94.camel@kjgkr>
Subject: Re: [PATCH 5/5] f2fs: add a wait queue to avoid unnecessary,
 build_free_nid
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 10 Mar 2014 13:50:24 +0900
In-reply-to: <5319A2DB.8040705@cn.fujitsu.com>
References: <5319A2DB.8040705@cn.fujitsu.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zfd0vLrLBBosW6Vo8bz/AbHFpkbvF
	5V1z2ByYPf4fnMTssXvBZyaPz5vkApijuGxSUnMyy1KL9O0SuDI+P+tkK3goVbHiRUID4ynR
	LkZODgkBE4nPk5+xQNhiEhfurWfrYuTiEBJYxihx8v0yNpii0482MEIkpjNKXJq1nQkkwSsg
	KPFj8j2wbmYBdYlJ8xYxQ9giEn1v9jJB2NoSyxa+ZoZofsUoMWvnRzaIZh2Jzb/vM4LYwgJh
	EofOzAQq4uBgA2rYvN8AJCwkoCjxdv9dVhBbREBN4tm7S1AzEyQenu9nBSlnEVCVmLLXFCTM
	KaAn8fvcM3aQsJCArsSSM7YgYX4BUYnDC7czQ7yiJLG7vZMd5BoJgWPsEp9PbQS7hkVAQOLb
	5EMsIL0SArISmw5A1UtKHFxxg2UCo+QsJA/PQvLwLCQPz0Ly8AJGllWMoqkFyQXFSelFJnrF
	ibnFpXnpesn5uZsYITE5YQfjvQPWhxiTgdZPZJYSTc4HxnReSbyhsZmRhamJqbGRuaUZacJK
	4rxqj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTD6uApKcxzvm7lDrbuktazC5HxIQcXi
	3KUnd5X+unw+Pq71xSX511NPTozv5a9P5osvKv9t0SD9qWiX7Q0Vyfu7uTrj9jTpnL255urJ
	fdN//9TSLmdfYf0y8lV06Z/iuT9nLrq+kn2if1+s2GLBOwJZq1/NuqsTVyK2PnLme6OfQq17
	i9UkfTyVWIozEg21mIuKEwFBtASI3wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jQd0vLrLBBmtWaFo8bz/AbHFpkbvF
	5V1z2ByYPf4fnMTssXvBZyaPz5vkApijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1
	DS0tzJUU8hJzU22VXHwCdN0yc4AWKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEy
	QAMJ6xgzlpyax1xwUqpi8fFF7A2Mm0S7GDk5JARMJE4/2sAIYYtJXLi3nq2LkYtDSGA6o8Sl
	WduZQBK8AoISPybfY+li5OBgFpCXOHIpGyTMLKAuMWneImaI+leMErN2fmSDqNeR2Pz7PthQ
	YYEwiUNnZjKD9LIJaEts3m8AEhYSUJR4u/8uK4gtIqAm8ezdJSaImQkSD8/3s4KUswioSkzZ
	awoS5hTQk/h97hk7SFhIQFdiyRlbkDC/gKjE4YXbmSGuV5LY3d7JPoFRaBaSm2ch3DwLyc0L
	GJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgTH7zPpHYyrGiwOMQpwMCrx8B54KxMsxJpY
	VlyZe4hRgoNZSYSXy1A2WIg3JbGyKrUoP76oNCe1+BBjMtDZE5mlRJPzgaklryTe0NjEzMjS
	yMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYtb+UJJ7lS5p2rIHt/+t5U56t
	Lrm+edKXJQZrV3z6doen8vXmo6Xb9x3JevykOPh+v2vnlA0vJ+0pjXp1Z7eW99Wp+97PrX8k
	f/+KWO+emJWs2Ur663MlhMrDIwrvuHmtcZr8YY+qMP/R079nurMfN3pvLxzwYYGgRmEhg/De
	v7OSZu7rmd1TfEiJpTgj0VCLuag4EQAtDMrSIwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

2014-03-07 (금), 18:43 +0800, Gu Zheng:
> Previously, when we try to alloc free nid while the build free nid
> is going, the allocer will be run into the flow that waiting for
> "nm_i->build_lock", see following:
> 	/* We should not use stale free nids created by build_free_nids */
> ---->	if (nm_i->fcnt && !on_build_free_nids(nm_i)) {
> 		f2fs_bug_on(list_empty(&nm_i->free_nid_list));
> 		list_for_each(this, &nm_i->free_nid_list) {
> 			i = list_entry(this, struct free_nid, list);
> 			if (i->state == NID_NEW)
> 				break;
> 		}
> 
> 		f2fs_bug_on(i->state != NID_NEW);
> 		*nid = i->nid;
> 		i->state = NID_ALLOC;
> 		nm_i->fcnt--;
> 		spin_unlock(&nm_i->free_nid_list_lock);
> 		return true;
> 	}
> 	spin_unlock(&nm_i->free_nid_list_lock);
> 
> 	/* Let's scan nat pages and its caches to get free nids */
> ---->	mutex_lock(&nm_i->build_lock);
> 	build_free_nids(sbi);
> 	mutex_unlock(&nm_i->build_lock);
> and this will cause another unnecessary building free nid if the current
> building free nid job is done.

Could you support any performance number for this?
Since, IMO, the contended building processes will be released right away
because of the following condition check inside build_free_nids().

if (nm_i->fcnt > NAT_ENTRY_PER_BLOCK)
	return;

So, I don't think this gives us any high latency.
Can the wakeup_all() become another overhead all the time?
Thanks,

> So here we introduce a wait_queue to avoid this issue.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/f2fs/f2fs.h |    1 +
>  fs/f2fs/node.c |   10 +++++++++-
>  2 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index f845e92..7ae193e 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -256,6 +256,7 @@ struct f2fs_nm_info {
>  	spinlock_t free_nid_list_lock;	/* protect free nid list */
>  	unsigned int fcnt;		/* the number of free node id */
>  	struct mutex build_lock;	/* lock for build free nids */
> +	wait_queue_head_t build_wq;	/* wait queue for build free nids */
>  
>  	/* for checkpoint */
>  	char *nat_bitmap;		/* NAT bitmap pointer */
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 4b7861d..ab44711 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1422,7 +1422,13 @@ retry:
>  	spin_lock(&nm_i->free_nid_list_lock);
>  
>  	/* We should not use stale free nids created by build_free_nids */
> -	if (nm_i->fcnt && !on_build_free_nids(nm_i)) {
> +	if (on_build_free_nids(nm_i)) {
> +		spin_unlock(&nm_i->free_nid_list_lock);
> +		wait_event(nm_i->build_wq, !on_build_free_nids(nm_i));
> +		goto retry;
> +	}
> +
> +	if (nm_i->fcnt) {
>  		f2fs_bug_on(list_empty(&nm_i->free_nid_list));
>  		list_for_each(this, &nm_i->free_nid_list) {
>  			i = list_entry(this, struct free_nid, list);
> @@ -1443,6 +1449,7 @@ retry:
>  	mutex_lock(&nm_i->build_lock);
>  	build_free_nids(sbi);
>  	mutex_unlock(&nm_i->build_lock);
> +	wake_up_all(&nm_i->build_wq);
>  	goto retry;
>  }
>  
> @@ -1813,6 +1820,7 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
>  	INIT_LIST_HEAD(&nm_i->dirty_nat_entries);
>  
>  	mutex_init(&nm_i->build_lock);
> +	init_waitqueue_head(&nm_i->build_wq);
>  	spin_lock_init(&nm_i->free_nid_list_lock);
>  	rwlock_init(&nm_i->nat_tree_lock);
>  

-- 
Jaegeuk Kim
Samsung

