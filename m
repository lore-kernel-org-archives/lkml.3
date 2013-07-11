Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab3GKOs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:48:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42920 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab3GKOZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Shane Huang <shane.huang@amd.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 23/98] ahci: remove pmp link online check in FBS EH
Date: Thu, 11 Jul 2013 15:23:53 +0100
Message-Id: <1373552708-15235-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shane Huang <shane.huang@amd.com>

commit 912b9ac683b112615d5605686f1dc086402ce9f7 upstream.

ata_link_online() check in ahci_error_intr() is unnecessary, it should
be removed otherwise may lead to lockup with FBS enabled PMP.
http://marc.info/?l=linux-ide&m=137050421603272&w=2

Reported-by: Yu Liu <liuyu.ac@gmail.com>
Signed-off-by: Shane Huang <shane.huang@amd.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/libahci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index f9eaa82..47a1fb8 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1543,8 +1543,7 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 		u32 fbs = readl(port_mmio + PORT_FBS);
 		int pmp = fbs >> PORT_FBS_DWE_OFFSET;
 
-		if ((fbs & PORT_FBS_SDE) && (pmp < ap->nr_pmp_links) &&
-		    ata_link_online(&ap->pmp_link[pmp])) {
+		if ((fbs & PORT_FBS_SDE) && (pmp < ap->nr_pmp_links)) {
 			link = &ap->pmp_link[pmp];
 			fbs_need_dec = true;
 		}
-- 
1.8.1.2

