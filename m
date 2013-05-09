Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab3EIRKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 13:10:41 -0400
Received: from nm17.access.bullet.mail.sp2.yahoo.com ([98.139.44.144]:40576
	"EHLO nm17.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731Ab3EIRJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 13:09:47 -0400
X-Yahoo-Newman-Id: 785551.73437.bm@smtp102.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: cykGoBIVM1lxuS7GPkpjfmQUppszFrzkbYcakxDc_1xNjps
 WyzGwbYU731nCUH9hJ3V1r3MfOz1RcaldU0ETvtTWvK0zFKZmZAtVQ.QksOR
 3D1yZM_QrUhQ03J53nxVeC9VAUXAGdrXMEWz3K.jgFwC8BSzTmi8Z5uUbCKr
 x3VCP7282O1Nb3Ug38IVTdYddQpJ.eF6Tz7Wls1NC.YSuZMAH0wKeM7G4W4s
 2dCqZce8UgaBfpeAiS1F1yEY7eiCB4KktuknJ0vyBLyLZ9FqVBdbuZPv0XMW
 R5STf7wwUKl0EssCr0SCCog.MdHX9d6z80w4KxEJtbGotnqx3q1U7VLEq5cm
 f51SygxIgrV.Q_SD8UgVTn9FLBW2eXPz94Jj7Q6Ni9FPgrMdMcTBPh21HMay
 qLGLUhOWm4rTYEv_ZRtbrp2mKVG8Lqut0dmDxlrb0lO44feg5ooTOPYPWJas
 dOsMVgoS4caqsI4QXpYUVSZzyQv_i.jdQByLlYaLt_AdE0ZFB0P6B
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp102.sbc.mail.ne1.yahoo.com with SMTP; 09 May 2013 17:09:46 +0000 UTC
From: Guenter Roeck <linux@roeck-us.net>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Jean Delvare <khali@linux-fr.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jingoo Han <jg1.han@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 1/3] pm: Introduce __pm to mark power management functions and data
Date: Thu,  9 May 2013 10:09:49 -0700
Message-Id: <1368119391-13837-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1368119391-13837-1-git-send-email-linux@roeck-us.net>
References: <1368119391-13837-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By marking power management functions and data with __pm, #ifdef CONFIG_PM
and #ifdef CONFIG_PM_SLEEP is no longer necessary in most cases.
This ensures that the power management code still compiles even if power
management is disabled, but does not consume space in the object file.
As a side effect, drivers declaring struct dev_pm_ops unconditionally
get a bit smaller if CONFIG_PM_SLEEP is disabled.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 include/linux/pm.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index fe70d9b..46df155 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -43,9 +43,11 @@ struct device;
 #ifdef CONFIG_PM
 extern const char power_group_name[];		/* = "power" */
 #define pm_ops_ptr(_ptr)	(_ptr)
+#define __pm
 #else
 #define power_group_name	NULL
 #define pm_ops_ptr(_ptr)	NULL
+#define __pm			__section(.discard)
 #endif
 
 typedef struct pm_message {
-- 
1.7.9.7

