Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaLNUZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:25:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaLNUWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:22:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Dominik Mierzejewski <dominik@greysector.net>
Subject: [PATCH 3.17 25/47] ahci: disable MSI on SAMSUNG 0xa800 SSD
Date: Sun, 14 Dec 2014 12:21:00 -0800
Message-Id: <20141214201819.412154853@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
References: <20141214201818.552715149@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 2b21ef0aae65f22f5ba86b13c4588f6f0c2dbefb upstream.

Just like 0x1600 which got blacklisted by 66a7cbc303f4 ("ahci: disable
MSI instead of NCQ on Samsung pci-e SSDs on macbooks"), 0xa800 chokes
on NCQ commands if MSI is enabled.  Disable MSI.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dominik Mierzejewski <dominik@greysector.net>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=89171
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -495,6 +495,7 @@ static const struct pci_device_id ahci_p
 	 * enabled.  https://bugzilla.kernel.org/show_bug.cgi?id=60731
 	 */
 	{ PCI_VDEVICE(SAMSUNG, 0x1600), board_ahci_nomsi },
+	{ PCI_VDEVICE(SAMSUNG, 0xa800), board_ahci_nomsi },
 
 	/* Enmotus */
 	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },


