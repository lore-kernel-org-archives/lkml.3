Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaHEBdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:33:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42802 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaHEBdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:33:25 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lina Iyer <lina.iyer@linaro.org>
Subject: [PATCH 6/8] msm: scm: Add a feat version query API
Date: Mon,  4 Aug 2014 18:31:48 -0700
Message-Id: <1407202310-3359-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
References: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some users of SCM need to detect features and also detect if
those features have certain versions available. Add this API.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-qcom/scm.c | 13 +++++++++++++
 arch/arm/mach-qcom/scm.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/arch/arm/mach-qcom/scm.c b/arch/arm/mach-qcom/scm.c
index e80571f57ca4..7c62c03324f4 100644
--- a/arch/arm/mach-qcom/scm.c
+++ b/arch/arm/mach-qcom/scm.c
@@ -410,3 +410,16 @@ int scm_is_call_available(u32 svc_id, u32 cmd_id)
 	return ret_val;
 }
 EXPORT_SYMBOL(scm_is_call_available);
+
+#define GET_FEAT_VERSION_CMD	3
+int scm_get_feat_version(u32 feat)
+{
+	if (scm_is_call_available(SCM_SVC_INFO, GET_FEAT_VERSION_CMD)) {
+		u32 version;
+		if (!scm_call(SCM_SVC_INFO, GET_FEAT_VERSION_CMD, &feat,
+				sizeof(feat), &version, sizeof(version)))
+			return version;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(scm_get_feat_version);
diff --git a/arch/arm/mach-qcom/scm.h b/arch/arm/mach-qcom/scm.h
index f94c7279616a..6348b08524e7 100644
--- a/arch/arm/mach-qcom/scm.h
+++ b/arch/arm/mach-qcom/scm.h
@@ -26,5 +26,6 @@ extern s32 scm_call_atomic2(u32 svc, u32 cmd, u32 arg1, u32 arg2);
 
 extern u32 scm_get_version(void);
 extern int scm_is_call_available(u32 svc_id, u32 cmd_id);
+extern int scm_get_feat_version(u32 feat);
 
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

