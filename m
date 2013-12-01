Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab3LAM4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 07:56:51 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:51483 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3LAM4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 07:56:47 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH v2 0/5] fat: additions to support fat_fallocate
References: <1384688224-2832-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 01 Dec 2013 21:56:44 +0900
In-Reply-To: <1384688224-2832-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 17 Nov 2013 20:37:04 +0900")
Message-ID: <87siucd90z.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> This patch set provides support for doing fallocate operation
> on FAT filesystem.
> After series of review for the the feature
> The complete functionality is broken down into smaller subsets.
>
> v2:
>  - remove a stary unlock(from Dan Carpenter)
>  - check ->mmu_private and ->i_disksize to truncate uninitialized data.
>
> Namjae Jeon (5):
>  fat: add i_disksize to represent uninitialized size
>  fat: add fat_fallocate operation
>  fat: zero out seek range on _fat_get_block
>  fat: fallback to buffered write in case of fallocatded region on direct IO
>  fat: permit to return phy block number by fibmap in fallocated region

Let's add document about FAT's fallocate() behavior to
Documents/filesystem/vfat.txt.

I.e. it will be truncated evict_inode(). So, user has to assume
fallocate() is only valid until last close(), and user has to re-call
fallocate() after re-open to make sure fallocate() region.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
