Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaIYCRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 22:17:35 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:53227 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaIYCRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 22:17:33 -0400
Message-ID: <1411611449.25671.1.camel@phoenix>
Subject: [PATCH] regulator: qcom_rpm: Fix FORCE_MODE_IS_2_BITS macro
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 25 Sep 2014 10:17:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code does not take the macro parameter, fix it.
This is not a problem at this moment because the only user actually passes
vreg to FORCE_MODE_IS_2_BITS().

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/qcom_rpm-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/qcom_rpm-regulator.c b/drivers/regulator/qcom_rpm-regulator.c
index 8d5969a..b55cd5b 100644
--- a/drivers/regulator/qcom_rpm-regulator.c
+++ b/drivers/regulator/qcom_rpm-regulator.c
@@ -50,7 +50,7 @@ struct rpm_reg_parts {
 };
 
 #define FORCE_MODE_IS_2_BITS(reg) \
-	((vreg->parts->fm.mask >> vreg->parts->fm.shift) == 3)
+	(((reg)->parts->fm.mask >> (reg)->parts->fm.shift) == 3)
 
 struct qcom_rpm_reg {
 	struct qcom_rpm *rpm;
-- 
1.9.1



