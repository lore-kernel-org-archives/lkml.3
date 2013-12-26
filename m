Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab3LZJZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 04:25:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:39492 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab3LZJZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 04:25:48 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-5f-52bbf61a6bc1
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1388045841-32165-1-git-send-email-jaegeuk.kim@samsung.com>
In-reply-to: <1388045841-32165-1-git-send-email-jaegeuk.kim@samsung.com>
Subject: RE: [f2fs-dev] [PATCH 1/2] f2fs: introduce F2FS_INODE macro to get
	f2fs_inode
Date: Thu, 26 Dec 2013 17:24:32 +0800
Message-id: <000101cf021c$72cdbf20$58693d60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFstHTBDPLot6bvskJNKrolzrrEh5sqy5Tw
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9jQV2pb7uDDB5+Vra4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+Nw42XWgiMWFQf+
	bGBqYNys28XIySEhYCLx6OJ+FghbTOLCvfVsXYxcHEIC0xklHi47wg6SEBL4wSjRfb4AxGYT
	UJFY3vGfCcQWEdCW+Dm3FayGWSBTYs7ryawQ9e4SW3bNYwSxOQU8JPY1bAOzhQUiJHpm/gKy
	OThYBFQlHv13AQnzClhKbNx5jhHCFpT4MfkeC8RILYn1O48zQdjyEpvXvGWGuFNBYsfZ14wQ
	JxhJrP70nhWiRlxi45FbLBMYhWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFp
	Xrpecn7uJkZw2D+T2sG4ssHiEKMAB6MSD2+H7u4gIdbEsuLK3EOMEhzMSiK8k94BhXhTEiur
	Uovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5NLUgtgskycXBKNTDmvJNvrG1sND59+e6H
	wuBzh1cq/TVSW5jK8uPM/bRXjd/+zzOImDtbdPv351qPw4PDMhf+3P1hsXz5KZ6CtJVH+otf
	PQjOfNzf4CV25J6cxBTRzeFiLm0Xb3168O6AXtoFU+anxzJVNplHWa4z5agQqnHbJxl/ufBA
	n0JSoWeOaNnV7o2FmV+VWIozEg21mIuKEwELEbbidwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Thursday, December 26, 2013 4:17 PM
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: [f2fs-dev] [PATCH 1/2] f2fs: introduce F2FS_INODE macro to get f2fs_inode
> 
> This patch introduces F2FS_INODE that returns struct f2fs_inode * from the inode
> page.
> By using this macro, we can remove unnecessary casting codes like below.
> 
>    struct f2fs_inode *ri = &F2FS_NODE(inode_page)->i;
> -> struct f2fs_inode *ri = F2FS_INODE(inode_page);

Looks Nice!

