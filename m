Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbaJVLYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:24:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37263 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785AbaJVLYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:24:49 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: wim@iguana.be, thomas.mingarelli@hp.com, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] watchdog: hpwdt: Fix initialization message in hpwdt.c
Date: Wed, 22 Oct 2014 20:24:35 +0900
Message-Id: <1413977075-8938-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.2.451.g98349e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

allow_kdump was enabled as default since following commit.

commit a089361cf5f1d6a5295aa5385238bd044998e1e9,
watchdog: hpwdt: Unregister NMI events on exit.

But the initialization message was not modified.
So it still shows

  HP Watchdog Timer Driver: NMI decoding initialized,
  allow kernel dump: ON (default = 0/OFF)    <=

This "default = 0/OFF" message may confuse users.
Fix it as "default = 1/ON".

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/watchdog/hpwdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 75d2243..ada3e44 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -745,7 +745,7 @@ static int hpwdt_init_nmi_decoding(struct pci_dev *dev)
 
 	dev_info(&dev->dev,
 			"HP Watchdog Timer Driver: NMI decoding initialized"
-			", allow kernel dump: %s (default = 0/OFF)\n",
+			", allow kernel dump: %s (default = 1/ON)\n",
 			(allow_kdump == 0) ? "OFF" : "ON");
 	return 0;
 
-- 
2.1.2.451.g98349e5

