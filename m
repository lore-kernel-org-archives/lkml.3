Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaKZVvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:51:16 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:11807 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbaKZVvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:51:13 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Brown <broonie@kernel.org>
CC: Josh Cartwright <joshc@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: [PATCH v8 3/3] regulator: qcom-rpm: Add missing state flag in call to RPM
Date: Wed, 26 Nov 2014 13:51:01 -0800
Message-ID: <1417038661-30209-4-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1417038661-30209-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1417038661-30209-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the missing state parameter to the call down to the RPM. This
is currently hard coded to the active state, as that's all we're
supporting at this moment.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/regulator/qcom_rpm-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/qcom_rpm-regulator.c b/drivers/regulator/qcom_rpm-regulator.c
index b55cd5b..8f66040 100644
--- a/drivers/regulator/qcom_rpm-regulator.c
+++ b/drivers/regulator/qcom_rpm-regulator.c
@@ -198,6 +198,7 @@ static int rpm_reg_write(struct qcom_rpm_reg *vreg,
 	vreg->val[req->word] |= value << req->shift;
 
 	return qcom_rpm_write(vreg->rpm,
+			      QCOM_RPM_ACTIVE_STATE,
 			      vreg->resource,
 			      vreg->val,
 			      vreg->parts->request_len);
-- 
1.8.2.2

