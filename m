Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab3AOW17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:27:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:41290 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757013Ab3AOW1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:27:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Phillip Wood <phillip.wood@dunelm.org.uk>,
        Aaron Lu <aaron.lu@intel.com>, Szymon Janc <szymon@janc.net.pl>,
        Dutra Julio <dutra.julio@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 046/221] libata: set dma_mode to 0xff in reset
Date: Tue, 15 Jan 2013 10:49:33 -0800
Message-Id: <20130115185001.340642027@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-core.c |    1 +
 drivers/ata/libata-eh.c   |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2560,6 +2560,7 @@ int ata_bus_probe(struct ata_port *ap)
 		 * bus as we may be talking too fast.
 		 */
 		dev->pio_mode = XFER_PIO_0;
+		dev->dma_mode = 0xff;
 
 		/* If the controller has a pio mode setup function
 		 * then use it to set the chipset to rights. Don't
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2657,6 +2657,7 @@ int ata_eh_reset(struct ata_link *link,
 		 * bus as we may be talking too fast.
 		 */
 		dev->pio_mode = XFER_PIO_0;
+		dev->dma_mode = 0xff;
 
 		/* If the controller has a pio mode setup function
 		 * then use it to set the chipset to rights. Don't


