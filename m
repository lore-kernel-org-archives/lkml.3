Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab3AWVrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 16:47:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39644 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3AWVqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 16:46:54 -0500
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, ngupta@vflare.org,
        konrad.wilk@oracle.com, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org, dan.magenheimer@oracle.com
Subject: [PATCH 1/2] staging: zcache: fix ppc64 and other arches where PAGE_SIZE!=4K
Date: Wed, 23 Jan 2013 13:46:30 -0800
Message-Id: <1358977591-24485-1-git-send-email-dan.magenheimer@oracle.com>
X-Mailer: git-send-email 1.7.5.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace raw constant 12 with PAGE_SHIFT to fix non-x86 arches and
provoke build failure if PAGE_SHIFT is too big

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
---
 drivers/staging/zcache/zbud.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/zbud.c b/drivers/staging/zcache/zbud.c
index a7c4361..6835fab 100644
--- a/drivers/staging/zcache/zbud.c
+++ b/drivers/staging/zcache/zbud.c
@@ -103,8 +103,8 @@ struct zbudpage {
 		struct {
 			unsigned long space_for_flags;
 			struct {
-				unsigned zbud0_size:12;
-				unsigned zbud1_size:12;
+				unsigned zbud0_size: PAGE_SHIFT;
+				unsigned zbud1_size: PAGE_SHIFT;
 				unsigned unevictable:2;
 			};
 			struct list_head budlist;
@@ -112,6 +112,9 @@ struct zbudpage {
 		};
 	};
 };
+#if (PAGE_SHIFT * 2) + 2 > BITS_PER_LONG
+#error "zbud won't work for this arch, PAGE_SIZE is too large"
+#endif
 
 struct zbudref {
 	union {
-- 
1.7.1

