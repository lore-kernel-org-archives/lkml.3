Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab3APLTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 06:19:53 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:42117 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612Ab3APLTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 06:19:52 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: lenb@kernel.org
Cc: rjw@sisk.pl, linux-acpi@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: check zero length in acpi_rs_get_aml_length
Date: Wed, 16 Jan 2013 12:15:28 +0100
Message-Id: <1358334928-9736-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug somewhere in the code that does not set the resource
length. This makes the loop in acpi_rs_get_aml_length to loop forever.
So it is a good thing to have the check even if the bug is fixed.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/acpi/acpica/rscalc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/rscalc.c b/drivers/acpi/acpica/rscalc.c
index da178b4..c128f2e 100644
--- a/drivers/acpi/acpica/rscalc.c
+++ b/drivers/acpi/acpica/rscalc.c
@@ -198,7 +198,8 @@ acpi_rs_get_aml_length(struct acpi_resource * resource, acpi_size * size_needed)
 
 		/* Validate the descriptor type */
 
-		if (resource->type > ACPI_RESOURCE_TYPE_MAX) {
+		if (resource->type > ACPI_RESOURCE_TYPE_MAX ||
+				WARN_ON(!resource->length)) {
 			return_ACPI_STATUS(AE_AML_INVALID_RESOURCE_TYPE);
 		}
 
-- 
1.8.1


