Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3HEWPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:15:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:7353 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280Ab3HEWPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:15:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="376603922"
From: Andi Kleen <andi@firstfloor.org>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Fix init const for module signing code
Date: Mon,  5 Aug 2013 15:15:04 -0700
Message-Id: <1375740904-8046-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

const has to use __initconst, not __initdata

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/modsign_pubkey.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/modsign_pubkey.c b/kernel/modsign_pubkey.c
index 2b6e699..7cbd450 100644
--- a/kernel/modsign_pubkey.c
+++ b/kernel/modsign_pubkey.c
@@ -18,14 +18,14 @@
 
 struct key *modsign_keyring;
 
-extern __initdata const u8 modsign_certificate_list[];
-extern __initdata const u8 modsign_certificate_list_end[];
+extern __initconst const u8 modsign_certificate_list[];
+extern __initconst const u8 modsign_certificate_list_end[];
 
 /*
  * We need to make sure ccache doesn't cache the .o file as it doesn't notice
  * if modsign.pub changes.
  */
-static __initdata const char annoy_ccache[] = __TIME__ "foo";
+static __initconst const char annoy_ccache[] = __TIME__ "foo";
 
 /*
  * Load the compiled-in keys
-- 
1.8.3.1

