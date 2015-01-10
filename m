Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbbAOJYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:24:09 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:49894 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751045AbbAOJYH (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 15 Jan 2015 04:24:07 -0500
From: Nan Li <nli@suse.com>
To: lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, Nan Li <nli@suse.com>
Subject: [PATCH] The count field of counter_show() function should be an unsigned value
Date: Sun, 11 Jan 2015 01:45:41 +0800
Message-Id: <1420911941-21968-1-git-send-email-nli@suse.com>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The count field is an unsigned 32bit value, and the
counter_show() function should also treat it as a unsigned
value.

Signed-off-by: Nan Li <nli@suse.com>
---
 drivers/acpi/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index 13e577c..0876d77 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -527,7 +527,7 @@ static ssize_t counter_show(struct kobject *kobj,
 	    acpi_irq_not_handled;
 	all_counters[num_gpes + ACPI_NUM_FIXED_EVENTS + COUNT_GPE].count =
 	    acpi_gpe_count;
-	size = sprintf(buf, "%8d", all_counters[index].count);
+	size = sprintf(buf, "%8u", all_counters[index].count);
 
 	/* "gpe_all" or "sci" */
 	if (index >= num_gpes + ACPI_NUM_FIXED_EVENTS)
-- 
1.7.12.4

