Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaHMKR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:17:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31160 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaHMKR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:17:56 -0400
X-AuditID: cbfee61a-f79e46d00000134f-02-53eb3b4e5f20
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
 <1407872967-26423-3-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1407872967-26423-3-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 03/13] f2fs: fix the initial inode page for
	recovery
Date: Wed, 13 Aug 2014 18:17:01 +0800
Message-id: <009b01cfb6df$d4ba5fe0$7e2f1fa0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG4wP7f0RrIWMfJUczB9r86/XcZWwIUzzNFm+uWykA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9jAV0/69fBBhN+iFg8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlfH6/x2mgus8FX07
	H7E2MJ7k6mLk5JAQMJH4fuMrE4QtJnHh3nq2LkYuDiGBRYwSV7fuZYVwfjBKPF61FayKTUBF
	YnnHfzBbREBNonffFDCbWSBTYkL/C3YQW0igWmLCsqlgNqeAs8TG1bcYQWxhgVCJdfchtrEI
	qEpsvjODFcTmFbCUuLvhGjOELSjxY/I9FoiZWhLrdx6Hmi8vsXnNW2aISxUkdpx9zQhxg5XE
	/d/9bBA14hIbj9ximcAoNAvJqFlIRs1CMmoWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS
	83M3MYJD/5nUDsaVDRaHGAU4GJV4eCt4XwULsSaWFVfmHmKU4GBWEuFdY/Q6WIg3JbGyKrUo
	P76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVAOjyO+LgarFhq/3XRDcf0lV
	pyt5U9vLOf69n7cx73hW+3Wm1NTHzF0+N3qK1XT5eTudVj41Yde5GXBy3rfAZ7n3d7w+cTwg
	uizTcOYXv3/7Gi96zp0jXmJb0dPepz15yh5u/23P5B8d/LduqvRTrYcrcsSe9uaJuTvosv1e
	NWWTlvV2vdKsTqGbSizFGYmGWsxFxYkAyXWrSHkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Wednesday, August 13, 2014 3:49 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 03/13] f2fs: fix the initial inode page for recovery
> 
> If a new inode page is needed for recover_dentry, we should assing i_inline
> as zero.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/node.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 1f33299..093d799 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1651,6 +1651,7 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
>  	dst->i_blocks = cpu_to_le64(1);
>  	dst->i_links = cpu_to_le32(1);
>  	dst->i_xattr_nid = 0;
> +	dst->i_inline = src->i_inline & F2FS_INLINE_XATTR;
> 
>  	new_ni = old_ni;
>  	new_ni.ino = ino;
> @@ -1659,6 +1660,7 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
>  		WARN_ON(1);
>  	set_node_addr(sbi, &new_ni, NEW_ADDR, false);
>  	inc_valid_inode_count(sbi);
> +	set_page_dirty(ipage);
>  	f2fs_put_page(ipage, 1);
>  	return 0;
>  }
> --
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

