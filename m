Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbaGDWmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:42:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031182AbaGDWVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:21:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3.10 06/46] PCI: Add new ID for Intel GPU "spurious interrupt" quirk
Date: Fri,  4 Jul 2014 15:19:10 -0700
Message-Id: <20140704221602.562787310@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221602.280733370@linuxfoundation.org>
References: <20140704221602.280733370@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Jarosch <thomas.jarosch@intra2net.com>

commit 7c82126a94e69bbbac586f0249e7ef11e681246c upstream.

After a CPU upgrade while keeping the same mainboard, we faced "spurious
interrupt" problems again.

It turned out that the new CPU also featured a new GPU with a different PCI
ID.

Add this PCI ID to the quirk table.  Probably all other Intel GPU PCI IDs
are affected, too, but I don't want to add them without a test system.

See f67fd55fa96f ("PCI: Add quirk for still enabled interrupts on Intel
Sandy Bridge GPUs") for some history.

[bhelgaas: add f67fd55fa96f reference, stable tag]
Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2930,6 +2930,7 @@ static void disable_igfx_irq(struct pci_
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0102, disable_igfx_irq);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x010a, disable_igfx_irq);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0152, disable_igfx_irq);
 
 /*
  * Some devices may pass our check in pci_intx_mask_supported if


