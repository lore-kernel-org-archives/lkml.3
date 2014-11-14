Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161070AbaKNNT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:19:28 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:52831 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161043AbaKNNT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:19:26 -0500
X-Greylist: delayed 1550 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Nov 2014 08:19:25 EST
X-SENDER-IP: [213.113.165.61]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYTAIT6ZVTVcaU9PGdsb2JhbABbgw0BAYEtgjZQhDe2DY8th12BIRcBAQEBAQEFAQEBATg7hCwPASMTAQ8YEQwCJgIvDAoaARKIRQG6SJZBAQsgGIEVj3WCfoFUBaAAhmOKWYgHPDCCSwEBAQ
X-IPAS-Result: AuYTAIT6ZVTVcaU9PGdsb2JhbABbgw0BAYEtgjZQhDe2DY8th12BIRcBAQEBAQEFAQEBATg7hCwPASMTAQ8YEQwCJgIvDAoaARKIRQG6SJZBAQsgGIEVj3WCfoFUBaAAhmOKWYgHPDCCSwEBAQ
X-IronPort-AV: E=Sophos;i="5.07,385,1413237600"; 
   d="scan'208";a="816689530"
From: Henrik Rydberg <rydberg@euromail.se>
To: Peter Jones <pjones@redhat.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Subject: [PATCH] x86, ia64: Do not lose track of the EFI default VGA device
Date: Fri, 14 Nov 2014 13:53:30 +0100
Message-Id: <1415969610-1469-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 20cde694027e ("x86, ia64: Move EFI_FB
vga_default_device() initialization to pci_vga_fixup()") in the 3.17
merge window, the EFI framebuffer depends on the VGA arbitration
layer. However, the configuration does not reflect this, which leads
to a hard-to-find bug when FB_EFI is configured without VGA_ARB. Add a
select clause to remedy this.

Cc: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Peter,

I stumbled upon this bug from the 3.17 merge window when updating to
Linus's 3.18 git head yesterday. The patch has been tested on two
different EFI machines; one that needs the patch and one that does not.

Thanks,
Henrik

 drivers/video/fbdev/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index c7bf606..81b21bc 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -761,6 +761,7 @@ config FB_EFI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select VGA_ARB
 	help
 	  This is the EFI frame buffer device driver. If the firmware on
 	  your platform is EFI 1.10 or UEFI 2.0, select Y to add support for
-- 
2.1.3

