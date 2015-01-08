Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbbAHPcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:32:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33798 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486AbbAHPcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:32:07 -0500
From: Colin King <colin.king@canonical.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] PM / clock_ops: initialize ret to avoid garbage being returned
Date: Thu,  8 Jan 2015 15:31:01 +0000
Message-Id: <1420731061-5029-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

cppcheck detected an unitialised ret:
  [drivers/base/power/clock_ops.c:53]: (error) Uninitialized variable: ret

ret is only assigned if ce->status < PCE_STATUS_ERROR, if this is false
then __pm_clk_enable returns whatever garbage ret picks up from the stack.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/base/power/clock_ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
index d626576..5bd283d 100644
--- a/drivers/base/power/clock_ops.c
+++ b/drivers/base/power/clock_ops.c
@@ -39,7 +39,7 @@ struct pm_clock_entry {
  */
 static inline int __pm_clk_enable(struct device *dev, struct pm_clock_entry *ce)
 {
-	int ret;
+	int ret = 0;
 
 	if (ce->status < PCE_STATUS_ERROR) {
 		ret = clk_enable(ce->clk);
-- 
1.7.9.5

