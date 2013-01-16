Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab3APQB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:01:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35982 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721Ab3APQBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:01:55 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 070/222] libata: set dma_mode to 0xff in reset
Date: Wed, 16 Jan 2013 13:54:30 -0200
Message-Id: <1358351822-7675-71-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@intel.com>

commit 5416912af75de9cba5d1c75b99a7888b0bbbd2fb upstream.

ata_device->dma_mode's initial value is zero, which is not a valid dma
mode, but ata_dma_enabled will return true for this value. This patch
sets dma_mode to 0xff in reset function, so that ata_dma_enabled will
not return true for this case, or it will cause problem for pata_acpi.

The corrsponding bugzilla page is at:
https://bugzilla.kernel.org/show_bug.cgi?id=49151

Reported-by: Phillip Wood <phillip.wood@dunelm.org.uk>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Szymon Janc <szymon@janc.net.pl>
Tested-by: Dutra Julio <dutra.julio@gmail.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/ata/libata-core.c |    1 +
 drivers/ata/libata-eh.c   |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 71e8385..96f0847 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2536,6 +2536,7 @@ int ata_bus_probe(struct ata_port *ap)
 		 * bus as we may be talking too fast.
 		 */
 		dev->pio_mode = XFER_PIO_0;
+		dev->dma_mode = 0xff;
 
 		/* If the controller has a pio mode setup function
 		 * then use it to set the chipset to rights. Don't
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 6d53cf9..430a248 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2618,6 +2618,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		 * bus as we may be talking too fast.
 		 */
 		dev->pio_mode = XFER_PIO_0;
+		dev->dma_mode = 0xff;
 
 		/* If the controller has a pio mode setup function
 		 * then use it to set the chipset to rights. Don't
-- 
1.7.9.5

