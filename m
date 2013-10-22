Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab3JVVE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:04:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:20276 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab3JVVEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:04:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="396955986"
From: Andrew Boie <andrew.p.boie@intel.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, tglx@linutronix.de, mmarek@suse.cz,
        Andrew Boie <andrew.p.boie@intel.com>
Subject: [PATCH 0/1] compress kernels with minigzip
Date: Tue, 22 Oct 2013 14:07:20 -0700
Message-Id: <1382476041-1115-1-git-send-email-andrew.p.boie@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is for building kernels on x86-based Android devices.
The binary patches created by its OTA system work much better if
the deflate() algorithm inside zlib is used, rather than the
older version inside gzip.

This patch was committed against the master branch of Linus'
tree.

Andrew Boie (1):
  x86: boot: support minigzip bzImage compression

 arch/x86/Kconfig                  |  1 +
 arch/x86/boot/compressed/Makefile |  3 +++
 arch/x86/boot/compressed/misc.c   |  2 +-
 init/Kconfig                      | 18 +++++++++++++++++-
 scripts/Makefile.lib              |  7 +++++++
 5 files changed, 29 insertions(+), 2 deletions(-)

-- 
1.8.3.2

