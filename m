Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab3CSO5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:57:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37701 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932515Ab3CSO5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:57:39 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv2 06/12] staging: ti-soc-thermal: make unexported functions local
Date: Tue, 19 Mar 2013 10:54:22 -0400
Message-ID: <1363704868-11843-7-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
References: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move _ti_bandgap_write_threshold and _ti_bandgap_read_threshold to static
area, as they are local functions.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/ti-soc-thermal/ti-bandgap.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.c b/drivers/staging/ti-soc-thermal/ti-bandgap.c
index a09ebfc..b819af0 100644
--- a/drivers/staging/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/staging/ti-soc-thermal/ti-bandgap.c
@@ -475,8 +475,8 @@ exit:
  * Validates the mCelsius range and update the requested threshold.
  * Call this function only if bandgap features HAS(TALERT).
  */
-int _ti_bandgap_write_threshold(struct ti_bandgap *bgp, int id, int val,
-				bool hot)
+static int _ti_bandgap_write_threshold(struct ti_bandgap *bgp, int id, int val,
+				       bool hot)
 {
 	struct temp_sensor_data *ts_data;
 	struct temp_sensor_registers *tsr;
@@ -529,8 +529,8 @@ exit:
  * This function can be used to read t_hot or t_cold, depending on @hot value.
  * Call this function only if bandgap features HAS(TALERT).
  */
-int _ti_bandgap_read_threshold(struct ti_bandgap *bgp, int id,
-			       int *val, bool hot)
+static int _ti_bandgap_read_threshold(struct ti_bandgap *bgp, int id,
+				      int *val, bool hot)
 {
 	struct temp_sensor_registers *tsr;
 	u32 temp, mask;
-- 
1.7.7.1.488.ge8e1c

