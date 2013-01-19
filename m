Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab3ASM47 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 07:56:59 -0500
Received: from mail.ispras.ru ([83.149.199.43]:36184 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab3ASM45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 07:56:57 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ilw@linux.intel.com,
        ldv-project@linuxtesting.org
Subject: [PATCH] iwlegacy: don't return zero on failure paths in il4965_pci_probe()
Date: Sat, 19 Jan 2013 16:56:34 +0400
Message-Id: <1358600194-20371-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If hardware is not ready, il4965_pci_probe() breaks off initialization,
deallocates all resources, but returns zero.
The patch adds -EIO as return value in this case.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index c3fbf67..c805108 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6553,6 +6553,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	il4965_prepare_card_hw(il);
 	if (!il->hw_ready) {
 		IL_WARN("Failed, HW not ready\n");
+		err = -EIO;
 		goto out_iounmap;
 	}
 
-- 
1.7.9.5

