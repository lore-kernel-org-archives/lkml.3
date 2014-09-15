Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaIOEpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 00:45:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaIOEpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 00:45:15 -0400
From: Juergen Gross <jgross@suse.com>
To: jim.epost@gmail.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH] xen: make pvscsi frontend dependant on xenbus frontend
Date: Mon, 15 Sep 2014 06:45:01 +0200
Message-Id: <1410756301-23340-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pvscsi frontend driver requires the xenbus frontend driver. Reflect
this in Kconfig.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/scsi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9130df1..ff62dc1 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -579,6 +579,7 @@ config VMWARE_PVSCSI
 config XEN_SCSI_FRONTEND
 	tristate "XEN SCSI frontend driver"
 	depends on SCSI && XEN
+	select XEN_XENBUS_FRONTEND
 	help
 	  The XEN SCSI frontend driver allows the kernel to access SCSI Devices
 	  within another guest OS (usually Dom0).
-- 
1.8.4.5

