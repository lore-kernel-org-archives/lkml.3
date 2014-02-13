Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaBMDTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 22:19:54 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:50505 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbaBMDTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 22:19:15 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: lenb@kernel.org, rjw@rjwysocki.net, rui.zhang@intel.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH 1/6] drivers/acpi: fix ac driver compile error when CONFIG_PM_SLEEP is undefined
Date: Wed, 12 Feb 2014 20:19:05 -0700
Message-Id: <c9ab2647da7301e3e9033e2fbe80ad6bcafb85a2.1392250669.git.shuah.kh@samsung.com>
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

ac driver defines acpi_ac_resume() when CONFIG_PM_SLEEP is defined. This
results in the following compile error when CONFIG_PM_SLEEP is undefined.

drivers/acpi/ac.c:248:8: error: ‘acpi_ac_resume’ undeclared here (not in a function)

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/acpi/ac.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index e7515aa..6f190bc 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -243,6 +243,8 @@ static int acpi_ac_resume(struct device *dev)
 		kobject_uevent(&ac->charger.dev->kobj, KOBJ_CHANGE);
 	return 0;
 }
+#else
+#define acpi_ac_resume NULL
 #endif
 static SIMPLE_DEV_PM_OPS(acpi_ac_pm_ops, NULL, acpi_ac_resume);
 
-- 
1.7.10.4

