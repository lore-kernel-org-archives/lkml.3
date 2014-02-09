Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaBINDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:03:21 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:62342 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaBINDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:03:20 -0500
Date: Sun, 9 Feb 2014 18:33:15 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@tonian.com>,
        osd-dev@open-osd.org, josh@joshtriplett.org
Subject: [PATCH 06/21] fs: Mark functions as static in exofs/ore_raid.c
Message-ID: <c7023ae39eb310552ec4b0bda28f5b259d0ce774.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in exofs/ore_raid.c because they are not used
outside this file.

This also eliminates the following warning in exofs/ore_raid.c:
fs/exofs/ore_raid.c:24:14: warning: no previous prototype for ‘_raid_page_alloc’ [-Wmissing-prototypes]
fs/exofs/ore_raid.c:29:6: warning: no previous prototype for ‘_raid_page_free’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/exofs/ore_raid.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exofs/ore_raid.c b/fs/exofs/ore_raid.c
index 7682b97..4e2c032 100644
--- a/fs/exofs/ore_raid.c
+++ b/fs/exofs/ore_raid.c
@@ -21,12 +21,12 @@
 #undef ORE_DBGMSG2
 #define ORE_DBGMSG2 ORE_DBGMSG
 
-struct page *_raid_page_alloc(void)
+static struct page *_raid_page_alloc(void)
 {
 	return alloc_page(GFP_KERNEL);
 }
 
-void _raid_page_free(struct page *p)
+static void _raid_page_free(struct page *p)
 {
 	__free_page(p);
 }
-- 
1.7.9.5

