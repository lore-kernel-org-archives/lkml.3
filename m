Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab3CLSxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:53:15 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:64911 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab3CLSxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:53:13 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: acpi: Used resource_size function
Date: Tue, 12 Mar 2013 10:53:02 +0200
Message-Id: <1363078382-30229-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used resource_size function instead of explicit computation.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/acpi/osl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 586e7e9..4d31748 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1555,7 +1555,7 @@ int acpi_check_resource_conflict(const struct resource *res)
 	else
 		space_id = ACPI_ADR_SPACE_SYSTEM_MEMORY;
 
-	length = res->end - res->start + 1;
+	length = resource_size(res);
 	if (acpi_enforce_resources != ENFORCE_RESOURCES_NO)
 		warn = 1;
 	clash = acpi_check_address_range(space_id, res->start, length, warn);
-- 
1.7.9.5

