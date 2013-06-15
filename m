Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3FOUuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 16:50:39 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:59049 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab3FOUui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 16:50:38 -0400
Message-ID: <201306152050.r5FKobPY025904@farm-0013.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sat, 15 Jun 2013 16:47:47 -0400
Subject: [PATCH] tilepro: work around module link error with gcc 4.7
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 4.7.x is emitting calls to __ffsdi2 where previously
it used to inline the appropriate ctz instructions.
While this needs to be fixed in gcc, it's also easy to avoid
having it cause build failures when building with those
compilers by exporting __ffsdi2 to modules.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: stable@kernel.org
---
 arch/tile/lib/exports.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
index 4385cb6..a93b02a 100644
--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -84,4 +84,6 @@ uint64_t __ashrdi3(uint64_t, unsigned int);
 EXPORT_SYMBOL(__ashrdi3);
 uint64_t __ashldi3(uint64_t, unsigned int);
 EXPORT_SYMBOL(__ashldi3);
+int __ffsdi2(uint64_t);
+EXPORT_SYMBOL(__ffsdi2);
 #endif
-- 
1.7.10.3

