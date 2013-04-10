Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965022Ab3DJA02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:26:28 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:35173 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964961Ab3DJA00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:26:26 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 07/10] staging: ramster/debug: Add RAMSTER_DEBUG Kconfig entry 
Date: Wed, 10 Apr 2013 08:25:57 +0800
Message-Id: <1365553560-32258-8-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1365553560-32258-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1365553560-32258-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041000-3864-0000-0000-000007A598BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add RAMSTER_DEBUG Kconfig entry.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/Kconfig |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
index c3b8a10..05e87a1 100644
--- a/drivers/staging/zcache/Kconfig
+++ b/drivers/staging/zcache/Kconfig
@@ -33,6 +33,14 @@ config RAMSTER
 	  zcache2, compresses swap pages into local RAM, but then remotifies
 	  the compressed pages to another node in the RAMster cluster.
 
+config RAMSTER_DEBUG
+        bool "Enable ramster debug statistics"
+        depends on DEBUG_FS && RAMSTER
+        default n
+        help
+          This is used to provide an debugfs directory with counters of
+          how ramster is doing. You probably want to set this to 'N'.
+
 # Depends on not-yet-upstreamed mm patches to export end_swap_bio_write and
 # __add_to_swap_cache, and implement __swap_writepage (which is swap_writepage
 # without the frontswap call. When these are in-tree, the dependency on
-- 
1.7.10.4

