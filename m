Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaHTMKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:10:41 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58888 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>,
        Jonathan Cameron <jic23@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 012/104] iio:bma180: Fix scale factors to report correct acceleration units
Date: Wed, 20 Aug 2014 13:42:35 +0200
Message-Id: <357249fb9640cd72a4e6d8008ce1f1be0154e37c.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Meerwald <pmeerw@pmeerw.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 381676d5e86596b11e22a62f196e192df6091373 upstream.

The userspace interface for acceleration sensors is documented as using
m/s^2 units [Documentation/ABI/testing/sysfs-bus-iio]

The fullscale raw values for the BMA80 corresponds to -/+ 1, 1.5, 2, etc G
depending on the selected mode.

The scale table was converting to G rather than m/s^2.
Change the scaling table to match the documented interface.

See commit 71702e6e, iio: mma8452: Use correct acceleration units,
for a related fix.

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/iio/accel/bma180.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/accel/bma180.c b/drivers/iio/accel/bma180.c
index 81e3dc260993..225aea63eaf5 100644
--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -68,13 +68,13 @@
 /* Defaults values */
 #define BMA180_DEF_PMODE	0
 #define BMA180_DEF_BW		20
-#define BMA180_DEF_SCALE	250
+#define BMA180_DEF_SCALE	2452
 
 /* Available values for sysfs */
 #define BMA180_FLP_FREQ_AVAILABLE \
 	"10 20 40 75 150 300"
 #define BMA180_SCALE_AVAILABLE \
-	"0.000130 0.000190 0.000250 0.000380 0.000500 0.000990 0.001980"
+	"0.001275 0.001863 0.002452 0.003727 0.004903 0.009709 0.019417"
 
 struct bma180_data {
 	struct i2c_client *client;
@@ -94,7 +94,7 @@ enum bma180_axis {
 };
 
 static int bw_table[] = { 10, 20, 40, 75, 150, 300 }; /* Hz */
-static int scale_table[] = { 130, 190, 250, 380, 500, 990, 1980 };
+static int scale_table[] = { 1275, 1863, 2452, 3727, 4903, 9709, 19417 };
 
 static int bma180_get_acc_reg(struct bma180_data *data, enum bma180_axis axis)
 {
-- 
2.0.4

