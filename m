Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab3LTLFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 06:05:34 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58007 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab3LTLFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 06:05:32 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: kernel@pengutronix.de, Pavel Machek <pavel@ucw.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/2] reset: Mark function as static in core.c
Date: Fri, 20 Dec 2013 12:05:24 +0100
Message-Id: <1387537525-23389-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rashika Kheria <rashika.kheria@gmail.com>

This patch marks the function of_reset_simple_xlate() as static in
core.c because it is not used outside this file.

Thus, it also eliminate the following warning in core.c:
drivers/reset/core.c:46:5: warning: no previous prototype for ‘of_reset_simple_xlate’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Left the _put function as is and also removed the EXPORT_SYMBOL_GPL for _xlate.
---
 drivers/reset/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index b3d99a1..6c80ea6 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -43,8 +43,8 @@ struct reset_control {
  * This simple translation function should be used for reset controllers
  * with 1:1 mapping, where reset lines can be indexed by number without gaps.
  */
-int of_reset_simple_xlate(struct reset_controller_dev *rcdev,
-			  const struct of_phandle_args *reset_spec)
+static int of_reset_simple_xlate(struct reset_controller_dev *rcdev,
+				 const struct of_phandle_args *reset_spec)
 {
 	if (WARN_ON(reset_spec->args_count != rcdev->of_reset_n_cells))
 		return -EINVAL;
@@ -54,7 +54,6 @@ int of_reset_simple_xlate(struct reset_controller_dev *rcdev,
 
 	return reset_spec->args[0];
 }
-EXPORT_SYMBOL_GPL(of_reset_simple_xlate);
 
 /**
  * reset_controller_register - register a reset controller device
-- 
1.8.5.1

