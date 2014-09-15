Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbaIOWOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:14:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50844 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbaIOWOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:14:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David E. Box" <david.e.box@linux.intel.com>,
        Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 068/187] ACPICA: Utilities: Fix memory leak in acpi_ut_copy_iobject_to_iobject
Date: Mon, 15 Sep 2014 15:07:58 -0700
Message-Id: <1410818997-9432-69-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David E. Box" <david.e.box@linux.intel.com>

commit 8aa5e56eeb61a099ea6519eb30ee399e1bc043ce upstream.

Adds return status check on copy routines to delete the allocated destination
object if either copy fails. Reported by Colin Ian King on bugs.acpica.org,
Bug 1087.
The last applicable commit:
 Commit: 3371c19c294a4cb3649aa4e84606be8a1d999e61
 Subject: ACPICA: Remove ACPI_GET_OBJECT_TYPE macro

Link: https://bugs.acpica.org/show_bug.cgi?id=1087
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/acpica/utcopy.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/acpica/utcopy.c b/drivers/acpi/acpica/utcopy.c
index edff4e6..c66bca1 100644
--- a/drivers/acpi/acpica/utcopy.c
+++ b/drivers/acpi/acpica/utcopy.c
@@ -1001,5 +1001,11 @@ acpi_ut_copy_iobject_to_iobject(union acpi_operand_object *source_desc,
 		status = acpi_ut_copy_simple_object(source_desc, *dest_desc);
 	}
 
+	/* Delete the allocated object if copy failed */
+
+	if (ACPI_FAILURE(status)) {
+		acpi_ut_remove_reference(*dest_desc);
+	}
+
 	return_ACPI_STATUS(status);
 }
-- 
1.9.1

