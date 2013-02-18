Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab3BRT4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 14:56:45 -0500
Received: from mail.tpi.com ([70.99.223.143]:4607 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab3BRT4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 14:56:43 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH linux-next] rt2x00: rt2x00pci_regbusy_read() - only print register access failure once
Date: Mon, 18 Feb 2013 12:56:28 -0700
Message-Id: <1361217389-111229-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/1128840

It appears that when this register read fails it never recovers, so
I think there is no need to repeat the same error message ad infinitum.

Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

This patch applies as far back as 3.0.65 (and maybe older but that is
as far back as I checked).

 drivers/net/wireless/rt2x00/rt2x00pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index a0c8cae..b1c673e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -52,8 +52,8 @@ int rt2x00pci_regbusy_read(struct rt2x00_dev *rt2x00dev,
 		udelay(REGISTER_BUSY_DELAY);
 	}
 
-	ERROR(rt2x00dev, "Indirect register access failed: "
-	      "offset=0x%.08x, value=0x%.08x\n", offset, *reg);
+	printk_once(KERN_ERR "%s() Indirect register access failed: "
+	      "offset=0x%.08x, value=0x%.08x\n", __func__, offset, *reg);
 	*reg = ~0;
 
 	return 0;
-- 
1.7.9.5

