Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbaHESld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:41:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbaHESO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.14 15/39] iio:bma180: Fix scale factors to report correct acceleration units
Date: Tue,  5 Aug 2014 11:13:52 -0700
Message-Id: <20140805181336.506348060@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181336.030349158@linuxfoundation.org>
References: <20140805181336.030349158@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Meerwald <pmeerw@pmeerw.net>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/bma180.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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


