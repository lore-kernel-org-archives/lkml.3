Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750907AbaGCJVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:21:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51363 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbaGCJUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:20:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Binderman <dcb314@hotmail.com>, Bob Moore <robert.moore@intel.com>,
        Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 003/198] ACPICA: utstring: Check array index bound before use.
Date: Thu,  3 Jul 2014 10:17:26 +0100
Message-Id: <1404379241-8590-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Binderman <dcb314@hotmail.com>

commit 5d42b0fa25df7ef2f575107597c1aaebe2407d10 upstream.

ACPICA BZ 1077. David Binderman.

References: https://bugs.acpica.org/show_bug.cgi?id=1077
Signed-off-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/acpica/utstring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/utstring.c b/drivers/acpi/acpica/utstring.c
index c53759b76a3f..9edb65f516a6 100644
--- a/drivers/acpi/acpica/utstring.c
+++ b/drivers/acpi/acpica/utstring.c
@@ -352,7 +352,7 @@ void acpi_ut_print_string(char *string, u8 max_length)
 	}
 
 	acpi_os_printf("\"");
-	for (i = 0; string[i] && (i < max_length); i++) {
+	for (i = 0; (i < max_length) && string[i]; i++) {
 
 		/* Escape sequences */
 
-- 
1.9.1

