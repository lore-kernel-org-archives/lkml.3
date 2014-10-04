Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaJDJzK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 05:55:10 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56814 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaJDJzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 05:55:08 -0400
Message-ID: <542FC556.6060306@gmail.com>
Date: Sat, 04 Oct 2014 18:00:54 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: wg@grandegger.com, mkl@pengutronix.de, fengguang.wu@intel.com,
        b29396@freescale.com, varkabhadram@gmail.com
CC: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net/can/m_can/Kconfig: Let CAN_M_CAN depend on HAS_IOMEM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CAN_M_CAN needs HAS_IOMEM, so depend on it, the related error (with
allmodconfig under um):

    MODPOST 1205 modules
  ERROR: "devm_ioremap" [drivers/net/can/m_can/m_can.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/net/can/m_can/m_can.ko] undefined!

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/net/can/m_can/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/m_can/Kconfig b/drivers/net/can/m_can/Kconfig
index fca5482..14c9fcf 100644
--- a/drivers/net/can/m_can/Kconfig
+++ b/drivers/net/can/m_can/Kconfig
@@ -1,4 +1,5 @@
 config CAN_M_CAN
 	tristate "Bosch M_CAN devices"
+	depends on HAS_IOMEM
 	---help---
 	  Say Y here if you want to support for Bosch M_CAN controller.
-- 
1.9.3
