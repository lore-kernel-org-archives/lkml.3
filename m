Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaDALWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:22:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42798 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbaDALTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:19:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 140/144] ARM: move outer_cache declaration out of ifdef
Date: Tue,  1 Apr 2014 12:15:44 +0100
Message-Id: <1396350948-29910-141-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <rob.herring@calxeda.com>

commit 0b53c11d533a8f6688d73fad0baf67dd08ec1b90 upstream.

Move the outer_cache declaration of the CONFIG_OUTER_CACHE ifdef so that
outer_cache can be used inside IS_ENABLED condition.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/include/asm/outercache.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/outercache.h b/arch/arm/include/asm/outercache.h
index 12f71a1..f94784f 100644
--- a/arch/arm/include/asm/outercache.h
+++ b/arch/arm/include/asm/outercache.h
@@ -37,10 +37,10 @@ struct outer_cache_fns {
 	void (*resume)(void);
 };
 
-#ifdef CONFIG_OUTER_CACHE
-
 extern struct outer_cache_fns outer_cache;
 
+#ifdef CONFIG_OUTER_CACHE
+
 static inline void outer_inv_range(phys_addr_t start, phys_addr_t end)
 {
 	if (outer_cache.inv_range)
-- 
1.9.1

