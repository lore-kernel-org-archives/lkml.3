Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945985Ab3AXV1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:27:05 -0500
Received: from mail.kernel.org ([198.145.19.201]:40692 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951Ab3AXVQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:16:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Betty Dall <betty.dall@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Shuah Khan <shuah.khan@hp.com>
Subject: [ 08/22] PCI/AER: pci_get_domain_bus_and_slot() call missing required pci_dev_put()
Date: Thu, 24 Jan 2013 13:15:29 -0800
Message-Id: <20130124211507.412528097@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211504.701368763@linuxfoundation.org>
References: <20130124211504.701368763@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Betty Dall <betty.dall@hp.com>

commit a82b6af37d20bfe6e99a4d890f1cf1d89059929f upstream.

The function aer_recover_queue() calls pci_get_domain_bus_and_slot(), which
requires that the caller decrement the reference count with pci_dev_put().
This patch adds the missing call to pci_dev_put().

Signed-off-by: Betty Dall <betty.dall@hp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pcie/aer/aerdrv_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -637,6 +637,7 @@ static void aer_recover_work_func(struct
 			continue;
 		}
 		do_recovery(pdev, entry.severity);
+		pci_dev_put(pdev);
 	}
 }
 #endif


