Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3CONFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:05:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59888 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab3CONFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:05:23 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 11/50] staging: omap-thermal: add documentation for omap_bandgap_read_temp
Date: Fri, 15 Mar 2013 08:59:59 -0400
Message-ID: <1363352438-15935-12-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document function which reads temperature register, depending on
bandgap device version.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 62a5fb9..02817b5 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -109,6 +109,16 @@ exit:
 	return 0;
 }
 
+/**
+ * omap_bandgap_read_temp() - helper function to read sensor temperature
+ * @bg_ptr: pointer to omap_bandgap structure
+ * @id: bandgap sensor id
+ *
+ * Function to concentrate the steps to read sensor temperature register.
+ * This function is desired because, depending on bandgap device version,
+ * it might be needed to freeze the bandgap state machine, before fetching
+ * the register value.
+ */
 static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr, int id)
 {
 	struct temp_sensor_registers *tsr;
-- 
1.7.7.1.488.ge8e1c

