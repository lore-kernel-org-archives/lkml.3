Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaBMDT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 22:19:57 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:53732 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbaBMDTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 22:19:16 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: lenb@kernel.org, rjw@rjwysocki.net, rui.zhang@intel.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH 2/6] drivers/acpi: fix battery driver compile error when CONFIG_PM_SLEEP is undefined
Date: Wed, 12 Feb 2014 20:19:06 -0700
Message-Id: <3983d1980b59ffb8522b0e26e60f8587c554438d.1392250669.git.shuah.kh@samsung.com>
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

battery driver defines acpi_battery_resume() when CONFIG_PM_SLEEP is defined.
This results in the following compile error when CONFIG_PM_SLEEP is undefined.

drivers/acpi/battery.c:847:8: error: ‘acpi_battery_resume’ undeclared here (not in a function)

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/acpi/battery.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 018a428..797a693 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -841,6 +841,8 @@ static int acpi_battery_resume(struct device *dev)
 	acpi_battery_update(battery);
 	return 0;
 }
+#else
+#define acpi_battery_resume NULL
 #endif
 
 static SIMPLE_DEV_PM_OPS(acpi_battery_pm, NULL, acpi_battery_resume);
-- 
1.7.10.4

