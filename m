Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097AbaCGHox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 02:44:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaCGHov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 02:44:51 -0500
Date: Fri, 7 Mar 2014 08:46:46 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 1/2] xhci: Cleanup xhci_setup_msi() and xhci_setup_msix()
Message-ID: <20140307074646.GA2670@dhcp-26-207.brq.redhat.com>
References: <cover.1394128952.git.agordeev@redhat.com>
 <606a52afdccf627b6273379b21daffc460b9559a.1394128952.git.agordeev@redhat.com>
 <20140306215646.GA23294@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306215646.GA23294@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make xhci_setup_msi() and xhci_setup_msix() functions
return error code in a consistent and more clear way.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/usb/host/xhci.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6fe577d..6fbba7a 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -232,9 +232,10 @@ static int xhci_setup_msi(struct xhci_hcd *xhci)
 		xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 				"disable MSI interrupt");
 		pci_disable_msi(pdev);
+		return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -307,7 +308,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
 	}
 
 	hcd->msix_enabled = 1;
-	return ret;
+	return 0;
 
 disable_msix:
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init, "disable MSI-X interrupt");
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
