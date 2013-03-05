Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab3CETUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:20:52 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:55139 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847Ab3CETUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:20:51 -0500
Message-ID: <1362511248.16460.113.camel@x61.thuisdomein>
Subject: [PATCH] remoteproc: properly fix missing CONFIG_FW_LOADER
 configurations
From: Paul Bolle <pebolle@tiscali.nl>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: stable <stable@vger.kernel.org>, linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 20:20:48 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2013 19:20:49.0611 (UTC) FILETIME=[8B9979B0:01CE19D6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix obvious typo introduced in commit
e121aefa7d9f10eee5cf26ed47129237a05d940b ("remoteproc: fix missing
CONFIG_FW_LOADER configurations").

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) The REMOTEPROC Kconfig entry has been using the useless FW_CONFIG
select statement for a few releases now. Does it really need to select
FW_LOADER?

 drivers/remoteproc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index cc1f7bf..c6d77e2 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -4,7 +4,7 @@ menu "Remoteproc drivers"
 config REMOTEPROC
 	tristate
 	depends on HAS_DMA
-	select FW_CONFIG
+	select FW_LOADER
 	select VIRTIO
 
 config OMAP_REMOTEPROC
-- 
1.7.11.7

