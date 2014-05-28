Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbaE1Tld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 15:41:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57287 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbaE1Tlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 15:41:32 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: Fix regulator_get_{optional,exclusive}() documentation
Date: Wed, 28 May 2014 12:41:28 -0700
Message-Id: <1401306088-10136-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_get_optional() doesn't hold an exclusive reference to
the regulator. Fix the documentation and reword the exclusive
documentation to fix the grammatical error "this reference is
held".

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/regulator/core.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b97ffd2365d3..2fae21a9d0e5 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1430,9 +1430,9 @@ EXPORT_SYMBOL_GPL(regulator_get);
  *
  * Returns a struct regulator corresponding to the regulator producer,
  * or IS_ERR() condition containing errno.  Other consumers will be
- * unable to obtain this reference is held and the use count for the
- * regulator will be initialised to reflect the current state of the
- * regulator.
+ * unable to obtain this regulator while this reference is held and the
+ * use count for the regulator will be initialised to reflect the current
+ * state of the regulator.
  *
  * This is intended for use by consumers which cannot tolerate shared
  * use of the regulator such as those which need to force the
@@ -1456,10 +1456,7 @@ EXPORT_SYMBOL_GPL(regulator_get_exclusive);
  * @id: Supply name or regulator ID.
  *
  * Returns a struct regulator corresponding to the regulator producer,
- * or IS_ERR() condition containing errno.  Other consumers will be
- * unable to obtain this reference is held and the use count for the
- * regulator will be initialised to reflect the current state of the
- * regulator.
+ * or IS_ERR() condition containing errno.
  *
  * This is intended for use by consumers for devices which can have
  * some supplies unconnected in normal use, such as some MMC devices.
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

