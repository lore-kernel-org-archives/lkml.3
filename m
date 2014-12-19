Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaLSIz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:55:59 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34500 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaLSIzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:55:41 -0500
X-AuditID: cbfee68d-f79296d000004278-3b-5493e8043fb8
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH V3 10/11] power: charger-manager: Support different polling
 mode for sleep state.
Date: Fri, 19 Dec 2014 17:55:22 +0900
Message-id: <1418979323-7188-11-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkSJflxeQQg7sbeSwObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEdx2aSk5mSWpRbp2yVwZcx4upGt4IlExdq2k6wN
	jJdFuhg5OSQETCQOPX7ODmGLSVy4t56ti5GLQ0hgKaPEtfm3GWGKrk09ygSRmM4ocXj+biin
	jUni84NPYO1sAjoS//fdBLNFBBQkNvc+YwUpYha4wihxc/F6JpCEsECyxJM/c8HGsgioSnTv
	2ckGYvMKeEg8/tsJFOcAWqcgMWeSDUiYEyj85+QWsFYhAXeJxi3foU7dxy6xa7ILxBgBiW+T
	D7FAtMpKbDrADFEiKXFwxQ2WCYzCCxgZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmIExsTp
	f896dzDePmB9iFGAg1GJh7ezcHKIEGtiWXFl7iFGU6ANE5mlRJPzgZGXVxJvaGxmZGFqYmps
	ZG5ppiTOqyj1M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY4dB8bbaFUeYEl6HT4uxUBc+
	En3lzT7W1We4trA/2bPEbkrU56CiXWfSc0QWr9VgFBIzj8vXrvvMu9zJ+OeZkxyOm31Xz78m
	wZoSbPnm29lNB3h3L5BN2+4oP7vp62WPuyJ3G+aa/eOxS353KUNZzND617MFVgty+wNlmzxZ
	GUxSVis1+5p5K7EUZyQaajEXFScCADgEU+yEAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jQV2WF5NDDK7cYbI4uFXT4vqX56wW
	k568Z7aYuHIys0Xn2SfMFpd3zWGz+Nx7hNHiduMKNou7p46yWZzeXeLA5TGh/xOjx85Zd9k9
	Nq/Q8ti0qpPNo2/LKkaPFau/s3t83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwhjFjxtONbAVPJCrWtp1kbWC8LNLFyMkhIWAicW3qUSYIW0ziwr31bF2MXBxCAtMZ
	JQ7P380E4bQxSXx+8IkdpIpNQEfi/76bYLaIgILE5t5nrCBFzAJXGCVuLl4PNkpYIFniyZ+5
	jCA2i4CqRPeenWwgNq+Ah8Tjv51AcQ6gdQoScybZgIQ5gcJ/Tm4BaxUScJdo3PKdfQIj7wJG
	hlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwTH3THoH46oGi0OMAhyMSjy8HYWTQ4RYE8uK
	K3MPMUpwMCuJ8DoeBwrxpiRWVqUW5ccXleakFh9iNAU6aiKzlGhyPjAd5JXEGxqbmBlZGpkb
	WhgZmyuJ8yrZt4UICaQnlqRmp6YWpBbB9DFxcEo1MKZe5277vmzjLItHVu7aiwVYPwb8ftdr
	k667aJv0Vt5tbOftQ+3Xz26cwcXBo3f1y1e7eSdXXdDJf1cWeLfNLL4+8Ge00CSbl0di7Pgm
	Na7Z6fp40rkru+V1dmTHsd3il7j1/8Xxx7cDTu7d4NJ+w6uztsOlbqXhhFbjr5zxYTfmxE8P
	fJCj56PEUpyRaKjFXFScCACQqoPczwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add additional polling mode for sleep state to define different mode with
normal state. With this change, charger-manager can work differently in
normal state or sleep state. e.g, polling aways for normal and polling
only when charing for sleep. If there is no defined polling mode for
sleep state it just follows the normal state's.
In addition to, polling rate is still same in sleep.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/power/charger-manager.c       |   20 +++++++++++++++++---
 include/linux/power/charger-manager.h |    9 ++++++---
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 4f8b0e6..f5787bc 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -291,7 +291,15 @@ static bool is_full_charged(struct charger_manager *cm)
  */
 static bool is_polling_required(struct charger_manager *cm)
 {
-	switch (cm->desc->polling_mode) {
+	enum polling_modes polling_mode;
+
+	if (cm_suspended
+		&& cm->desc->poll_mode_sleep >= 0)
+		polling_mode = cm->desc->poll_mode_sleep;
+	else
+		polling_mode = cm->desc->poll_mode_normal;
+
+	switch (polling_mode) {
 	case CM_POLL_DISABLE:
 		return false;
 	case CM_POLL_ALWAYS:
@@ -302,7 +310,7 @@ static bool is_polling_required(struct charger_manager *cm)
 		return is_charging(cm);
 	default:
 		dev_warn(cm->dev, "Incorrect polling_mode (%d)\n",
-			 cm->desc->polling_mode);
+			 polling_mode);
 	}
 
 	return false;
@@ -1158,7 +1166,13 @@ static struct charger_desc *of_cm_parse_desc(struct device *dev)
 	of_property_read_string(np, "cm-name", &desc->psy_name);
 
 	of_property_read_u32(np, "cm-poll-mode", &poll_mode);
-	desc->polling_mode = poll_mode;
+	desc->poll_mode_normal = poll_mode;
+
+	/* Polling mode in sleep state */
+	if (!of_property_read_u32(np, "cm-poll-mode-sleep", &poll_mode))
+		desc->poll_mode_sleep = poll_mode;
+	else
+		desc->poll_mode_sleep = -EINVAL;
 
 	of_property_read_u32(np, "cm-poll-interval",
 				&desc->polling_interval_ms);
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index 37fb181..a30a0b6 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -131,8 +131,10 @@ struct charger_regulator {
 /**
  * struct charger_desc
  * @psy_name: the name of power-supply-class for charger manager
- * @polling_mode:
- *	Determine which polling mode will be used
+ * @poll_mode_normal:
+ *	Determine which polling mode will be used in normal state.
+ * @poll_mode_sleep:
+ *	Determine which polling mode will be used in sleep state.
  * @fullbatt_vchkdrop_uV:
  *	Check voltage drop after the battery is fully charged.
  *	If it has dropped more than fullbatt_vchkdrop_uV
@@ -170,7 +172,8 @@ struct charger_regulator {
 struct charger_desc {
 	const char *psy_name;
 
-	enum polling_modes polling_mode;
+	enum polling_modes poll_mode_normal;
+	enum polling_modes poll_mode_sleep;
 	unsigned int polling_interval_ms;
 
 	unsigned int fullbatt_vchkdrop_uV;
-- 
1.7.9.5

