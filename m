Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaBMDUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 22:20:07 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:57998 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbaBMDTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 22:19:17 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: lenb@kernel.org, rjw@rjwysocki.net, rui.zhang@intel.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH 3/6] drivers/acpi: fix button driver compile error when CONFIG_PM_SLEEP is undefined
Date: Wed, 12 Feb 2014 20:19:07 -0700
Message-Id: <c70a2e451d6f3800c0e571d6bfafa75b7a84b7e2.1392250669.git.shuah.kh@samsung.com>
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

button driver defines acpi_button_resume() when CONFIG_PM_SLEEP is defined.
This results in the following compile error when CONFIG_PM_SLEEP is undefined.

drivers/acpi/button.c:85:8: error: ‘acpi_button_resume’ undeclared here (not in a function)

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/acpi/button.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 11c11f6..714e957 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -80,6 +80,8 @@ static void acpi_button_notify(struct acpi_device *device, u32 event);
 
 #ifdef CONFIG_PM_SLEEP
 static int acpi_button_resume(struct device *dev);
+#else
+#define acpi_button_resume NULL
 #endif
 static SIMPLE_DEV_PM_OPS(acpi_button_pm, NULL, acpi_button_resume);
 
-- 
1.7.10.4

