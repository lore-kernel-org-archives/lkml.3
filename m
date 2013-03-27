Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab3C0Blt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 21:41:49 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43834 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab3C0Blr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 21:41:47 -0400
MIME-Version: 1.0
In-Reply-To: <1364168414-12815-4-git-send-email-jaegeuk.kim@samsung.com>
References: <1364168414-12815-1-git-send-email-jaegeuk.kim@samsung.com>
	<1364168414-12815-4-git-send-email-jaegeuk.kim@samsung.com>
Date: Wed, 27 Mar 2013 10:34:42 +0900
Message-ID: <CAKYAXd-FuHuzP1jxk-XNgQo3D7XzC1B2HFSU9dtCdDJg5bMxPA@mail.gmail.com>
Subject: Re: [PATCH 4/4] f2fs: fix to give correct parent inode number for
 roll forward
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   */
> -static inline void set_cold_file(struct f2fs_sb_info *sbi, struct inode
> *inode,
> +static inline void set_cold_files(struct f2fs_sb_info *sbi, struct inode
> *inode,
>  		const unsigned char *name)
>  {
>  	int i;
> @@ -108,7 +109,7 @@ static inline void set_cold_file(struct f2fs_sb_info
> *sbi, struct inode *inode,
>  	int count = le32_to_cpu(sbi->raw_super->extension_count);
>  	for (i = 0; i < count; i++) {
>  		if (!is_multimedia_file(name, extlist[i])) {
> -			F2FS_I(inode)->i_advise |= FADVISE_COLD_BIT;
> +			set_cold_file(inode);
>  			break;
>  		}
>  	}
It is just my private opinion.
How about use this name "set_cold_file_from_list instead of set_cold_files ?

Thanks.
