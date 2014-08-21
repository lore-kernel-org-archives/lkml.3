Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaHUJWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 05:22:15 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56721 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbaHUJWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 05:22:11 -0400
From: Zhu Yanjun <zyjzyj2000@gmail.com>
X-Google-Original-From: Zhu Yanjun <Yanjun.Zhu@windriver.com>
To: linux-kernel@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        zyjzyj2000@gmail.com
Cc: Zhu Yanjun <Yanjun.Zhu@windriver.com>, Frank Li <Frank.Li@freescale.com>
Subject: [PATCH 1/1] net:fec: buffer descriptor member variable order in IMX6
Date: Thu, 21 Aug 2014 17:21:55 +0800
Message-Id: <1408612915-8657-2-git-send-email-Yanjun.Zhu@windriver.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408612915-8657-1-git-send-email-Yanjun.Zhu@windriver.com>
References: <1408612915-8657-1-git-send-email-Yanjun.Zhu@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Reference Manual, freescale IMX6 is little endian mode. Therefore
the first structure field is length, the second is status.

CC: David Miller <davem@davemloft.net>
CC: Frank Li <Frank.Li@freescale.com>
Signed-off-by: Zhu Yanjun <Yanjun.Zhu@windriver.com>
---
 drivers/net/ethernet/freescale/fec.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 671d080..96a5f8a 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -147,7 +147,8 @@
 /*
  *	Define the buffer descriptor structure.
  */
-#if defined(CONFIG_ARCH_MXC) || defined(CONFIG_SOC_IMX28)
+#if defined(CONFIG_ARCH_MXC) || defined(CONFIG_SOC_IMX28) || \
+			defined(CONFIG_ARCH_MX6)
 struct bufdesc {
 	unsigned short cbd_datlen;	/* Data length */
 	unsigned short cbd_sc;	/* Control and status info */
-- 
1.9.1

