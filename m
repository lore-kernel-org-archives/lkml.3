Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaHMKTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:19:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41416 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaHMKTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:19:35 -0400
X-AuditID: cbfee61a-f79e46d00000134f-f7-53eb3ba35788
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
 <1407872967-26423-4-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1407872967-26423-4-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 04/13] f2fs: clear FI_INC_LINK during the
 recovery
Date: Wed, 13 Aug 2014 18:18:13 +0800
Message-id: <009c01cfb6e0$07d4f480$177edd80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG4wP7f0RrIWMfJUczB9r86/XcZWwKHX/34m+gCgFA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jAd0l1q+DDWbOZrN4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK+Px+aMsBfd4K15f
	/8XYwLiHu4uRk0NCwETi5dMVrBC2mMSFe+vZuhi5OIQEFjFKvJ/wDcr5wSjxaPsmNpAqNgEV
	ieUd/5lAbBEBNYnefVPAbGaBTIkJ/S/YQWwhgWqJ9/O3soDYnALOEks2HWYGsYUFgiUWvXwN
	VMPBwSKgKnH1tTdImFfAUmLZsW42CFtQ4sfkeywQI7Uk1u88DjVeXmLzmrfMEIcqSOw4+5oR
	4gQrickf9rFD1IhLbDxyi2UCo9AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs811CtOzC0u
	zUvXS87P3cQIDvxnUjsYVzZYHGIU4GBU4uGt4H0VLMSaWFZcmXuIUYKDWUmEd43R62Ah3pTE
	yqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwcnFINjMVVQT+OF+k/Fj9y
	4+X/Gx/LDrDNTzk8XedaewSz3usbO9qcrVc9/Fzm5V3Lam+96lSG90XfZcl/G7jOmHX5uwq9
	23xIb1nlvNlG5+tzy0RK2aL4vde0fdhpYZqqwv7O2CDS3bOP+eheltOa1x4c2zBLbsWbDzOd
	WSXOPRF1ufBz//l3y7kiVZVYijMSDbWYi4oTAVaz/Sl4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Wednesday, August 13, 2014 3:49 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 04/13] f2fs: clear FI_INC_LINK during the recovery
> 
> If an inode are fsynced multiple times with fsync & dent marks, this inode will
> set FI_INC_LINK at find_fsync_dnodes during the recovery.
> But, in recover_inode, recover_dentry doesn't clear that flag when multiple hits
> were occurred.
> 
> So this patch removes the flag for the further consistency.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/recovery.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> index fe1c6d9..cfb2aa9 100644
> --- a/fs/f2fs/recovery.c
> +++ b/fs/f2fs/recovery.c
> @@ -62,8 +62,10 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
>  	}
>  retry:
>  	de = f2fs_find_entry(dir, &name, &page);
> -	if (de && inode->i_ino == le32_to_cpu(de->ino))
> +	if (de && inode->i_ino == le32_to_cpu(de->ino)) {
> +		clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
>  		goto out_unmap_put;
> +	}
>  	if (de) {
>  		einode = f2fs_iget(inode->i_sb, le32_to_cpu(de->ino));
>  		if (IS_ERR(einode)) {
> --
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

