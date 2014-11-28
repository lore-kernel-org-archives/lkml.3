Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaK1WPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 17:15:34 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57713 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaK1WPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 17:15:33 -0500
From: Giedrius Statkevicius <giedriuswork@gmail.com>
To: dvhart@infradead.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Giedrius Statkevicius <giedriuswork@gmail.com>
Subject: [PATCH] platform: x86: hp_wireless: Inform the user if hp_wireless_input_setup()/add() fails
Date: Sat, 29 Nov 2014 00:14:27 +0200
Message-Id: <1417212867-25187-1-git-send-email-giedriuswork@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hpwl_add() there is a unused variable err to which we assign the
result of hp_wireless_input_setup() but we don't do anything depending
on the result so print out a message that informs the user if add()
(hp_wireless_input_setup()) fails since acpi_device_probe() doesn't
print anything in this case.

Signed-off-by: Giedrius Statkevicius <giedriuswork@gmail.com>
---
 drivers/platform/x86/hp-wireless.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/hp-wireless.c b/drivers/platform/x86/hp-wireless.c
index 415348f..4e4cc8b 100644
--- a/drivers/platform/x86/hp-wireless.c
+++ b/drivers/platform/x86/hp-wireless.c
@@ -85,6 +85,9 @@ static int hpwl_add(struct acpi_device *device)
 	int err;
 
 	err = hp_wireless_input_setup();
+	if (err)
+		pr_err("Failed to setup hp wireless hotkeys\n");
+
 	return err;
 }
 
-- 
2.1.3

