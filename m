Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063Ab3B0BEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:04:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760223Ab3BZX5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 071/150] PCI: Fix PCI Express Capability accessors for PCI_EXP_FLAGS
Date: Tue, 26 Feb 2013 15:55:28 -0800
Message-Id: <20130226235531.567452473@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 969daa349f4821a02936af7202b51a9affc7b6da upstream.

PCI_EXP_FLAGS_TYPE is a mask, not an offset.  Fix it.

Previously, pcie_capability_read_word(..., PCI_EXP_FLAGS, ...) would
fail.

[bhelgaas:  tweak changelog]
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/access.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -515,7 +515,7 @@ static bool pcie_capability_reg_implemen
 		return false;
 
 	switch (pos) {
-	case PCI_EXP_FLAGS_TYPE:
+	case PCI_EXP_FLAGS:
 		return true;
 	case PCI_EXP_DEVCAP:
 	case PCI_EXP_DEVCTL:


