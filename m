Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3KQLhu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 06:37:50 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:47612 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3KQLhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 06:37:41 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v2 0/5] fat: additions to support fat_fallocate
Date: Sun, 17 Nov 2013 20:37:04 +0900
Message-Id: <1384688224-2832-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch set provides support for doing fallocate operation
on FAT filesystem.
After series of review for the the feature
The complete functionality is broken down into smaller subsets.

v2:
 - remove a stary unlock(from Dan Carpenter)
 - check ->mmu_private and ->i_disksize to truncate uninitialized data.

Namjae Jeon (5):
 fat: add i_disksize to represent uninitialized size
 fat: add fat_fallocate operation
 fat: zero out seek range on _fat_get_block
 fat: fallback to buffered write in case of fallocatded region on direct IO
 fat: permit to return phy block number by fibmap in fallocated region
-- 
1.7.9.5

