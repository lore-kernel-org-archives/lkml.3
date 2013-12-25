Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab3LYGar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 01:30:47 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53259 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3LYGap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 01:30:45 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v3 0/6] fat: additions to support fat_fallocate
Date: Wed, 25 Dec 2013 15:30:32 +0900
Message-Id: <1387953032-2658-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch set provides support for doing fallocate operation
on FAT filesystem.
After series of review for the the feature
The complete functionality is broken down into smaller subsets.

v3:
 - fix i_disksize and mmu_private comments(uninit/initialized)
 - remove unneeded condition in fat_bmap.
 - use mmu_private instead of fclus in fat_fallocate.
 - make function mark buffer new for block in fallocated region.
 - use flags for bmap.
 - use mmu_private instead of i_size in direct_IO.
 - use flags and remove i_mutex in bmap.
 - update vfat documentation.

v2:
 - remove a stary unlock(from Dan Carpenter)
 - check ->mmu_private and ->i_disksize to truncate uninitialized data.

Namjae Jeon (6):
 fat: add i_disksize to represent uninitialized size
 fat: add fat_fallocate operation
 fat: zero out seek range on _fat_get_block
 fat: fallback to buffered write in case of fallocatded region on direct IO
 fat: permit to return phy block number by fibmap in fallocated region
 fat: update the limitation for fat fallocate
-- 
1.7.9.5

