Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaFGGVg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 02:21:36 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:55287 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750771AbaFGGVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 02:21:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnYOADWuklNXQ2gR/2dsb2JhbABYgw2sGAoFAZkQgQIXdYRgI4EaN4hGAbQimSuFXYkMHYQrBI9WikeLKIgcgz47
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>
Subject: [PATCH 1/1] include/linux/memblock.h: add __init to memblock_set_bottom_up
Date: Sat,  7 Jun 2014 08:21:24 +0200
Message-Id: <1402122084-25496-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock_set_bottom_up is only called by
__init cmdline_parse_movable_node and __init numa_init.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
This is untested.

 include/linux/memblock.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 8a20a51..4d6dfcf 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -198,7 +198,7 @@ phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align);
 /*
  * Set the allocation direction to bottom-up or top-down.
  */
-static inline void memblock_set_bottom_up(bool enable)
+static inline void __init memblock_set_bottom_up(bool enable)
 {
 	memblock.bottom_up = enable;
 }
@@ -213,7 +213,7 @@ static inline bool memblock_bottom_up(void)
 	return memblock.bottom_up;
 }
 #else
-static inline void memblock_set_bottom_up(bool enable) {}
+static inline void __init memblock_set_bottom_up(bool enable) {}
 static inline bool memblock_bottom_up(void) { return false; }
 #endif
 
-- 
1.9.1

