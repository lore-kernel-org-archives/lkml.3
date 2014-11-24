Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaKXSfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:35:00 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33938 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbaKXSe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:34:57 -0500
From: Andreas Ruprecht <rupran@einserver.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andreas Ruprecht <rupran@einserver.de>
Subject: [PATCH 2/2] net: wireless: rtlwifi: rtl8192ee: Fix compilation of the driver
Date: Mon, 24 Nov 2014 19:34:32 +0100
Message-Id: <1416854072-14794-3-git-send-email-rupran@einserver.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416854072-14794-1-git-send-email-rupran@einserver.de>
References: <1416854072-14794-1-git-send-email-rupran@einserver.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the Makefile for this driver, the wrong Kconfig option is used
to trigger the compilation of the object file. This leads to the
driver only being included into the kernel when both CONFIG_RTL8821AE
and CONFIG_RTL8192AE are set to "y".

Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
---
 drivers/net/wireless/rtlwifi/rtl8192ee/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/Makefile b/drivers/net/wireless/rtlwifi/rtl8192ee/Makefile
index 6bd46a9..0315eed 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/Makefile
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/Makefile
@@ -11,6 +11,6 @@ rtl8192ee-objs :=		\
 		trx.o		\
 
 
-obj-$(CONFIG_RTL8821AE) += rtl8192ee.o
+obj-$(CONFIG_RTL8192EE) += rtl8192ee.o
 
 ccflags-y += -D__CHECK_ENDIAN__
-- 
1.9.1

