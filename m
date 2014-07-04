Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457AbaGDWQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:16:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760377AbaGDWP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:15:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        David Airlie <airlied@redhat.com>
Subject: [PATCH 3.15 09/66] PCI: Fix incorrect vgaarb conditional in WARN_ON()
Date: Fri,  4 Jul 2014 15:14:08 -0700
Message-Id: <20140704221423.252762913@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 67ebd8140dc8923c65451fa0f6a8eee003c4dcd3 upstream.

3448a19da479 "vgaarb: use bridges to control VGA routing where possible"
added the "flags & PCI_VGA_STATE_CHANGE_DECODES" condition to an existing
WARN_ON(), but used bitwise AND (&) instead of logical AND (&&), so the
condition is never true.  Replace with logical AND.

Found by Coverity (CID 142811).

Fixes: 3448a19da479 "vgaarb: use bridges to control VGA routing where possible"
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: David Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4126,7 +4126,7 @@ int pci_set_vga_state(struct pci_dev *de
 	u16 cmd;
 	int rc;
 
-	WARN_ON((flags & PCI_VGA_STATE_CHANGE_DECODES) & (command_bits & ~(PCI_COMMAND_IO|PCI_COMMAND_MEMORY)));
+	WARN_ON((flags & PCI_VGA_STATE_CHANGE_DECODES) && (command_bits & ~(PCI_COMMAND_IO|PCI_COMMAND_MEMORY)));
 
 	/* ARCH specific VGA enables */
 	rc = pci_set_vga_state_arch(dev, decode, command_bits, flags);


