Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807Ab3BFWGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:06:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4937 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab3BFWGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:06:34 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=444IoxN9aF0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=P8K375EbGMkA:10 a=VwQbUJbxAAAA:8 a=nc7blvwjXnEObXNMcagA:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=d9xr9z8j0aPWJmSb:21 a=miUcSqfhbemjvq69:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130206220632.775810442@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Feb 2013 17:06:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 4/5] mm: swap: Initialize local locks early
References: <20130206220608.862416001@goodmis.org>
Content-Disposition: inline; filename=0004-mm-swap-Initialize-local-locks-early.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Cc: stable-rt@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/swap.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 069390f..662972f 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -772,6 +772,15 @@ unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 
 EXPORT_SYMBOL(pagevec_lookup);
 
+/* Early setup for the local locks */
+static int __init swap_init_locks(void)
+{
+	local_irq_lock_init(rotate_lock);
+	local_irq_lock_init(swap_lock);
+	return 1;
+}
+early_initcall(swap_init_locks);
+
 unsigned pagevec_lookup_tag(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t *index, int tag, unsigned nr_pages)
 {
@@ -789,9 +798,6 @@ void __init swap_setup(void)
 {
 	unsigned long megs = totalram_pages >> (20 - PAGE_SHIFT);
 
-	local_irq_lock_init(rotate_lock);
-	local_irq_lock_init(swap_lock);
-
 #ifdef CONFIG_SWAP
 	bdi_init(swapper_space.backing_dev_info);
 #endif
-- 
1.7.10.4


