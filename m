Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3AJXlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:41:46 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:55382 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754209Ab3AJXlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:41:44 -0500
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
Subject: [PATCH 5/6] VMCI: rename PPNset to ppn_set to avoid camel case
Date: Thu, 10 Jan 2013 15:41:42 -0800
Message-Id: <1357861303-25903-5-git-send-email-dtor@vmware.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357861303-25903-1-git-send-email-dtor@vmware.com>
References: <1357861303-25903-1-git-send-email-dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Andy King <acking@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_queue_pair.c |    8 ++++----
 drivers/misc/vmw_vmci/vmci_queue_pair.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index 6417a26..ef81fec 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -231,7 +231,7 @@ struct qp_guest_endpoint {
 	u64 num_ppns;
 	void *produce_q;
 	void *consume_q;
-	struct PPNSet ppn_set;
+	struct ppn_set ppn_set;
 };
 
 struct qp_list {
@@ -461,7 +461,7 @@ static int __qp_memcpy_from_queue(void *dest,
 static int qp_alloc_ppn_set(void *prod_q,
 			    u64 num_produce_pages,
 			    void *cons_q,
-			    u64 num_consume_pages, struct PPNSet *ppn_set)
+			    u64 num_consume_pages, struct ppn_set *ppn_set)
 {
 	u32 *produce_ppns;
 	u32 *consume_ppns;
@@ -532,7 +532,7 @@ static int qp_alloc_ppn_set(void *prod_q,
 /*
  * Frees the two list of PPNs for a queue pair.
  */
-static void qp_free_ppn_set(struct PPNSet *ppn_set)
+static void qp_free_ppn_set(struct ppn_set *ppn_set)
 {
 	if (ppn_set->initialized) {
 		/* Do not call these functions on NULL inputs. */
@@ -546,7 +546,7 @@ static void qp_free_ppn_set(struct PPNSet *ppn_set)
  * Populates the list of PPNs in the hypercall structure with the PPNS
  * of the produce queue and the consume queue.
  */
-static int qp_populate_ppn_set(u8 *call_buf, const struct PPNSet *ppn_set)
+static int qp_populate_ppn_set(u8 *call_buf, const struct ppn_set *ppn_set)
 {
 	memcpy(call_buf, ppn_set->produce_ppns,
 	       ppn_set->num_produce_pages * sizeof(*ppn_set->produce_ppns));
diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.h b/drivers/misc/vmw_vmci/vmci_queue_pair.h
index 8d8d6a1..58c6959 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.h
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.h
@@ -25,7 +25,7 @@
 typedef int (*vmci_event_release_cb) (void *client_data);
 
 /* Guest device port I/O. */
-struct PPNSet {
+struct ppn_set {
 	u64 num_produce_pages;
 	u64 num_consume_pages;
 	u32 *produce_ppns;
-- 
1.7.4.1

