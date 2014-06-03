Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497AbaFCTkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:40:14 -0400
Received: from zougloub.eu ([198.27.83.45]:34874 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbaFCTkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:40:13 -0400
Date: Tue, 3 Jun 2014 15:41:56 -0400
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: linux-pci@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: quirk dma_alias_devfn for HighPoint RocketRaid 642L
 (Marvell 9235)
Message-ID: <20140603154156.4f1b46c4@Vantage>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This vendor has similar boards based on the same Marvell 88SE9235 chipset,
but this patch was only tested with the 642L.

Tested on ASUS Sabertooth 990FX (AMD).

If you listen to the vendor support stating:

  Dear Customer,
  Sorry about that.
  Currently all our products' software package don't support IOMMU
  and we don't have plan to support that.

... you'll think you also wasted your money, but it turns out that you
just lost a few hours of your valuable time talking to their support,
because the good people from the Internet made their board work,
with the regular AHCI driver, and even with IOMMU. Nice!


Signed-off-by: Jérôme Carretero <cJ-ko@zougloub.eu>

---
 drivers/pci/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index f6a42bc..43c0ea0 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3380,6 +3380,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x91a0,
 /* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c49 */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9230,
 			 quirk_dma_func1_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TTI, 0x0642,
+			 quirk_dma_func1_alias);
 /* https://bugs.gentoo.org/show_bug.cgi?id=497630 */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_JMICRON,
 			 PCI_DEVICE_ID_JMICRON_JMB388_ESD,
-- 
2.0.0

