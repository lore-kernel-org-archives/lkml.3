Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966014AbaFRKBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:01:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39438 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965903AbaFRKBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:01:19 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH v2 6/9] mfd: palmas: shift the palmas_sleep_requestor_info structure definition to the header file
Date: Wed, 18 Jun 2014 15:28:57 +0530
Message-ID: <1403085540-20014-7-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403085540-20014-1-git-send-email-j-keerthy@ti.com>
References: <1403085540-20014-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shift the palmas_sleep_requestor_info structure definition to the header file.

Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 drivers/mfd/palmas.c       |   10 ----------
 include/linux/mfd/palmas.h |   10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 6e17861..c12759d 100644
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
index c123666..0136e58 100644
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

