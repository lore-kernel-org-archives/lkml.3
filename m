Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3LNN0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:26:20 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:57590 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab3LNN0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:26:19 -0500
Date: Sat, 14 Dec 2013 18:56:10 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Pavel Machek <pavel@ucw.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rashika Kheria <rashika.kheria@gmail.com>, josh@joshtriplett.org
Subject: [PATCH] drivers: reset: Mark function as static in core.c
Message-ID: <20131214132610.GA8691@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function of_reset_simple_xlate() and
devm_reset_control_put() as static in core.c because it is not used
outside this file.

Thus, it also eliminate the following warnings in core.c:
drivers/reset/core.c:46:5: warning: no previous prototype for ‘of_reset_simple_xlate’ [-Wmissing-prototypes]
drivers/reset/core.c:262:6: warning: no previous prototype for ‘devm_reset_control_put’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/reset/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index d1b6089..8604053 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -43,7 +43,7 @@ struct reset_control {
  * This simple translation function should be used for reset controllers
  * with 1:1 mapping, where reset lines can be indexed by number without gaps.
  */
-int of_reset_simple_xlate(struct reset_controller_dev *rcdev,
+static int of_reset_simple_xlate(struct reset_controller_dev *rcdev,
 			  const struct of_phandle_args *reset_spec)
 {
 	if (WARN_ON(reset_spec->args_count != rcdev->of_reset_n_cells))
@@ -259,7 +259,7 @@ static int devm_reset_control_match(struct device *dev, void *res, void *data)
  * This function will not need to be called normally, as devres will take
  * care of freeing the resource.
  */
-void devm_reset_control_put(struct reset_control *rstc)
+static void devm_reset_control_put(struct reset_control *rstc)
 {
 	int ret;
 
-- 
1.7.9.5

