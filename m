Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab3AONCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:02:20 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35915 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab3AOM4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:56:33 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/26] mfd: ab8500-sysctrl.c: Provide charging as reset reason
Date: Tue, 15 Jan 2013 12:55:44 +0000
Message-Id: <1358254566-12419-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

It's possible to supply a string to provide a reason for
triggering a restart. In this case our reason is to enter
charging-only mode, as a charger was found to be present.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
---
 drivers/mfd/ab8500-sysctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index 26216e7..cf58f69 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -59,7 +59,7 @@ void ab8500_power_off(void)
 			       "Charger \"%s\" is connected with known battery."
 			       " Rebooting.\n",
 			       pss[i]);
-			machine_restart(NULL);
+			machine_restart("charging");
 		}
 	}
 
-- 
1.7.9.5

