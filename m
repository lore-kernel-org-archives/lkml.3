Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaKDXtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:49:23 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:45193 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaKDXtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:49:20 -0500
From: Giedrius Statkevicius <giedriuswork@gmail.com>
To: dvhart@infradead.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Giedrius=20Statkevi=C4=8Dius?= <giedriuswork@gmail.com>
Subject: [PATCH] platform: x86: remove redundant variable in hp-wireless.c
Date: Wed,  5 Nov 2014 01:47:19 +0200
Message-Id: <1415144839-2035-1-git-send-email-giedriuswork@gmail.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a variable because it only holds the results of a function call
and then gets returned so instead just return the result of a function
call.

Signed-off-by: Giedrius Statkevičius <giedriuswork@gmail.com>
---
 drivers/platform/x86/hp-wireless.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/platform/x86/hp-wireless.c b/drivers/platform/x86/hp-wireless.c
index 415348f..670c62b 100644
--- a/drivers/platform/x86/hp-wireless.c
+++ b/drivers/platform/x86/hp-wireless.c
@@ -82,10 +82,7 @@ static void hpwl_notify(struct acpi_device *acpi_dev, u32 event)
 
 static int hpwl_add(struct acpi_device *device)
 {
-	int err;
-
-	err = hp_wireless_input_setup();
-	return err;
+	return hp_wireless_input_setup();
 }
 
 static int hpwl_remove(struct acpi_device *device)
-- 
2.1.3

