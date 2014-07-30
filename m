Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaG3BuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:50:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbaG3BuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:50:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Romain Degez <romain.degez@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.15 13/37] ahci: add support for the Promise FastTrak TX8660 SATA HBA (ahci mode)
Date: Tue, 29 Jul 2014 18:48:49 -0700
Message-Id: <20140730014828.306050597@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014827.565626091@linuxfoundation.org>
References: <20140730014827.565626091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Romain Degez <romain.degez@gmail.com>

commit b32bfc06aefab61acc872dec3222624e6cd867ed upstream.

Add support of the Promise FastTrak TX8660 SATA HBA in ahci mode by
registering the board in the ahci_pci_tbl[].

Note: this HBA also provide a hardware RAID mode when activated in
BIOS but specific drivers from the manufacturer are required in this
case.

Signed-off-by: Romain Degez <romain.degez@gmail.com>
Tested-by: Romain Degez <romain.degez@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -456,6 +456,7 @@ static const struct pci_device_id ahci_p
 
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
+	{ PCI_VDEVICE(PROMISE, 0x3781), board_ahci },   /* FastTrak TX8660 ahci-mode */
 
 	/* Asmedia */
 	{ PCI_VDEVICE(ASMEDIA, 0x0601), board_ahci },	/* ASM1060 */


