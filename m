Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaEHAbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 20:31:51 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:45869 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaEHAbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 20:31:50 -0400
From: Derek Basehore <dbasehore@chromium.org>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Derek Basehore <dbasehore@chromium.org>
Subject: [PATCH] tpm: Fix tpm init with no ACPI entry
Date: Wed,  7 May 2014 17:31:40 -0700
Message-Id: <1399509100-27169-1-git-send-email-dbasehore@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tpm_add_ppi fails without ACPI support now, but loading the tpm without an ACPI
entry is a valid use case. This changes the init of the tpm to not fail when
tpm_add_ppi fails.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
---
 drivers/char/tpm/tpm-interface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 62e10fd..8bfa339 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1094,8 +1094,7 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 	if (tpm_sysfs_add_device(chip))
 		goto del_misc;
 
-	if (tpm_add_ppi(&dev->kobj))
-		goto del_misc;
+	tpm_add_ppi(&dev->kobj);
 
 	chip->bios_dir = tpm_bios_log_setup(chip->devname);
 
-- 
1.9.1.423.g4596e3a

