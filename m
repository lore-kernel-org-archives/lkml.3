Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaGUGGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:06:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:30179 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598AbaGUGGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:06:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="459363156"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH v3 14/14] ACPI/EC: Cleanup coding style.
Date: Mon, 21 Jul 2014 14:06:43 +0800
Message-Id: <a7f39b5c9c6bd0ce461084cea634f86e60d9a2c0.1405922585.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405922585.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405922585.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the following coding style issues that are detected by
scripts/checkpatch.pl:
 ERROR: code indent should use tabs where possible
 WARNING: Missing a blank line after declarations
No functional changes.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index ea8d3c3..0e7472b 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -155,8 +155,8 @@ static int EC_FLAGS_SKIP_DSDT_SCAN; /* Not all BIOS survive early DSDT scan */
 static int EC_FLAGS_CLEAR_ON_RESUME; /* Needs acpi_ec_clear() on boot/resume */
 
 /* --------------------------------------------------------------------------
-                             Device Flags
-   -------------------------------------------------------------------------- */
+ *                           Device Flags
+ * -------------------------------------------------------------------------- */
 
 static bool acpi_ec_started(struct acpi_ec *ec)
 {
@@ -177,8 +177,8 @@ static bool acpi_ec_has_pending_event(struct acpi_ec *ec)
 }
 
 /* --------------------------------------------------------------------------
-                             GPE Enhancement
-   -------------------------------------------------------------------------- */
+ *                           GPE Enhancement
+ * -------------------------------------------------------------------------- */
 
 static void acpi_ec_set_storm(struct acpi_ec *ec, u8 flag)
 {
@@ -325,8 +325,8 @@ int acpi_ec_wait_for_event(struct acpi_ec *ec)
 }
 
 /* --------------------------------------------------------------------------
-                             Transaction Management
-   -------------------------------------------------------------------------- */
+ *                           Transaction Management
+ * -------------------------------------------------------------------------- */
 
 static inline u8 acpi_ec_read_status(struct acpi_ec *ec)
 {
@@ -386,6 +386,7 @@ static int ec_transaction_completed(struct acpi_ec *ec)
 {
 	unsigned long flags;
 	int ret = 0;
+
 	spin_lock_irqsave(&ec->lock, flags);
 	if (ec->curr && (ec->curr->flags & ACPI_EC_COMMAND_COMPLETE))
 		ret = 1;
@@ -469,6 +470,7 @@ static int ec_poll(struct acpi_ec *ec)
 {
 	unsigned long flags;
 	int repeat = 5; /* number of command restarts */
+
 	while (repeat--) {
 		unsigned long delay = jiffies +
 			msecs_to_jiffies(ec_delay);
@@ -779,6 +781,7 @@ static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 * data)
 	struct transaction t = {.command = ACPI_EC_COMMAND_QUERY,
 				.wdata = NULL, .rdata = &d,
 				.wlen = 0, .rlen = 1};
+
 	if (!ec || !data)
 		return -EINVAL;
 	/*
@@ -796,8 +799,9 @@ static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 * data)
 }
 
 /* --------------------------------------------------------------------------
-                                Event Management
-   -------------------------------------------------------------------------- */
+ *                              Event Management
+ * -------------------------------------------------------------------------- */
+
 static struct acpi_ec_query_handler *
 acpi_ec_get_query_handler(struct acpi_ec_query_handler *handler)
 {
@@ -824,6 +828,7 @@ int acpi_ec_add_query_handler(struct acpi_ec *ec, u8 query_bit,
 {
 	struct acpi_ec_query_handler *handler =
 	    kzalloc(sizeof(struct acpi_ec_query_handler), GFP_KERNEL);
+
 	if (!handler)
 		return -ENOMEM;
 
@@ -844,6 +849,7 @@ void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit)
 {
 	struct acpi_ec_query_handler *handler, *tmp;
 	LIST_HEAD(free_list);
+
 	mutex_lock(&ec->mutex);
 	list_for_each_entry_safe(handler, tmp, &ec->list, node) {
 		if (query_bit == handler->query_bit) {
@@ -861,6 +867,7 @@ EXPORT_SYMBOL_GPL(acpi_ec_remove_query_handler);
 static void acpi_ec_run(void *cxt)
 {
 	struct acpi_ec_query_handler *handler = cxt;
+
 	if (!handler)
 		return;
 	pr_debug("##### Query(0x%02x) started #####\n", handler->query_bit);
@@ -973,8 +980,8 @@ static void ec_delete_event_poller(struct acpi_ec *ec)
 }
 
 /* --------------------------------------------------------------------------
-                             Address Space Management
-   -------------------------------------------------------------------------- */
+ *                           Address Space Management
+ * -------------------------------------------------------------------------- */
 
 static acpi_status
 acpi_ec_space_handler(u32 function, acpi_physical_address address,
@@ -1018,8 +1025,9 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
 }
 
 /* --------------------------------------------------------------------------
-                               Driver Interface
-   -------------------------------------------------------------------------- */
+ *                             Driver Interface
+ * -------------------------------------------------------------------------- */
+
 static acpi_status
 ec_parse_io_ports(struct acpi_resource *resource, void *context);
 
@@ -1058,7 +1066,6 @@ ec_parse_device(acpi_handle handle, u32 Level, void *context, void **retval)
 {
 	acpi_status status;
 	unsigned long long tmp = 0;
-
 	struct acpi_ec *ec = context;
 
 	/* clear addr values, ec_parse_io_ports depend on it */
-- 
1.7.10

