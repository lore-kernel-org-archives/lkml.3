Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbaFAM6D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:58:03 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:44828 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaFAM6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:58:00 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] platform: x86: asus-wmi.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 14:58:52 +0200
Message-Id: <1401627532-16856-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/platform/x86/asus-wmi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index c5e082f..3fc7f39 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -266,7 +266,7 @@ static int asus_wmi_evaluate_method(u32 method_id, u32 arg0, u32 arg1,
 	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
 	acpi_status status;
 	union acpi_object *obj;
-	u32 tmp;
+	u32 tmp = 0;
 
 	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 1, method_id,
 				     &input, &output);
@@ -277,8 +277,6 @@ static int asus_wmi_evaluate_method(u32 method_id, u32 arg0, u32 arg1,
 	obj = (union acpi_object *)output.pointer;
 	if (obj && obj->type == ACPI_TYPE_INTEGER)
 		tmp = (u32) obj->integer.value;
-	else
-		tmp = 0;
 
 	if (retval)
 		*retval = tmp;
-- 
1.7.10.4

