Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaLSCsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:48:09 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14641 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaLSCro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:47:44 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-de-549391c971b8
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH RESEND v2 09/10] power: charger-manager: Support different
 polling mode for sleep state.
Date: Fri, 19 Dec 2014 11:47:29 +0900
Message-id: <1418957250-6542-10-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkSPfkxMkhBq8eq1sc3Kppcf3Lc1aL
	SU/eM1tMXDmZ2aLz7BNmi8u75rBZfO49wmhxu3EFm8XdU0fZLE7vLnHg8pjQ/4nRY+esu+we
	m1doeWxa1cnm0bdlFaPHitXf2T0+b5ILYI/isklJzcksSy3St0vgyth2ciJTwROJin+rLrA0
	MF4W6WLk5JAQMJFob/vBBmGLSVy4tx7I5uIQEljKKPHoyGM2mKIFS+cwQSQWMUp8u3UEqqqN
	SWLH5a9gVWwCOhL/991kB7FFBBQkNvc+YwUpYha4wihxc/F6JpCEsECWxPKn11lAbBYBVYn9
	s6cxgti8Ah4Sc+6sB7I5gNYpSMyZZAMS5gQKP73UBDZfSMBd4sS3tywgMyUEdrFLtC++xgox
	R0Di2+RDLBC9shKbDjBDXC0pcXDFDZYJjMILGBlWMYqmFiQXFCelF5noFSfmFpfmpesl5+du
	YgRGxel/zybsYLx3wPoQowAHoxIP74PiySFCrIllxZW5hxhNgTZMZJYSTc4Hxl5eSbyhsZmR
	hamJqbGRuaWZkjjva6mfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYZ3K/fX+eU+n+pecR
	i5fmZX9u+Gn9QkO/RVy/yvjNPtmPqg/25FwIWLFA7NHDhMV5MnUb1lZu86o1epvOVPSlTclh
	e/qmQ6wLalVvXC5Zxqsg8mbqRf3N7T+5L0/129zjsOUZW8XH6RY//un8WqNzZWI844ljiv/s
	ZJ0nzZn/4r5p3ISQ2J3mf5VYijMSDbWYi4oTAS8YGWaFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jAd2TEyeHGFzfK29xcKumxfUvz1kt
	Jj15z2wxceVkZovOs0+YLS7vmsNm8bn3CKPF7cYVbBZ3Tx1lszi9u8SBy2NC/ydGj52z7rJ7
	bF6h5bFpVSebR9+WVYweK1Z/Z/f4vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTM
	wFDX0NLCXEkhLzE31VbJxSdA1y0zB+g6JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFw
	PUYGaCBhDWPGtpMTmQqeSFT8W3WBpYHxskgXIyeHhICJxIKlc5ggbDGJC/fWs3UxcnEICSxi
	lPh26wiU08YksePyVzaQKjYBHYn/+26yg9giAgoSm3ufsYIUMQtcYZS4uXg92ChhgSyJ5U+v
	s4DYLAKqEvtnT2MEsXkFPCTm3FkPZHMArVOQmDPJBiTMCRR+eqkJbL6QgLvEiW9vWSYw8i5g
	ZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxzz6R2MK5ssDjEKMDBqMTD21E4OUSINbGs
	uDL3EKMEB7OSCK95JlCINyWxsiq1KD++qDQntfgQoynQUROZpUST84HpIK8k3tDYxMzI0sjc
	0MLI2FxJnFfJvi1ESCA9sSQ1OzW1ILUIpo+Jg1OqgTHwbkGI9nHp6nw2nl3B97R7zdq6v3Ed
	+9D8y/hThfPTZ1d5+dcfllxZKGBycP3L+aI9Xk7N1gvVAq8o7lon4jRHwyzkVerlymTmrCoL
	hxymqedv31xdW9Ieunb6CaHOB5ceKjFf+njSjOFKeC7rXIWQK0/2vnZTLjWc/PWHaO1HjUlL
	3Vq67JVYijMSDbWYi4oTAZDv+8zPAgAA
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

