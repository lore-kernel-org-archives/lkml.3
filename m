Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3CONEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:04:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59825 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab3CONET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:04:19 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 08/50] staging: omap-thermal: add documentation for register access functions
Date: Fri, 15 Mar 2013 08:59:56 -0400
Message-ID: <1363352438-15935-9-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the helper functions that manipulates registers and their
bitfields. All of them work based of the io mapped area.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 1c1b905..a8d63a2 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -42,17 +42,38 @@
 
 #include "omap-bandgap.h"
 
+/**
+ * omap_bandgap_readl() - simple read helper function
+ * @bg_ptr: pointer to omap_bandgap structure
+ * @reg: desired register (offset) to be read
+ *
+ * Helper function to read bandgap registers. It uses the io remapped area.
+ * Returns the register value.
+ */
 static u32 omap_bandgap_readl(struct omap_bandgap *bg_ptr, u32 reg)
 {
 	return readl(bg_ptr->base + reg);
 }
 
+/**
+ * omap_bandgap_writel() - simple write helper function
+ * @bg_ptr: pointer to omap_bandgap structure
+ * @val: desired register value to be written
+ * @reg: desired register (offset) to be written
+ *
+ * Helper function to write bandgap registers. It uses the io remapped area.
+ */
 static void omap_bandgap_writel(struct omap_bandgap *bg_ptr, u32 val, u32 reg)
 {
 	writel(val, bg_ptr->base + reg);
 }
 
-/* update bits, value will be shifted */
+/**
+ * DOC: macro to update bits.
+ *
+ * RMW_BITS() - used to read, modify and update bandgap bitfields.
+ *            The value passed will be shifted.
+ */
 #define RMW_BITS(bg_ptr, id, reg, mask, val)			\
 do {								\
 	struct temp_sensor_registers *t;			\
-- 
1.7.7.1.488.ge8e1c

