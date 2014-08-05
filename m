Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaHEBde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:33:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42808 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaHEBd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:33:26 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Cc: Olav Haugan <ohaugan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lina Iyer <lina.iyer@linaro.org>
Subject: [PATCH 7/8] msm: scm: Add logging of actual return code from scm call
Date: Mon,  4 Aug 2014 18:31:49 -0700
Message-Id: <1407202310-3359-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
References: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olav Haugan <ohaugan@codeaurora.org>

When an error occurs during an scm call the error returned is
remapped so we lose the original error code. This means that
when an error occurs we have no idea what actually failed within
the secure environment.

Add a logging statement that will log the actual error code from
scm call allowing us to easily determine what caused the error
to occur.

Signed-off-by: Olav Haugan <ohaugan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-qcom/scm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-qcom/scm.c b/arch/arm/mach-qcom/scm.c
index 7c62c03324f4..cfd4717aec78 100644
--- a/arch/arm/mach-qcom/scm.c
+++ b/arch/arm/mach-qcom/scm.c
@@ -152,6 +152,7 @@ static inline void *scm_get_response_buffer(const struct scm_response *rsp)
 
 static int scm_remap_error(int err)
 {
+	pr_err("scm_call failed with error code %d\n", err);
 	switch (err) {
 	case SCM_ERROR:
 		return -EIO;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

