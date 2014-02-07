Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaBGNJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:09:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41671 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137AbaBGLs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maximilian Attems <maks@stro.at>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 059/233] parport: parport_pc: remove double PCI ID for NetMos
Date: Fri,  7 Feb 2014 11:44:38 +0000
Message-Id: <1391773652-25214-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit d6a484520c5572a4170fa915109ccfc0c38f5008 upstream.

In commit 85747f ("PATCH] parport: add NetMOS 9805 support") Max added
the PCI ID for NetMOS 9805 based on a Debian bug report from 2k4 which
was at the v2.4.26 time frame. The patch made into 2.6.14.
Shortly before that patch akpm merged commit 296d3c783b ("[PATCH] Support
NetMOS based PCI cards providing serial and parallel ports") which made
into v2.6.9-rc1.
Now we have two different entries for the same PCI id.
I have here the NetMos 9805 which claims to support SPP/EPP/ECP mode.
This patch takes Max's entry for titan_1284p1 (base != -1 specifies the
ioport for ECP mode) and replaces akpm's entry for netmos_9805 which
specified -1 (=none). Both share the same PCI-ID (my card has subsystem
0x1000 / 0x0020 so it should match PCI_ANY).

While here I also drop the entry for titan_1284p2 which is the same as
netmos_9815.

Cc: Maximilian Attems <maks@stro.at>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/parport/parport_pc.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 903e128..b0a0d53 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2596,8 +2596,6 @@ enum parport_pc_pci_cards {
 	syba_2p_epp,
 	syba_1p_ecp,
 	titan_010l,
-	titan_1284p1,
-	titan_1284p2,
 	avlab_1p,
 	avlab_2p,
 	oxsemi_952,
@@ -2656,8 +2654,6 @@ static struct parport_pc_pci {
 	/* syba_2p_epp AP138B */	{ 2, { { 0, 0x078 }, { 0, 0x178 }, } },
 	/* syba_1p_ecp W83787 */	{ 1, { { 0, 0x078 }, } },
 	/* titan_010l */		{ 1, { { 3, -1 }, } },
-	/* titan_1284p1 */              { 1, { { 0, 1 }, } },
-	/* titan_1284p2 */		{ 2, { { 0, 1 }, { 2, 3 }, } },
 	/* avlab_1p		*/	{ 1, { { 0, 1}, } },
 	/* avlab_2p		*/	{ 2, { { 0, 1}, { 2, 3 },} },
 	/* The Oxford Semi cards are unusual: 954 doesn't support ECP,
@@ -2673,8 +2669,8 @@ static struct parport_pc_pci {
 	/* netmos_9705 */               { 1, { { 0, -1 }, } },
 	/* netmos_9715 */               { 2, { { 0, 1 }, { 2, 3 },} },
 	/* netmos_9755 */               { 2, { { 0, 1 }, { 2, 3 },} },
-	/* netmos_9805 */               { 1, { { 0, -1 }, } },
-	/* netmos_9815 */               { 2, { { 0, -1 }, { 2, -1 }, } },
+	/* netmos_9805 */		{ 1, { { 0, 1 }, } },
+	/* netmos_9815 */		{ 2, { { 0, 1 }, { 2, 3 }, } },
 	/* netmos_9901 */               { 1, { { 0, -1 }, } },
 	/* netmos_9865 */               { 1, { { 0, -1 }, } },
 	/* quatech_sppxp100 */		{ 1, { { 0, 1 }, } },
@@ -2718,8 +2714,6 @@ static const struct pci_device_id parport_pc_pci_tbl[] = {
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, syba_1p_ecp },
 	{ PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_010L,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, titan_010l },
-	{ 0x9710, 0x9805, 0x1000, 0x0010, 0, 0, titan_1284p1 },
-	{ 0x9710, 0x9815, 0x1000, 0x0020, 0, 0, titan_1284p2 },
 	/* PCI_VENDOR_ID_AVLAB/Intek21 has another bunch of cards ...*/
 	/* AFAVLAB_TK9902 */
 	{ 0x14db, 0x2120, PCI_ANY_ID, PCI_ANY_ID, 0, 0, avlab_1p},
-- 
1.8.3.2

