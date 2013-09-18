Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab3IRR17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:27:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:64401 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab3IRR16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:27:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,930,1371106800"; 
   d="scan'208";a="362398769"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] pstore/compression fixes
Date: Wed, 18 Sep 2013 10:27:57 -0700
Message-Id: <5239e29d26989e9096@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e831cbfc1ad843b5542cc45f777e1a00b73c0685:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux (2013-09-11 08:36:03 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git tags/please-pull-pstore

for you to fetch changes up to 802e4c6f5887205eda110c6bfb90c9bfa93dc8a7:

  pstore: Remove the messages related to compression failure (2013-09-16 09:28:29 -0700)

----------------------------------------------------------------
Three pstore fixes related to compression:
1) Better adjustment of size of compression buffer (was too big
   for EFIVARS backend resulting in compression failure
2) Use zlib_inflateInit2 instead of zlib_inflateInit
3) Don't print messages about compression failure.  They will
   waste space that may better be used to log console output
   leading to the crash.

----------------------------------------------------------------
Aruna Balakrishnaiah (3):
      pstore: Adjust buffer size for compression for smaller registered buffers
      pstore: Use zlib_inflateInit2 instead of zlib_inflateInit
      pstore: Remove the messages related to compression failure

 fs/pstore/platform.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)
