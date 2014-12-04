Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaLDHYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 02:24:37 -0500
Received: from mga03.intel.com ([134.134.136.65]:9719 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbaLDHYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 02:24:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="493402162"
Date: Thu, 4 Dec 2014 15:24:22 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Andrea Mazzoleni <amadvance@gmail.com>
Cc: kbuild-all@01.org, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH md] lib: raid: raid_cauchy_init() can be static
Message-ID: <20141204072422.GA4898@snb.sh.intel.com>
References: <201412041540.JqqRoMLc%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201412041540.JqqRoMLc%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lib/raid/module.c:417:12: sparse: symbol 'raid_cauchy_init' was not declared. Should it be static?
lib/raid/raid.c:156:9: sparse: symbol 'raid_zero_block' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 module.c |    2 +-
 raid.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/raid/module.c b/lib/raid/module.c
index 8d45ab4..37962b0 100644
--- a/lib/raid/module.c
+++ b/lib/raid/module.c
@@ -414,7 +414,7 @@ int raid_speedtest(int displacement)
 #ifdef __KERNEL__ /* to build the user mode test */
 static int speedtest;
 
-int __init raid_cauchy_init(void)
+static int __init raid_cauchy_init(void)
 {
 	int ret;
 
diff --git a/lib/raid/raid.c b/lib/raid/raid.c
index e1b1660..c662f97 100644
--- a/lib/raid/raid.c
+++ b/lib/raid/raid.c
@@ -153,7 +153,7 @@
 /**
  * Buffer filled with 0 used in recovering.
  */
-uint8_t raid_zero_block[PAGE_SIZE] __aligned(256);
+static uint8_t raid_zero_block[PAGE_SIZE] __aligned(256);
 
 #ifdef RAID_USE_XOR_BLOCKS
 /*
