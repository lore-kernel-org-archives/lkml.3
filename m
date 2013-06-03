Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab3FCKEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:04:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:18169 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab3FCKEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:04:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,791,1363158000"; 
   d="scan'208";a="249941708"
From: Huajun Li <huajun.li@intel.com>
To: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        huajun.li.lee@gmail.com
Cc: namjae.jeon@samsung.com, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Huajun Li <huajun.li@intel.com>
Subject: [RFC 0/5] Enable f2fs support inline data
Date: Mon,  3 Jun 2013 18:04:09 +0800
Message-Id: <1370253854-15084-1-git-send-email-huajun.li@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

f2fs inode is so large, small files can be stored directly in the inode,
rather than just storing a single block address and storing the data elsewhere.

This RFC patch set is just to enable f2fs support inline data: files less than
about 3.6K can be stored directly in inode block.

TODO: make small dirs inline too.


Haicheng Li (3):
  f2fs: Add helper functions and flag to support inline data
  f2fs: Add interface for inline data support
  f2fs: add tracepoints to debug inline data operations

Huajun Li (2):
  f2fs: Handle inline data read and write
  f2fs: Key functions to handle inline data

 fs/f2fs/Kconfig             |   10 +++
 fs/f2fs/Makefile            |    1 +
 fs/f2fs/data.c              |   78 +++++++++++++++++++++-
 fs/f2fs/f2fs.h              |   70 +++++++++++++++++++
 fs/f2fs/file.c              |    9 ++-
 fs/f2fs/inline.c            |  156 +++++++++++++++++++++++++++++++++++++++++++
 fs/f2fs/inode.c             |    8 +++
 include/linux/f2fs_fs.h     |    5 ++
 include/trace/events/f2fs.h |   69 +++++++++++++++++++
 9 files changed, 402 insertions(+), 4 deletions(-)
 create mode 100644 fs/f2fs/inline.c

-- 
1.7.9.5

