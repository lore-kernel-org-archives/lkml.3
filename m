Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab3DUDnF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 23:43:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:38369 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab3DUDnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 23:43:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,517,1363158000"; 
   d="scan'208";a="298287535"
From: Andi Kleen <andi@firstfloor.org>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] initconst fixes for module signing
Date: Sat, 20 Apr 2013 20:42:58 -0700
Message-Id: <1366515778-18039-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>

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
