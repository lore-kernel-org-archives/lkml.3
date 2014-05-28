Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaE1KV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:21:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33999 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbaE1KV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:21:57 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH 6/9] mfd: palmas: shift the palmas_sleep_requestor_info structure definition to the header file
Date: Wed, 28 May 2014 15:50:19 +0530
Message-ID: <1401272423-25761-7-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401272423-25761-1-git-send-email-j-keerthy@ti.com>
References: <1401272423-25761-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shift the palmas_sleep_requestor_info structure definition to the header file.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 drivers/mfd/palmas.c       |   10 ----------
 include/linux/mfd/palmas.h |   10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 485d755..f1f31d5 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -25,16 +25,6 @@
 #include <linux/mfd/palmas.h>
 #include <linux/of_device.h>
 
-#define PALMAS_EXT_REQ (PALMAS_EXT_CONTROL_ENABLE1 |	\
-			PALMAS_EXT_CONTROL_ENABLE2 |	\
-			PALMAS_EXT_CONTROL_NSLEEP)
-
-struct palmas_sleep_requestor_info {
-	int id;
-	int reg_offset;
-	int bit_pos;
-};
-
 #define EXTERNAL_REQUESTOR(_id, _offset, _pos)		\
 	[PALMAS_EXTERNAL_REQSTR_ID_##_id] = {		\
 		.id = PALMAS_EXTERNAL_REQSTR_ID_##_id,	\
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 150a6314..8d68452 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -88,6 +88,16 @@ struct palmas {
 	u8 pwm_muxed;
 };
 
+#define PALMAS_EXT_REQ (PALMAS_EXT_CONTROL_ENABLE1 |	\
+			PALMAS_EXT_CONTROL_ENABLE2 |	\
+			PALMAS_EXT_CONTROL_NSLEEP)
+
+struct palmas_sleep_requestor_info {
+	int id;
+	int reg_offset;
+	int bit_pos;
+};
+
 struct regs_info {
 	char	*name;
 	char	*sname;
-- 
1.7.9.5

