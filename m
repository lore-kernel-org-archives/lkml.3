Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbaEDMW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 08:22:57 -0400
Received: from mx02.posteo.de ([89.146.194.165]:55738 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752635AbaEDMW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 08:22:56 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH v2] staging: rtl8821ae: mark pci_mem_start (and _end) as __iomem
Date: Sun,  4 May 2014 14:22:19 +0200
Message-Id: <1399206139-16906-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140504002617.GA16403@kroah.com>
References: <20140504002617.GA16403@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shared addresses can be marked as such.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
I guess that's what you meant. Thanks for your feedback!

 drivers/staging/rtl8821ae/wifi.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8821ae/wifi.h b/drivers/staging/rtl8821ae/wifi.h
index 17a9d9f..d162730 100644
--- a/drivers/staging/rtl8821ae/wifi.h
+++ b/drivers/staging/rtl8821ae/wifi.h
@@ -1086,8 +1086,8 @@ struct rtl_io {
 	struct device *dev;
 
 	/*PCI MEM map */
-	unsigned long pci_mem_end;	/*shared mem end        */
-	unsigned long pci_mem_start;	/*shared mem start */
+	unsigned long __iomem pci_mem_end;	/*shared mem end   */
+	unsigned long __iomem pci_mem_start;	/*shared mem start */
 
 	/*PCI IO map */
 	unsigned long pci_base_addr;	/*device I/O address */
-- 
1.7.10.4

