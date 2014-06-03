Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806AbaFCTe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:34:27 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:56004 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956AbaFCTeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:34:25 -0400
MIME-Version: 1.0
In-Reply-To: <1401823278-7057-1-git-send-email-nioko1337@googlemail.com>
References: <1401823278-7057-1-git-send-email-nioko1337@googlemail.com>
Date: Tue, 3 Jun 2014 21:34:24 +0200
Message-ID: <CABG+PvG4UO+obwf1sgyXQ7cdxjwg_yVKdS-QzR0bXyUNh_reLg@mail.gmail.com>
Subject: Fwd: [PATCH] fix coding style issues
From: Nicolas Koch <nioko1337@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Koch <nioko1337@gmail.com>
Date: Tue,  3 Jun 2014 21:21:18 +0200
Subject: [PATCH] fix coding style issues
To: devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Aaro Koskinen
<aaro.koskinen@iki.fi>, Nicolas Koch <nioko1337@googlemail.com>

Done as task 10 of the eudyptula challenge.

Signed-off-by: Nicolas Koch <nioko1337@googlemail.com>
---
 drivers/staging/octeon/ethernet-mem.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-mem.c
b/drivers/staging/octeon/ethernet-mem.c
index bf666b0..964da86 100644
--- a/drivers/staging/octeon/ethernet-mem.c
+++ b/drivers/staging/octeon/ethernet-mem.c
@@ -46,9 +46,10 @@
 static int cvm_oct_fill_hw_skbuff(int pool, int size, int elements)
 {
 	int freed = elements;
-	while (freed) {

+	while (freed) {
 		struct sk_buff *skb = dev_alloc_skb(size + 256);
+
 		if (unlikely(skb == NULL))
 			break;
 		skb_reserve(skb, 256 - (((unsigned long)skb->data) & 0x7f));
@@ -81,10 +82,10 @@ static void cvm_oct_free_hw_skbuff(int pool, int
size, int elements)

 	if (elements < 0)
 		pr_warn("Freeing of pool %u had too many skbuffs (%d)\n",
-		     pool, elements);
+			pool, elements);
 	else if (elements > 0)
 		pr_warn("Freeing of pool %u is missing %d skbuffs\n",
-		       pool, elements);
+			pool, elements);
 }

 /**
@@ -115,7 +116,7 @@ static int cvm_oct_fill_hw_memory(int pool, int
size, int elements)
 		memory = kmalloc(size + 256, GFP_ATOMIC);
 		if (unlikely(memory == NULL)) {
 			pr_warn("Unable to allocate %u bytes for FPA pool %d\n",
-				   elements * size, pool);
+				elements * size, pool);
 			break;
 		}
 		fpa = (char *)(((unsigned long)memory + 256) & ~0x7fUL);
@@ -136,6 +137,7 @@ static void cvm_oct_free_hw_memory(int pool, int
size, int elements)
 {
 	char *memory;
 	char *fpa;
+
 	do {
 		fpa = cvmx_fpa_alloc(pool);
 		if (fpa) {
@@ -157,6 +159,7 @@ static void cvm_oct_free_hw_memory(int pool, int
size, int elements)
 int cvm_oct_mem_fill_fpa(int pool, int size, int elements)
 {
 	int freed;
+
 	if (USE_SKBUFFS_IN_HW && pool == CVMX_FPA_PACKET_POOL)
 		freed = cvm_oct_fill_hw_skbuff(pool, size, elements);
 	else
-- 
1.7.10.4




-- 
Mit freundlichen Grüßen,
 Nicolas Koch
