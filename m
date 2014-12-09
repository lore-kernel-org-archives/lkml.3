Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128AbaLIFXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 00:23:54 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:16198 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750719AbaLIFXx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 00:23:53 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'acme@redhat.com'" <acme@redhat.com>, "'bp@suse.de'" <bp@suse.de>,
        "'mingo@kernel.org'" <mingo@kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 9 Dec 2014 13:23:27 +0800
Subject: [PATCH V2] fix build error for vm tools
Thread-Topic: [PATCH V2] fix build error for vm tools
Thread-Index: AdATYUom+tPgr1R5SteFN9dl+uERSQADuoaA
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B313FD@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E688B313FC@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E688B313FC@CNBJMBX05.corpusers.net>
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
 tools/vm/Makefile | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/vm/Makefile b/tools/vm/Makefile
index 3d907da..2847345 100644
--- a/tools/vm/Makefile
+++ b/tools/vm/Makefile
@@ -1,22 +1,24 @@
 # Makefile for vm tools
 #
+include ../scripts/Makefile.include
 TARGETS=page-types slabinfo
 
 LIB_DIR = ../lib/api
-LIBS = $(LIB_DIR)/libapikfs.a
+LIBS = $(OUTPUT)../lib/api/libapikfs.a
 
 CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall -Wextra -I../lib/
 LDFLAGS = $(LIBS)
 
+all: $(TARGETS)
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
