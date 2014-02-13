Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaBMDUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 22:20:04 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:57991 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987AbaBMDTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 22:19:19 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: lenb@kernel.org, rjw@rjwysocki.net, rui.zhang@intel.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH 4/6] drivers/acpi: fix fan driver compile error when CONFIG_PM_SLEEP is undefined
Date: Wed, 12 Feb 2014 20:19:08 -0700
Message-Id: <1e50ddee5b89d7566b9af4f5cb8b54e2614f04c0.1392250669.git.shuah.kh@samsung.com>
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

fan driver defines acpi_fan_suspend() and acpi_fan_resume() when
CONFIG_PM_SLEEP is defined. This results in the following compile error when
CONFIG_PM_SLEEP is undefined.

drivers/acpi/fan.c:60:8: error: ‘acpi_fan_suspend’ undeclared here (not in a function)
drivers/acpi/fan.c:60:8: error: ‘acpi_fan_resume’ undeclared here (not in a function)

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/acpi/fan.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 1fb6290..09e423f 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -55,6 +55,9 @@ MODULE_DEVICE_TABLE(acpi, fan_device_ids);
 #ifdef CONFIG_PM_SLEEP
 static int acpi_fan_suspend(struct device *dev);
 static int acpi_fan_resume(struct device *dev);
+#else
+#define acpi_fan_suspend NULL
+#define acpi_fan_resume NULL
 #endif
 static SIMPLE_DEV_PM_OPS(acpi_fan_pm, acpi_fan_suspend, acpi_fan_resume);
 
-- 
1.7.10.4

