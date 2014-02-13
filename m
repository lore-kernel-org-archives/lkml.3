Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaBMDUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 22:20:01 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:52295 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbaBMDTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 22:19:20 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: lenb@kernel.org, rjw@rjwysocki.net, rui.zhang@intel.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH 6/6] drivers/acpi: fix thermal driver compile error when CONFIG_PM_SLEEP is undefined
Date: Wed, 12 Feb 2014 20:19:10 -0700
Message-Id: <cf2b092c9e1fcb1ea56d56284745836df45c9c79.1392250669.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1392250669.git.shuah.kh@samsung.com>
References: <cover.1392250669.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1392250669.git.shuah.kh@samsung.com>
References: <cover.1392250669.git.shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thermal driver defines acpi_thermal_resume() when CONFIG_PM_SLEEP is defined.
This results in the following compile error when CONFIG_PM_SLEEP is undefined.

  CC      drivers/acpi/thermal.o
drivers/acpi/thermal.c:107:8: error: ‘acpi_thermal_resume’ undeclared here (not in a function)
make[2]: *** [drivers/acpi/thermal.o] Error 1

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/acpi/thermal.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 8349a55..08626c8 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -102,6 +102,8 @@ MODULE_DEVICE_TABLE(acpi, thermal_device_ids);
 
 #ifdef CONFIG_PM_SLEEP
 static int acpi_thermal_resume(struct device *dev);
+#else
+#define acpi_thermal_resume NULL
 #endif
 static SIMPLE_DEV_PM_OPS(acpi_thermal_pm, NULL, acpi_thermal_resume);
 
-- 
1.7.10.4

