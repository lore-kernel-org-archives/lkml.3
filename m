Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbaF3MbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:31:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867AbaF3MbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Binderman <dcb314@hotmail.com>,
        Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 141/181] ACPICA: utstring: Check array index bound before use.
Date: Mon, 30 Jun 2014 13:52:42 +0200
Message-Id: <16aaeaa7ef7905a29d243dce1b4f6244ae815a7a.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Binderman <dcb314@hotmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5d42b0fa25df7ef2f575107597c1aaebe2407d10 upstream.

ACPICA BZ 1077. David Binderman.

References: https://bugs.acpica.org/show_bug.cgi?id=1077
Signed-off-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/acpi/acpica/utstring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/utstring.c b/drivers/acpi/acpica/utstring.c
index cb1e9cc32d5f..3d8748ae488f 100644
--- a/drivers/acpi/acpica/utstring.c
+++ b/drivers/acpi/acpica/utstring.c
@@ -353,7 +353,7 @@ void acpi_ut_print_string(char *string, u16 max_length)
 	}
 
 	acpi_os_printf("\"");
-	for (i = 0; string[i] && (i < max_length); i++) {
+	for (i = 0; (i < max_length) && string[i]; i++) {
 
 		/* Escape sequences */
 
-- 
2.0.0

