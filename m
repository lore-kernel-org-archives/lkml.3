Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836AbaFRDUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 23:20:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:13090 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756415AbaFRDRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 23:17:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,498,1400050800"; 
   d="scan'208";a="549553890"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 1/9] ACPICA: Events: Reduce indent divergences of events files.
Date: Wed, 18 Jun 2014 11:17:19 +0800
Message-Id: <542942f5b8e3b71450b0d03d0bd8b94c6dd9ca71.1403060601.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1403060601.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reduces indent divergences first in order to reduce human
intervention work for the follow-up linuxized event patches.

This patch reduces indent divergences of the event files. Though the
divergences report doesn't care about these differences, they do hurt
patches maintanence.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/aclocal.h |    4 ++--
 drivers/acpi/acpica/evgpe.c   |   18 +++++++++---------
 drivers/acpi/acpica/evxface.c |    8 ++++----
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 91f801a..a9fa666 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -412,8 +412,8 @@ struct acpi_gpe_handler_info {
 	acpi_gpe_handler address;	/* Address of handler, if any */
 	void *context;		/* Context to be passed to handler */
 	struct acpi_namespace_node *method_node;	/* Method node for this GPE level (saved) */
-	u8 original_flags;      /* Original (pre-handler) GPE info */
-	u8 originally_enabled;  /* True if GPE was originally enabled */
+	u8 original_flags;	/* Original (pre-handler) GPE info */
+	u8 originally_enabled;	/* True if GPE was originally enabled */
 };
 
 /* Notify info for implicit notify, multiple device objects */
diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index e4ba4de..f9e6891 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -212,7 +212,7 @@ acpi_ev_remove_gpe_reference(struct acpi_gpe_event_info *gpe_event_info)
 		if (ACPI_SUCCESS(status)) {
 			status =
 			    acpi_hw_low_set_gpe(gpe_event_info,
-						     ACPI_GPE_DISABLE);
+						ACPI_GPE_DISABLE);
 		}
 
 		if (ACPI_FAILURE(status)) {
@@ -334,7 +334,7 @@ struct acpi_gpe_event_info *acpi_ev_get_gpe_event_info(acpi_handle gpe_device,
  *
  ******************************************************************************/
 
-u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info * gpe_xrupt_list)
+u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info *gpe_xrupt_list)
 {
 	acpi_status status;
 	struct acpi_gpe_block_info *gpe_block;
@@ -427,7 +427,7 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info * gpe_xrupt_list)
 
 			/* Check if there is anything active at all in this register */
 
-			enabled_status_byte = (u8) (status_reg & enable_reg);
+			enabled_status_byte = (u8)(status_reg & enable_reg);
 			if (!enabled_status_byte) {
 
 				/* No active GPEs in this register, move on */
@@ -450,7 +450,7 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info * gpe_xrupt_list)
 					    acpi_ev_gpe_dispatch(gpe_block->
 								 node,
 								 &gpe_block->
-						event_info[((acpi_size) i * ACPI_GPE_REGISTER_WIDTH) + j], j + gpe_register_info->base_gpe_number);
+								 event_info[((acpi_size) i * ACPI_GPE_REGISTER_WIDTH) + j], j + gpe_register_info->base_gpe_number);
 				}
 			}
 		}
@@ -636,7 +636,7 @@ static void ACPI_SYSTEM_XFACE acpi_ev_asynch_enable_gpe(void *context)
  *
  ******************************************************************************/
 
-acpi_status acpi_ev_finish_gpe(struct acpi_gpe_event_info *gpe_event_info)
+acpi_status acpi_ev_finish_gpe(struct acpi_gpe_event_info * gpe_event_info)
 {
 	acpi_status status;
 
@@ -666,9 +666,9 @@ acpi_status acpi_ev_finish_gpe(struct acpi_gpe_event_info *gpe_event_info)
  *
  * FUNCTION:    acpi_ev_gpe_dispatch
  *
- * PARAMETERS:  gpe_device      - Device node. NULL for GPE0/GPE1
- *              gpe_event_info  - Info for this GPE
- *              gpe_number      - Number relative to the parent GPE block
+ * PARAMETERS:  gpe_device          - Device node. NULL for GPE0/GPE1
+ *              gpe_event_info      - Info for this GPE
+ *              gpe_number          - Number relative to the parent GPE block
  *
  * RETURN:      INTERRUPT_HANDLED or INTERRUPT_NOT_HANDLED
  *
@@ -681,7 +681,7 @@ acpi_status acpi_ev_finish_gpe(struct acpi_gpe_event_info *gpe_event_info)
 
 u32
 acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
-		    struct acpi_gpe_event_info *gpe_event_info, u32 gpe_number)
+		     struct acpi_gpe_event_info *gpe_event_info, u32 gpe_number)
 {
 	acpi_status status;
 	u32 return_value;
diff --git a/drivers/acpi/acpica/evxface.c b/drivers/acpi/acpica/evxface.c
index 11e5803..1bcb55b 100644
--- a/drivers/acpi/acpica/evxface.c
+++ b/drivers/acpi/acpica/evxface.c
@@ -786,7 +786,7 @@ acpi_install_gpe_handler(acpi_handle gpe_device,
 	handler->method_node = gpe_event_info->dispatch.method_node;
 	handler->original_flags = (u8)(gpe_event_info->flags &
 				       (ACPI_GPE_XRUPT_TYPE_MASK |
-				        ACPI_GPE_DISPATCH_MASK));
+					ACPI_GPE_DISPATCH_MASK));
 
 	/*
 	 * If the GPE is associated with a method, it may have been enabled
@@ -808,7 +808,7 @@ acpi_install_gpe_handler(acpi_handle gpe_device,
 
 	gpe_event_info->flags &=
 	    ~(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_DISPATCH_MASK);
-	gpe_event_info->flags |= (u8) (type | ACPI_GPE_DISPATCH_HANDLER);
+	gpe_event_info->flags |= (u8)(type | ACPI_GPE_DISPATCH_HANDLER);
 
 	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 
@@ -893,7 +893,7 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
 
 	gpe_event_info->dispatch.method_node = handler->method_node;
 	gpe_event_info->flags &=
-		~(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_DISPATCH_MASK);
+	    ~(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_DISPATCH_MASK);
 	gpe_event_info->flags |= handler->original_flags;
 
 	/*
@@ -946,7 +946,7 @@ ACPI_EXPORT_SYMBOL(acpi_remove_gpe_handler)
  * handle is returned.
  *
  ******************************************************************************/
-acpi_status acpi_acquire_global_lock(u16 timeout, u32 * handle)
+acpi_status acpi_acquire_global_lock(u16 timeout, u32 *handle)
 {
 	acpi_status status;
 
-- 
1.7.10

