Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaIPUyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:54:05 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:39763 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbaIPUwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:52:18 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Darren Hart <dvhart@infradead.org>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH 17/22] thinkpad_acpi: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:31 +0200
Message-Id: <1410900696-6481-18-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics
and a slightly buggy strncasecmp. The latter is the POSIX name, so
strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
for the new strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in
the future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: Darren Hart <dvhart@infradead.org>
Cc: ibm-acpi-devel@lists.sourceforge.net
Cc: platform-driver-x86@vger.kernel.org
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/platform/x86/thinkpad_acpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 3bbc6eb..f6a14c0 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8878,13 +8878,13 @@ static int __must_check __init get_thinkpad_model_data(
 	}
 
 	s = dmi_get_system_info(DMI_PRODUCT_VERSION);
-	if (s && !(strnicmp(s, "ThinkPad", 8) && strnicmp(s, "Lenovo", 6))) {
+	if (s && !(strncasecmp(s, "ThinkPad", 8) && strncasecmp(s, "Lenovo", 6))) {
 		tp->model_str = kstrdup(s, GFP_KERNEL);
 		if (!tp->model_str)
 			return -ENOMEM;
 	} else {
 		s = dmi_get_system_info(DMI_BIOS_VENDOR);
-		if (s && !(strnicmp(s, "Lenovo", 6))) {
+		if (s && !(strncasecmp(s, "Lenovo", 6))) {
 			tp->model_str = kstrdup(s, GFP_KERNEL);
 			if (!tp->model_str)
 				return -ENOMEM;
-- 
2.0.4

