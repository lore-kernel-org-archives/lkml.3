Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab3LSBYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 20:24:39 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:19351 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3LSBYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 20:24:37 -0500
X-AuditID: cbfee61b-b7fbf6d0000051a3-6a-52b24ac71be8
From: Chao Yu <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>, "'Kim'" <jaegeuk.kim@samsung.com>
Cc: "'fsdevel'" <linux-fsdevel@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'f2fs'" <linux-f2fs-devel@lists.sourceforge.net>
References: <52B17905.7040708@cn.fujitsu.com>
In-reply-to: <52B17905.7040708@cn.fujitsu.com>
Subject: RE: [f2fs-dev] [PATCH] f2fs: move all the bio initialization into
	__bio_alloc
Date: Thu, 19 Dec 2013 09:23:18 +0800
Message-id: <000a01cefc59$0a9b4580$1fd1d080$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ/qLNz/ew2HzK91oUvX39maOu3RJj5XWFQ
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9jQd3jXpuCDM6cVbd43n6A2eL6rr9M
	FpcWuVvs2XuSxeLyrjlsDqwe/w9OYvbYveAzk0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	bFp/i6VgDVtF15lrbA2MPaxdjJwcEgImEhem7mSHsMUkLtxbz9bFyMUhJDCdUeL7v/OMIAkh
	gR+MEk+7fUBsNgEVieUd/5lAbBEBT4k7F3sZQRqYBSYySjy4vJodokFX4vjiY8wgNqeAnsS5
	t5tYQGxhgQiJhxc2gNksAqoSSx/dAavhFbCUuNv4nhHCFpT4MfkeWA2zgJbE+p3HmSBseYnN
	a94yQ1yqILHj7GtGiCOMJFYv/whVIy6x8cgtlgmMQrOQjJqFZNQsJKNmIWlZwMiyilE0tSC5
	oDgpPddIrzgxt7g0L10vOT93EyM4Hp5J72Bc1WBxiFGAg1GJhzfg+cYgIdbEsuLK3EOMEhzM
	SiK8V1g2BQnxpiRWVqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpg
	tOXdrLb0woRrK17VamytCvbvdLzu6nnmyG+HN4smVi5ZPMWA/33fPEb9wmO3nyvb11y9e7zs
	KG/wpMfPI3ql3bu2Gv/cKxlr/Tw+xu/+pED5nx6GLuq5ExYWRk2onv3j46Xd0yY6ZN78ufAt
	e5Wc4Ynqh7NaZUKtD/29/i/j3IYrCgtXmjcecVBiKc5INNRiLipOBAAUl15ogwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

> -----Original Message-----
> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> Sent: Wednesday, December 18, 2013 6:29 PM
> To: Kim
> Cc: fsdevel; linux-kernel; f2fs
> Subject: [f2fs-dev] [PATCH] f2fs: move all the bio initialization into __bio_alloc
> 
> Move all the bio initialization into __bio_alloc, and some minor cleanups are
> also added.

Looks more neat!

> @@ -178,17 +179,16 @@ void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
>  			block_t blk_addr, struct f2fs_io_info *fio)
>  {
>  	enum page_type btype = PAGE_TYPE_OF_BIO(fio->type);
> -	struct block_device *bdev = sbi->sb->s_bdev;
>  	struct f2fs_bio_info *io;
> -	int bio_blocks;
> +	int rw = is_read_io(fio->rw);

Maybe it's more neat to use 'is_read' to instead of 'rw'.

Thanks

