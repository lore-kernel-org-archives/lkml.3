Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbaIJTpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:45:31 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36235 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbaIJTpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:45:24 -0400
Date: Wed, 10 Sep 2014 20:45:16 +0100
From: "Tobenna P. Igwe" <ptigwe@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Navin Patidar <navin.patidar@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [PATCH] staging:rtl8188eu: Fix sparse warning cast to restricted
 __le16
Message-ID: <20140910194510.GA2333@Tobenna-Peter-Igwes-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings:

  CHECK   drivers/staging/rtl8188eu/hal/fw.c
drivers/staging/rtl8188eu/hal/fw.c:219:13: warning: cast to restricted
__le16
drivers/staging/rtl8188eu/hal/fw.c:219:13: warning: cast to restricted
__le16
drivers/staging/rtl8188eu/hal/fw.c:219:13: warning: cast to restricted
__le16
drivers/staging/rtl8188eu/hal/fw.c:219:13: warning: cast to restricted
__le16

by changing the signature from 'u16' to '__le16'.

Signed-off-by: Tobenna P. Igwe <ptigwe@gmail.com>
---
 drivers/staging/rtl8188eu/include/fw.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/include/fw.h b/drivers/staging/rtl8188eu/include/fw.h
index d5faaff..7884d8f 100644
--- a/drivers/staging/rtl8188eu/include/fw.h
+++ b/drivers/staging/rtl8188eu/include/fw.h
@@ -36,7 +36,7 @@
 #define FW_8192C_POLLING_DELAY		5
 
 struct rtl92c_firmware_header {
-	u16 signature;
+	__le16 signature;
 	u8 category;
 	u8 function;
 	u16 version;
-- 
1.7.10.4

