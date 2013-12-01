Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab3LAMch (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 07:32:37 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:51461 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3LAMce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 07:32:34 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 2/5] fat: add fat_fallocate operation
References: <1384688277-2901-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 01 Dec 2013 21:32:30 +0900
In-Reply-To: <1384688277-2901-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 17 Nov 2013 20:37:57 +0900")
Message-ID: <87a9gkeopt.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> +			err = fat_get_cluster(inode, FAT_ENT_EOF,
> +					&fclus, &dclus);
> +			if (err < 0) {
> +				fat_msg(sb, KERN_ERR,
> +					"fat_fallocate(): fat_get_cluster() error");
> +				goto error;
> +			}
> +			free_bytes = ((fclus + 1) << sbi->cluster_bits) -
> +				inode->i_size;

What is wrong if we just used ->mmu_private here, instead of fclus?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
