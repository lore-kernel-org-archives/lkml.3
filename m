Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3CLSdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:33:17 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50734 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab3CLSdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:33:14 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: acpi: Used PTR_RET function
Date: Tue, 12 Mar 2013 10:32:51 +0200
Message-Id: <1363077171-30141-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used PTR_RET function instead of explicit checking with IS_ERR.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/acpi/acpi_pad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index 31de104..27bb6a9 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -236,7 +236,7 @@ static int create_power_saving_task(void)
 	ps_tsks[ps_tsk_num] = kthread_run(power_saving_thread,
 		(void *)(unsigned long)ps_tsk_num,
 		"acpi_pad/%d", ps_tsk_num);
-	rc = IS_ERR(ps_tsks[ps_tsk_num]) ? PTR_ERR(ps_tsks[ps_tsk_num]) : 0;
+	rc = PTR_RET(ps_tsks[ps_tsk_num]);
 	if (!rc)
 		ps_tsk_num++;
 	else
-- 
1.7.9.5

