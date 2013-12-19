Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab3LSPIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:08:49 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:57686 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab3LSPIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:08:45 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 38/38] bcma: add missing put_device call
Date: Thu, 19 Dec 2013 16:06:52 +0100
Message-Id: <1387465612-3673-39-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465612-3673-33-git-send-email-levex@linux.com>
References: <1387465612-3673-33-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/bcma/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index e15430a..5a9f6bd 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -176,6 +176,7 @@ static int bcma_register_cores(struct bcma_bus *bus)
 			bcma_err(bus,
 				 "Could not register dev for core 0x%03X\n",
 				 core->id.id);
+			put_device(&core->dev);
 			continue;
 		}
 		core->dev_registered = true;
-- 
1.8.3.1

