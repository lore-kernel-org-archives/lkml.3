Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333AbaDUH0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 03:26:43 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:41820 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaDUH0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 03:26:41 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Conrad Meyer <cse.cem@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] fs: FAT: Add support for DOS 1.x formatted volumes
References: <1397526957-11471-1-git-send-email-cse.cem@gmail.com>
Date: Mon, 21 Apr 2014 16:26:37 +0900
In-Reply-To: <1397526957-11471-1-git-send-email-cse.cem@gmail.com> (Conrad
	Meyer's message of "Mon, 14 Apr 2014 18:55:57 -0700")
Message-ID: <87sip7dtxu.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conrad Meyer <cse.cem@gmail.com> writes:

> +/*
> + * A deserialized copy of the on-disk structure laid out in struct
> + * fat_boot_sector.
> + */
> +struct fat_bios_param_block {
> +	u16	fat_sector_size;
> +	u8	fat_sec_per_clus;
> +	u16	fat_reserved;
> +	u8	fat_fats;
> +	u16	fat_dir_entries;
> +	u16	fat_sectors;
> +	u16	fat_fat_length;
> +	u32	fat_total_sect;
> +
> +	u8	fat16_state;
> +	u32	fat16_vol_id;
> +
> +	u32	fat32_length;
> +	u32	fat32_root_cluster;
> +	u16	fat32_info_sector;
> +	u8	fat32_state;
> +	u32	fat32_vol_id;
> +
> +};

Looks good. But nobody use this structure except fat_fill_inode(). So,
please move this into inode.c.

With above last change,

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
