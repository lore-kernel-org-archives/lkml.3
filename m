Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3LQJPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:15:17 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42277 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab3LQJPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:15:15 -0500
Date: Tue, 17 Dec 2013 14:45:00 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-acpi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 02/11] drivers: acpi: Include appropriate header file in nvs.c
Message-ID: <1e397a06259f56042ec90d55fbf7423fc3bdca92.1387271324.git.rashika.kheria@gmail.com>
References: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include header file internal.h in nvs.c because functions
suspend_nvs_free(), suspend_nvs_alloc(), suspend_nvs_save() and
suspend_nvs_restore() have their prototype declaration in internal.h.

This eliminates the following warnings in nvs.c:
drivers/acpi/nvs.c:128:6: warning: no previous prototype for ‘suspend_nvs_free’ [-Wmissing-prototypes]
drivers/acpi/nvs.c:152:5: warning: no previous prototype for ‘suspend_nvs_alloc’ [-Wmissing-prototypes]
drivers/acpi/nvs.c:169:5: warning: no previous prototype for ‘suspend_nvs_save’ [-Wmissing-prototypes]
drivers/acpi/nvs.c:201:6: warning: no previous prototype for ‘suspend_nvs_restore’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/acpi/nvs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/nvs.c b/drivers/acpi/nvs.c
index 386a9fe..5841914 100644
--- a/drivers/acpi/nvs.c
+++ b/drivers/acpi/nvs.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/acpi_io.h>
+#include "internal.h"
 
 /* ACPI NVS regions, APEI may use it */
 
-- 
1.7.9.5

