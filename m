Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab3GXOYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:24:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45708 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015Ab3GXOGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Shane Huang" <shane.huang@amd.com>,
        "Tejun Heo" <tj@kernel.org>, "Yu Liu" <liuyu.ac@gmail.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.543884115@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [13/85] ahci: remove pmp link online check in FBS EH
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Shane Huang <shane.huang@amd.com>

commit 912b9ac683b112615d5605686f1dc086402ce9f7 upstream.

ata_link_online() check in ahci_error_intr() is unnecessary, it should
be removed otherwise may lead to lockup with FBS enabled PMP.
http://marc.info/?l=linux-ide&m=137050421603272&w=2

Reported-by: Yu Liu <liuyu.ac@gmail.com>
Signed-off-by: Shane Huang <shane.huang@amd.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/libahci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1541,8 +1541,7 @@ static void ahci_error_intr(struct ata_p
 		u32 fbs = readl(port_mmio + PORT_FBS);
 		int pmp = fbs >> PORT_FBS_DWE_OFFSET;
 
-		if ((fbs & PORT_FBS_SDE) && (pmp < ap->nr_pmp_links) &&
-		    ata_link_online(&ap->pmp_link[pmp])) {
+		if ((fbs & PORT_FBS_SDE) && (pmp < ap->nr_pmp_links)) {
 			link = &ap->pmp_link[pmp];
 			fbs_need_dec = true;
 		}