Could we apply this to recover_inode_page?
It seems that we just use inode data only.

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/dir.c      |  8 ++++----
>  fs/f2fs/f2fs.h     |  5 +++++
>  fs/f2fs/inode.c    |  8 ++------
>  fs/f2fs/node.c     | 14 +++++++-------
>  fs/f2fs/recovery.c |  6 ++----
>  5 files changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index f0b4630..6da77e5 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -261,12 +261,12 @@ void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
> 
>  static void init_dent_inode(const struct qstr *name, struct page *ipage)
>  {
> -	struct f2fs_node *rn;
> +	struct f2fs_inode *ri;
> 
>  	/* copy name info. to this inode page */
> -	rn = F2FS_NODE(ipage);
> -	rn->i.i_namelen = cpu_to_le32(name->len);
> -	memcpy(rn->i.i_name, name->name, name->len);
> +	ri = F2FS_INODE(ipage);
> +	ri->i_namelen = cpu_to_le32(name->len);
> +	memcpy(ri->i_name, name->name, name->len);
>  	set_page_dirty(ipage);
>  }
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index ba91186..1a06f0a 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -498,6 +498,11 @@ static inline struct f2fs_node *F2FS_NODE(struct page *page)
>  	return (struct f2fs_node *)page_address(page);
>  }
> 
> +static inline struct f2fs_inode *F2FS_INODE(struct page *page)
> +{
> +	return &((struct f2fs_node *)page_address(page))->i;
> +}
> +
>  static inline struct f2fs_nm_info *NM_I(struct f2fs_sb_info *sbi)
>  {
>  	return (struct f2fs_nm_info *)(sbi->nm_info);
> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> index d0eaa9f..a91f451 100644
> --- a/fs/f2fs/inode.c
> +++ b/fs/f2fs/inode.c
> @@ -67,7 +67,6 @@ static int do_read_inode(struct inode *inode)
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>  	struct f2fs_inode_info *fi = F2FS_I(inode);
>  	struct page *node_page;
> -	struct f2fs_node *rn;
>  	struct f2fs_inode *ri;
> 
>  	/* Check if ino is within scope */
> @@ -81,8 +80,7 @@ static int do_read_inode(struct inode *inode)
>  	if (IS_ERR(node_page))
>  		return PTR_ERR(node_page);
> 
> -	rn = F2FS_NODE(node_page);
> -	ri = &(rn->i);
> +	ri = F2FS_INODE(node_page);
> 
>  	inode->i_mode = le16_to_cpu(ri->i_mode);
>  	i_uid_write(inode, le32_to_cpu(ri->i_uid));
> @@ -175,13 +173,11 @@ bad_inode:
> 
>  void update_inode(struct inode *inode, struct page *node_page)
>  {
> -	struct f2fs_node *rn;
>  	struct f2fs_inode *ri;
> 
>  	f2fs_wait_on_page_writeback(node_page, NODE, false);
> 
> -	rn = F2FS_NODE(node_page);
> -	ri = &(rn->i);
> +	ri = F2FS_INODE(node_page);
> 
>  	ri->i_mode = cpu_to_le16(inode->i_mode);
>  	ri->i_advise = F2FS_I(inode)->i_advise;
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index e8fe52d..6fdd88c 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -684,7 +684,7 @@ int truncate_inode_blocks(struct inode *inode, pgoff_t from)
>  	int err = 0, cont = 1;
>  	int level, offset[4], noffset[4];
>  	unsigned int nofs = 0;
> -	struct f2fs_node *rn;
> +	struct f2fs_inode *ri;
>  	struct dnode_of_data dn;
>  	struct page *page;
> 
> @@ -701,7 +701,7 @@ restart:
>  	set_new_dnode(&dn, inode, page, NULL, 0);
>  	unlock_page(page);
> 
> -	rn = F2FS_NODE(page);
> +	ri = F2FS_INODE(page);
>  	switch (level) {
>  	case 0:
>  	case 1:
> @@ -711,7 +711,7 @@ restart:
>  		nofs = noffset[1];
>  		if (!offset[level - 1])
>  			goto skip_partial;
> -		err = truncate_partial_nodes(&dn, &rn->i, offset, level);
> +		err = truncate_partial_nodes(&dn, ri, offset, level);
>  		if (err < 0 && err != -ENOENT)
>  			goto fail;
>  		nofs += 1 + NIDS_PER_BLOCK;
> @@ -720,7 +720,7 @@ restart:
>  		nofs = 5 + 2 * NIDS_PER_BLOCK;
>  		if (!offset[level - 1])
>  			goto skip_partial;
> -		err = truncate_partial_nodes(&dn, &rn->i, offset, level);
> +		err = truncate_partial_nodes(&dn, ri, offset, level);
>  		if (err < 0 && err != -ENOENT)
>  			goto fail;
>  		break;
> @@ -730,7 +730,7 @@ restart:
> 
>  skip_partial:
>  	while (cont) {
> -		dn.nid = le32_to_cpu(rn->i.i_nid[offset[0] - NODE_DIR1_BLOCK]);
> +		dn.nid = le32_to_cpu(ri->i_nid[offset[0] - NODE_DIR1_BLOCK]);
>  		switch (offset[0]) {
>  		case NODE_DIR1_BLOCK:
>  		case NODE_DIR2_BLOCK:
> @@ -753,14 +753,14 @@ skip_partial:
>  		if (err < 0 && err != -ENOENT)
>  			goto fail;
>  		if (offset[1] == 0 &&
> -				rn->i.i_nid[offset[0] - NODE_DIR1_BLOCK]) {
> +				ri->i_nid[offset[0] - NODE_DIR1_BLOCK]) {
>  			lock_page(page);
>  			if (unlikely(page->mapping != node_mapping)) {
>  				f2fs_put_page(page, 1);
>  				goto restart;
>  			}
>  			wait_on_page_writeback(page);
> -			rn->i.i_nid[offset[0] - NODE_DIR1_BLOCK] = 0;
> +			ri->i_nid[offset[0] - NODE_DIR1_BLOCK] = 0;
>  			set_page_dirty(page);
>  			unlock_page(page);
>  		}
> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> index 4d411a2..96e690b6 100644
> --- a/fs/f2fs/recovery.c
> +++ b/fs/f2fs/recovery.c
> @@ -40,8 +40,7 @@ static struct fsync_inode_entry *get_fsync_inode(struct list_head *head,
> 
>  static int recover_dentry(struct page *ipage, struct inode *inode)
>  {
> -	struct f2fs_node *raw_node = F2FS_NODE(ipage);
> -	struct f2fs_inode *raw_inode = &(raw_node->i);
> +	struct f2fs_inode *raw_inode = F2FS_INODE(ipage);
>  	nid_t pino = le32_to_cpu(raw_inode->i_pino);
>  	struct f2fs_dir_entry *de;
>  	struct qstr name;
> @@ -105,8 +104,7 @@ out:
> 
>  static int recover_inode(struct inode *inode, struct page *node_page)
>  {
> -	struct f2fs_node *raw_node = F2FS_NODE(node_page);
> -	struct f2fs_inode *raw_inode = &(raw_node->i);
> +	struct f2fs_inode *raw_inode = F2FS_INODE(node_page);
> 
>  	if (!IS_INODE(node_page))
>  		return 0;
> --
> 1.8.4.474.g128a96c
> 
> 
> ------------------------------------------------------------------------------
> Rapidly troubleshoot problems before they affect your business. Most IT
> organizations don't have a clear picture of how application performance
> affects their revenue. With AppDynamics, you get 100% visibility into your
> Java,.NET, & PHP application. Start your 15-day FREE TRIAL of AppDynamics Pro!
> http://pubads.g.doubleclick.net/gampad/clk?id=84349831&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

