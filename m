Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbaLIDgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 22:36:24 -0500
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:16015 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751520AbaLIDgX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 22:36:23 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'acme@redhat.com'" <acme@redhat.com>, "'bp@suse.de'" <bp@suse.de>,
        "'mingo@kernel.org'" <mingo@kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 9 Dec 2014 11:36:17 +0800
Subject: [PATCH] fix build error for vm tools
Thread-Topic: [PATCH] fix build error for vm tools
Thread-Index: AdATYUom+tPgr1R5SteFN9dl+uERSQ==
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B313FC@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the build error when make like this:
make O=/xx/x vm

use $(OUTPUT) to generate to the right place.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 tools/vm/Makefile | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/vm/Makefile b/tools/vm/Makefile
index 3d907da..28d4bd9 100644
--- a/tools/vm/Makefile
+++ b/tools/vm/Makefile
@@ -1,9 +1,10 @@
 # Makefile for vm tools
 #
+include ../scripts/Makefile.include
 TARGETS=page-types slabinfo
 
 LIB_DIR = ../lib/api
-LIBS = $(LIB_DIR)/libapikfs.a
+LIBS = $(OUTPUT)../lib/api/libapikfs.a
 
 CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall -Wextra -I../lib/
@@ -12,11 +13,11 @@ LDFLAGS = $(LIBS)
 $(TARGETS): $(LIBS)
 
 $(LIBS):
-	make -C $(LIB_DIR)
+	$(call descend,../lib/api libapikfs.a)
 
 %: %.c
-	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
+	$(CC) $(CFLAGS) -o $(OUTPUT)$@ $< $(LDFLAGS)
 
 clean:
-	$(RM) page-types slabinfo
+	$(RM) $(OUTPUT)page-types $(OUTPUT)slabinfo
 	make -C $(LIB_DIR) clean
-- 
2.1.3
