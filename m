Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbaHVIOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:14:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11795 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbaHVIO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:14:26 -0400
X-AuditID: cbfee61b-f79f86d00000144c-3b-53f6fbd83243
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <008201cfbc63$0042b670$00c82350$@samsung.com>
 <20140821205013.GC85961@jaegeuk-mac02.mot-mobility.com>
In-reply-to: <20140821205013.GC85961@jaegeuk-mac02.mot-mobility.com>
Subject: RE: [f2fs-dev] [PATCH 3/3] f2fs: use macro for code readability
Date: Fri, 22 Aug 2014 16:13:34 +0800
Message-id: <000001cfbde1$108b0030$31a10090$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIpt89AhdFksbO9bcoyqB9QoA785QHGopfcmxockyA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t9jAd0bv78FG0xuUrJ4sn4Ws8WlRe4W
	l3fNYXNg9ti0qpPNY/eCz0wenzfJBTBHcdmkpOZklqUW6dslcGUcOzeftWCaacWyxg7GBsY7
	Wl2MnBwSAiYSPeefs0HYYhIX7q0Hsrk4hAQWMUo8PjqdBSQhJPCDUeLI1FwQm01ARWJ5x38m
	EFtEQE2id98UIJuDg1nAQ2LXsVKI8mKJt9uvg5VwCrhItCyeD2YLA5V0N0xmB7FZBFQlfq7d
	D9bKK2ApceWYJkiYV0BQ4sfke2BbmQW0JNbvPM4EYctLbF7zlhniTAWJHWdfM0JcYCXRsPY0
	VL24xMYjt1gmMArNQjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M
	4FB/Jr2DcVWDxSFGAQ5GJR7eiC9fg4VYE8uKK3MPMUpwMCuJ8G6a9y1YiDclsbIqtSg/vqg0
	J7X4EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA2NUfU1KTlXE20CVNx9XGsxXytKP
	3HPympSV6d32Rcekfy/u0rOZMtv9sOaMDNG/P2641h7h+bMheOm6809+sHxQC9Z9NyV3ibRX
	XrWbyOQJe6ofvGIIlXOzm/z0T6jgybwphzOWpBav0/XYuCrgxsWam4tjRPrSekutzhqqbdi9
	4Lhcl5b+/o9KLMUZiYZazEXFiQD9iV3DcQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Friday, August 22, 2014 4:50 AM
> To: Chao Yu
> Cc: linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH 3/3] f2fs: use macro for code readability
> 
> On Wed, Aug 20, 2014 at 06:38:40PM +0800, Chao Yu wrote:
> > This patch introduces DEF_NIDS_PER_INODE/GET_ORPHAN_BLOCKS/F2FS_CP_PARK_NUM macro
> 
> F2FS_CP_PACKS?

That's my mistake, will fix.

Thanks for the review.

