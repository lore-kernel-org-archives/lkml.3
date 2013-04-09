Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936100Ab3DIHGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:06:14 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36172 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935818Ab3DIHGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:06:10 -0400
Date: Tue, 9 Apr 2013 15:05:40 +0800
From: Wang YanQing <udknight@gmail.com>
To: jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH][TRIVIAL] ata:pata_pdc2027x: Fix compiler warnings
Message-ID: <20130409070539.GA5892@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, jkosina@suse.cz,
	linux-kernel@vger.kernel.org, trivial@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the follwing warnings:
linux/drivers/ata/pata_pdc2027x.c:66: warning: 'pdc2027x_reinit_one' declared 'static' but never defined

pdc2027x_reinit_one are defined only when CONFIG_PM is defined,
thus making it conditional.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/ata/pata_pdc2027x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 3f94a88..c76e659 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -63,7 +63,9 @@ enum {
 };
 
 static int pdc2027x_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
+#ifdef CONFIG_PM
 static int pdc2027x_reinit_one(struct pci_dev *pdev);
+#endif
 static int pdc2027x_prereset(struct ata_link *link, unsigned long deadline);
 static void pdc2027x_set_piomode(struct ata_port *ap, struct ata_device *adev);
 static void pdc2027x_set_dmamode(struct ata_port *ap, struct ata_device *adev);
-- 
1.7.12.4.dirty
