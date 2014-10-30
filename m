Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719AbaJ3MoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:44:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23881 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759953AbaJ3Mnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:43:32 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-3d-5452326ac5e7
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 09/10] power: charger-manager: Support different polling mode
 for sleep state.
Date: Thu, 30 Oct 2014 21:43:15 +0900
Message-id: <1414672996-28355-10-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkRDfLKCjE4PYuVYuDWzUtrn95zmox
	6cl7ZouJKyczW3SefcJscXnXHDaLz71HGC1uN65gs7h76iibxendJQ5cHhP6PzF67Jx1l91j
	8wotj02rOtk8+rasYvRYsfo7u8fnTXIB7FFcNimpOZllqUX6dglcGdtOTmQqeCJR8W/VBZYG
	xssiXYycHBICJhJdF74zQ9hiEhfurWfrYuTiEBJYyihxccZvdpiirev2skIkFjFKvN6yjRnC
	aWOSuNO0AqyKTUBH4v++m2C2iICCxObeZ2AdzAJXGCVuLl7PBJIQFkiQWLRtPVgRi4CqxI43
	txlBbF4BT4kze5cCTeUAWqcgMWeSDUiYEyi86cpMFhBbSMBD4sGuLnaQmRIC+9glVs6awggx
	R0Di2+RDLBC9shKbDkC9IylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525i
	BEbF6X/PJuxgvHfA+hCjAAejEg+v5onAECHWxLLiytxDjKZAGyYyS4km5wNjL68k3tDYzMjC
	1MTU2Mjc0kxJnPe11M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwa1g6L1l2zMl2Q+ebe
	17O+eRb/s9ny/s+wK+vle7NAl1E64cviCaoPf5srJx8wOZFslZrLr8d3aH/D8Xa7otxKyfXV
	SzTenmzz49vOWD6301bsyQKluoP5KyP2fDihaZFsNZPRLnLdclZrkdS0jcGHPhXOKeY0OnZe
	ep3VRYd9U4I4J1fzVSixFGckGmoxFxUnAgBUX5OQhQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jAd0so6AQg87TshYHt2paXP/ynNVi
	0pP3zBYTV05mtug8+4TZ4vKuOWwWn3uPMFrcblzBZnH31FE2i9O7Sxy4PCb0f2L02DnrLrvH
	5hVaHptWdbJ59G1ZxeixYvV3do/Pm+QC2KMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0M
	DHUNLS3MlRTyEnNTbZVcfAJ03TJzgK5TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTX
	Y2SABhLWMGZsOzmRqeCJRMW/VRdYGhgvi3QxcnJICJhIbF23lxXCFpO4cG89WxcjF4eQwCJG
	iddbtjFDOG1MEneaVrCDVLEJ6Ej833cTzBYRUJDY3PuMFaSIWeAKo8TNxeuZQBLCAgkSi7at
	BytiEVCV2PHmNiOIzSvgKXFm71KgqRxA6xQk5kyyAQlzAoU3XZnJAmILCXhIPNjVxT6BkXcB
	I8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCYeya1g3Flg8UhRgEORiUeXo0TgSFCrIll
	xZW5hxglOJiVRHiP6gSFCPGmJFZWpRblxxeV5qQWH2I0BTpqIrOUaHI+MB3klcQbGpuYGVka
	mRtaGBmbK4nzHmi1DhQSSE8sSc1OTS1ILYLpY+LglGpgXCj65u5JIbuGIwYzHXfxzJ6lVTLt
	a2GGa4GAoMhxdpns3a/8Zm2dJ8K5tvrPvJ2eIfXznExzbBy+XG/g4J5eocMbV3blQK9G7NW+
	8IXS/zh9N6lIpdz3XRZxIMAx/uyvrAWSys1rd0+ckKn7JME2eJ2YhGvx+2+qutwnOBPdb9e0
	9PgElXsqsRRnJBpqMRcVJwIA7BfqwM8CAAA=
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
index 1ccb9be..0a0834f 100644
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

