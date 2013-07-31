Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224Ab3GaNkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:40:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46988 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759563Ab3GaNZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:50 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Youquan Song" <youquan.song@intel.com>,
        "Tejun Heo" <tj@kernel.org>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.448396355@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [52/84] ata: Fix DVD not dectected at some platform with
 Wellsburg PCH
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Youquan Song <youquan.song@intel.com>

commit eac27f04a71e1f39f196f7e520d16dcefc955d77 upstream.

There is a patch b55f84e2d527182e7c611d466cd0bb6ddce201de "ata_piix: Fix DVD
 not dectected at some Haswell platforms" to fix an issue of DVD not
recognized on Haswell Desktop platform with Lynx Point.
Recently, it is also found the same issue at some platformas with Wellsburg PCH.

So deliver a similar patch to fix it by disables 32bit PIO in IDE mode.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ata_piix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -352,7 +352,7 @@ static const struct pci_device_id piix_p
 	/* SATA Controller IDE (Wellsburg) */
 	{ 0x8086, 0x8d00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (Wellsburg) */
-	{ 0x8086, 0x8d08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ 0x8086, 0x8d08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_snb },
 	/* SATA Controller IDE (Wellsburg) */
 	{ 0x8086, 0x8d60, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (Wellsburg) */

