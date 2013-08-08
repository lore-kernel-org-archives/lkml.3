Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966353Ab3HHUJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:09:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965961Ab3HHUJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:09:35 -0400
Subject: [PATCH v5 2/9] pci: Add hotplug_slot_ops.reset_slot()
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: alexander.h.duyck@intel.com, ddutile@redhat.com,
        indou.takao@jp.fujitsu.com, linux-kernel@vger.kernel.org
Date: Thu, 08 Aug 2013 14:09:31 -0600
Message-ID: <20130808200930.2932.88666.stgit@bling.home>
In-Reply-To: <20130808200444.2932.17381.stgit@bling.home>
References: <20130808200444.2932.17381.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This optional callback allows htoplug controllers to perform slot
specific resets.  These may be necessary in cases where a normal
secondary bus reset can interact with controller logic and expose
spurious hotplugs.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 include/linux/pci_hotplug.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/pci_hotplug.h b/include/linux/pci_hotplug.h
index 8db71dc..bd32109 100644
--- a/include/linux/pci_hotplug.h
+++ b/include/linux/pci_hotplug.h
@@ -63,6 +63,9 @@ enum pcie_link_width {
  * @get_adapter_status: Called to get see if an adapter is present in the slot or not.
  *	If this field is NULL, the value passed in the struct hotplug_slot_info
  *	will be used when this value is requested by a user.
+ * @reset_slot: Optional interface to allow override of a bus reset for the
+ *	slot for cases where a secondary bus reset can result in spurious
+ *	hotplug events or where a slot can be reset independent of the bus.
  *
  * The table of function pointers that is passed to the hotplug pci core by a
  * hotplug pci driver.  These functions are called by the hotplug pci core when
@@ -80,6 +83,7 @@ struct hotplug_slot_ops {
 	int (*get_attention_status)	(struct hotplug_slot *slot, u8 *value);
 	int (*get_latch_status)		(struct hotplug_slot *slot, u8 *value);
 	int (*get_adapter_status)	(struct hotplug_slot *slot, u8 *value);
+	int (*reset_slot)		(struct hotplug_slot *slot, int probe);
 };
 
 /**

