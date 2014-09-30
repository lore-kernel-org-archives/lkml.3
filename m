Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaI3WAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:00:50 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:61465 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbaI3WAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:00:47 -0400
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Zach Brown <zab@zabbo.net>
Subject: [PATCH v2 0/3] btrfs: fix several sparse warnings
Date: Tue, 30 Sep 2014 15:01:39 -0700
Message-Id: <cover.1412114127.git.osandov@osandov.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes some warnings reported by sparse when building the
btrfs module. It fixes two classes of warnings: address space warnings and lock
context warnings. This didn't uncover any logical errors, but it reduces the
noise when checking the source. There are a few less straightforward sparse
warnings still remaining.

Version 2 replaces an open-coded implementation of kernel_write in write_buf,
doesn't touch unrelated style issues, and add's David's Reviewed-by.

This patch series applies to 3.17-rc7.

Omar Sandoval (3):
  btrfs: replace open-coded kernel_write
  btrfs: fix sparse address space warnings
  btrfs: fix sparse lock context warnings

 fs/btrfs/extent-tree.c      |  1 +
 fs/btrfs/extent_io.c        |  2 +-
 fs/btrfs/free-space-cache.c |  1 +
 fs/btrfs/ioctl.c            |  6 +++---
 fs/btrfs/locking.c          |  1 +
 fs/btrfs/send.c             | 21 ++++++---------------
 6 files changed, 13 insertions(+), 19 deletions(-)

-- 
2.1.1

