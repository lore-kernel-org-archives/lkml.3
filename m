Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495AbbAILAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:00:22 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44494 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756915AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 29/78] ahci: disable MSI on SAMSUNG 0xa800 SSD
Date: Fri,  9 Jan 2015 11:31:38 +0100
Message-Id: <d7f79e0e3fe95a973e4047474c6c7bf3246b7a0f.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2b21ef0aae65f22f5ba86b13c4588f6f0c2dbefb upstream.

Just like 0x1600 which got blacklisted by 66a7cbc303f4 ("ahci: disable
MSI instead of NCQ on Samsung pci-e SSDs on macbooks"), 0xa800 chokes
on NCQ commands if MSI is enabled.  Disable MSI.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dominik Mierzejewski <dominik@greysector.net>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=89171
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/ata/ahci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index e0a8a793d14a..53111fd27ebb 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -494,6 +494,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	 * enabled.  https://bugzilla.kernel.org/show_bug.cgi?id=60731
 	 */
 	{ PCI_VDEVICE(SAMSUNG, 0x1600), board_ahci_nomsi },
+	{ PCI_VDEVICE(SAMSUNG, 0xa800), board_ahci_nomsi },
 
 	/* Enmotus */
 	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
-- 
2.2.1

