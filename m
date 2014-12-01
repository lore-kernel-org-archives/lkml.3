Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaLAQtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:49:42 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37663 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbaLAQtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:49:39 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-nilfs <linux-nilfs@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 0/3] a few nilfs2 updates for 3.19
Date: Tue,  2 Dec 2014 01:41:44 +0900
Message-Id: <1417452107-6411-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.8.3.1
X-Dispatcher: imput version 20110525(IM151)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Please add the following patches to the queue for the next merge
window.

Andreas's one simplifies nilfs_sync_file() function to avoid duplicate
segment construction on fsync(), and mine fixes a race issue between
nilfs_iget() and nilfs_new_inode().  Markus's one removes an
unnecessary NULL check related to iput().

Thanks,
Ryusuke Konishi
--
Andreas Rohner (1):
      nilfs2: avoid duplicate segment construction for fsync()

Markus Elfring (1):
      nilfs2: Deletion of an unnecessary check before the function call "iput"

Ryusuke Konishi (1):
      nilfs2: fix the nilfs_iget() vs. nilfs_new_inode() races

 fs/nilfs2/file.c      | 21 ++++++++-------------
 fs/nilfs2/inode.c     | 32 ++++++++++++++++++++++++--------
 fs/nilfs2/namei.c     | 15 ++++++++++++---
 fs/nilfs2/the_nilfs.c |  3 +--
 4 files changed, 45 insertions(+), 26 deletions(-)

