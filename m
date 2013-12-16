Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab3LPLLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:11:09 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:63262 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3LPLLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:11:05 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/2] mfd: cros ec: spi: Use 0 instead of '\0' consistently
Date: Mon, 16 Dec 2013 12:09:40 +0100
Message-Id: <1387192180-15333-2-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1387192180-15333-1-git-send-email-treding@nvidia.com>
References: <1387192180-15333-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memset() was being called with the second parameter set to '\0', which
is equivalent but longer than the more canonical 0. Update the code to
use the latter variant consistently across the driver.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v5:
- new patch

 drivers/mfd/cros_ec_spi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
index 8e262bfb603e..84af8d7a4295 100644
--- a/drivers/mfd/cros_ec_spi.c
+++ b/drivers/mfd/cros_ec_spi.c
@@ -112,7 +112,7 @@ static int cros_ec_spi_receive_response(struct cros_ec_device *ec_dev,
 	/* Receive data until we see the header byte */
 	deadline = jiffies + msecs_to_jiffies(EC_MSG_DEADLINE_MS);
 	do {
-		memset(&trans, '\0', sizeof(trans));
+		memset(&trans, 0, sizeof(trans));
 		trans.cs_change = 1;
 		trans.rx_buf = ptr = ec_dev->din;
 		trans.len = EC_MSG_PREAMBLE_COUNT;
@@ -164,7 +164,7 @@ static int cros_ec_spi_receive_response(struct cros_ec_device *ec_dev,
 		dev_dbg(ec_dev->dev, "loop, todo=%d, need_len=%d, ptr=%zd\n",
 			todo, need_len, ptr - ec_dev->din);
 
-		memset(&trans, '\0', sizeof(trans));
+		memset(&trans, 0, sizeof(trans));
 		trans.cs_change = 1;
 		trans.rx_buf = ptr;
 		trans.len = todo;
@@ -224,7 +224,7 @@ static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
 
 	/* Transmit phase - send our message */
 	debug_packet(ec_dev->dev, "out", ec_dev->dout, len);
-	memset(&trans, '\0', sizeof(trans));
+	memset(&trans, 0, sizeof(trans));
 	trans.tx_buf = ec_dev->dout;
 	trans.len = len;
 	trans.cs_change = 1;
-- 
1.8.4.2