> 
> > instead of numbers in code for readability.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/checkpoint.c    | 21 ++++++++++-----------
> >  include/linux/f2fs_fs.h | 13 ++++++++++---
> >  2 files changed, 20 insertions(+), 14 deletions(-)
> >
> > diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> > index 6aeed5b..b0b6079 100644
> > --- a/fs/f2fs/checkpoint.c
> > +++ b/fs/f2fs/checkpoint.c
> > @@ -446,8 +446,8 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t
> start_blk)
> >  	struct f2fs_orphan_block *orphan_blk = NULL;
> >  	unsigned int nentries = 0;
> >  	unsigned short index;
> > -	unsigned short orphan_blocks = (unsigned short)((sbi->n_orphans +
> > -		(F2FS_ORPHANS_PER_BLOCK - 1)) / F2FS_ORPHANS_PER_BLOCK);
> > +	unsigned short orphan_blocks =
> > +			(unsigned short)GET_ORPHAN_BLOCKS(sbi->n_orphans);
> >  	struct page *page = NULL;
> >  	struct ino_entry *orphan = NULL;
> >
> > @@ -825,7 +825,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
> >  	ckpt->elapsed_time = cpu_to_le64(get_mtime(sbi));
> >  	ckpt->valid_block_count = cpu_to_le64(valid_user_blocks(sbi));
> >  	ckpt->free_segment_count = cpu_to_le32(free_segments(sbi));
> > -	for (i = 0; i < 3; i++) {
> > +	for (i = 0; i < NR_CURSEG_NODE_TYPE; i++) {
> >  		ckpt->cur_node_segno[i] =
> >  			cpu_to_le32(curseg_segno(sbi, i + CURSEG_HOT_NODE));
> >  		ckpt->cur_node_blkoff[i] =
> > @@ -833,7 +833,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
> >  		ckpt->alloc_type[i + CURSEG_HOT_NODE] =
> >  				curseg_alloc_type(sbi, i + CURSEG_HOT_NODE);
> >  	}
> > -	for (i = 0; i < 3; i++) {
> > +	for (i = 0; i < NR_CURSEG_DATA_TYPE; i++) {
> >  		ckpt->cur_data_segno[i] =
> >  			cpu_to_le32(curseg_segno(sbi, i + CURSEG_HOT_DATA));
> >  		ckpt->cur_data_blkoff[i] =
> > @@ -848,24 +848,23 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
> >
> >  	/* 2 cp  + n data seg summary + orphan inode blocks */
> >  	data_sum_blocks = npages_for_summary_flush(sbi);
> > -	if (data_sum_blocks < 3)
> > +	if (data_sum_blocks < NR_CURSEG_DATA_TYPE)
> >  		set_ckpt_flags(ckpt, CP_COMPACT_SUM_FLAG);
> >  	else
> >  		clear_ckpt_flags(ckpt, CP_COMPACT_SUM_FLAG);
> >
> > -	orphan_blocks = (sbi->n_orphans + F2FS_ORPHANS_PER_BLOCK - 1)
> > -					/ F2FS_ORPHANS_PER_BLOCK;
> > +	orphan_blocks = GET_ORPHAN_BLOCKS(sbi->n_orphans);
> >  	ckpt->cp_pack_start_sum = cpu_to_le32(1 + cp_payload_blks +
> >  			orphan_blocks);
> >
> >  	if (is_umount) {
> >  		set_ckpt_flags(ckpt, CP_UMOUNT_FLAG);
> > -		ckpt->cp_pack_total_block_count = cpu_to_le32(2 +
> > +		ckpt->cp_pack_total_block_count = cpu_to_le32(F2FS_CP_PARK_NUM +
> >  				cp_payload_blks + data_sum_blocks +
> >  				orphan_blocks + NR_CURSEG_NODE_TYPE);
> >  	} else {
> >  		clear_ckpt_flags(ckpt, CP_UMOUNT_FLAG);
> > -		ckpt->cp_pack_total_block_count = cpu_to_le32(2 +
> > +		ckpt->cp_pack_total_block_count = cpu_to_le32(F2FS_CP_PARK_NUM +
> >  				cp_payload_blks + data_sum_blocks +
> >  				orphan_blocks);
> >  	}
> > @@ -999,8 +998,8 @@ void init_ino_entry_info(struct f2fs_sb_info *sbi)
> >  	 * for cp pack we can have max 1020*504 orphan entries
> >  	 */
> >  	sbi->n_orphans = 0;
> > -	sbi->max_orphans = (sbi->blocks_per_seg - 2 - NR_CURSEG_TYPE)
> > -				* F2FS_ORPHANS_PER_BLOCK;
> > +	sbi->max_orphans = (sbi->blocks_per_seg - F2FS_CP_PARK_NUM -
> > +			NR_CURSEG_TYPE) * F2FS_ORPHANS_PER_BLOCK;
> >  }
> >
> >  int __init create_checkpoint_caches(void)
> > diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
> > index 0ed77f3..f3cca5b 100644
> > --- a/include/linux/f2fs_fs.h
> > +++ b/include/linux/f2fs_fs.h
> > @@ -90,6 +90,8 @@ struct f2fs_super_block {
> >  #define CP_ORPHAN_PRESENT_FLAG	0x00000002
> >  #define CP_UMOUNT_FLAG		0x00000001
> >
> > +#define F2FS_CP_PARK_NUM	2	/* # of checkpoint packs */
> > +
> >  struct f2fs_checkpoint {
> >  	__le64 checkpoint_ver;		/* checkpoint block version number */
> >  	__le64 user_block_count;	/* # of user blocks */
> > @@ -126,6 +128,9 @@ struct f2fs_checkpoint {
> >   */
> >  #define F2FS_ORPHANS_PER_BLOCK	1020
> >
> > +#define GET_ORPHAN_BLOCKS(n)	((n + F2FS_ORPHANS_PER_BLOCK - 1) / \
> > +					F2FS_ORPHANS_PER_BLOCK)
> > +
> >  struct f2fs_orphan_block {
> >  	__le32 ino[F2FS_ORPHANS_PER_BLOCK];	/* inode numbers */
> >  	__le32 reserved;	/* reserved */
> > @@ -147,6 +152,7 @@ struct f2fs_extent {
> >  #define F2FS_NAME_LEN		255
> >  #define F2FS_INLINE_XATTR_ADDRS	50	/* 200 bytes for inline xattrs */
> >  #define DEF_ADDRS_PER_INODE	923	/* Address Pointers in an Inode */
> > +#define DEF_NIDS_PER_INODE	5	/* Node IDs in an Inode */
> >  #define ADDRS_PER_INODE(fi)	addrs_per_inode(fi)
> >  #define ADDRS_PER_BLOCK		1018	/* Address Pointers in a Direct Block */
> >  #define NIDS_PER_BLOCK		1018	/* Node IDs in an Indirect Block */
> > @@ -166,8 +172,9 @@ struct f2fs_extent {
> >  #define MAX_INLINE_DATA		(sizeof(__le32) * (DEF_ADDRS_PER_INODE - \
> >  						F2FS_INLINE_XATTR_ADDRS - 1))
> >
> > -#define INLINE_DATA_OFFSET	(PAGE_CACHE_SIZE - sizeof(struct node_footer) \
> > -			- sizeof(__le32) * (DEF_ADDRS_PER_INODE + 5 - 1))
> > +#define INLINE_DATA_OFFSET	(PAGE_CACHE_SIZE - sizeof(struct node_footer) -\
> > +				sizeof(__le32) * (DEF_ADDRS_PER_INODE + \
> > +				DEF_NIDS_PER_INODE - 1))
> >
> >  struct f2fs_inode {
> >  	__le16 i_mode;			/* file mode */
> > @@ -197,7 +204,7 @@ struct f2fs_inode {
> >
> >  	__le32 i_addr[DEF_ADDRS_PER_INODE];	/* Pointers to data blocks */
> >
> > -	__le32 i_nid[5];		/* direct(2), indirect(2),
> > +	__le32 i_nid[DEF_NIDS_PER_INODE];	/* direct(2), indirect(2),
> >  						double_indirect(1) node id */
> >  } __packed;
> >
> > --
> > 2.0.1.474.g72c7794
> >
> >
> >
> > ------------------------------------------------------------------------------
> > Slashdot TV.
> > Video for Nerds.  Stuff that matters.
> > http://tv.slashdot.org/
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

