Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965162AbaGOW2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:28:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53901 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758105AbaGOVbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:31:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Binderman <dcb314@hotmail.com>, Bob Moore <robert.moore@intel.com>,
        Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 011/198] ACPICA: utstring: Check array index bound before use.
Date: Tue, 15 Jul 2014 14:28:01 -0700
Message-Id: <1405459868-15089-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Binderman <dcb314@hotmail.com>

commit 5d42b0fa25df7ef2f575107597c1aaebe2407d10 upstream.

ACPICA BZ 1077. David Binderman.

References: https://bugs.acpica.org/show_bug.cgi?id=1077
Signed-off-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/acpica/utstring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/utstring.c b/drivers/acpi/acpica/utstring.c
index 45c0eb2..cd2047a 100644
--- a/drivers/acpi/acpica/utstring.c
+++ b/drivers/acpi/acpica/utstring.c
@@ -353,7 +353,7 @@ void acpi_ut_print_string(char *string, u16 max_length)
 	}
 
 	acpi_os_printf("\"");
-	for (i = 0; string[i] && (i < max_length); i++) {
+	for (i = 0; (i < max_length) && string[i]; i++) {
 
 		/* Escape sequences */
 
-- 
1.9.1

