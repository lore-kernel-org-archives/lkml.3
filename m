Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab3EQVrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:47:33 -0400
Received: from mout.gmx.net ([212.227.17.21]:56061 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167Ab3EQVrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:47:03 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/wHoogrTXwsknaf5RvDy/E8n776i7XwU8zH6dmbw
	Ziio8zoEJS9I7R
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Huewe <peterhuewe@gmx.de>, Cho Yu-Chen <acho@suse.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging/btmtk_usb: Mark local functions as static
Date: Fri, 17 May 2013 23:51:58 +0200
Message-Id: <1368827518-13364-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1368827518-13364-1-git-send-email-peterhuewe@gmx.de>
References: <1368827518-13364-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse complains about some local functions not being static:
drivers/staging/btmtk_usb/btmtk_usb.c:50:6:
warning: symbol 'hex_dump' was not declared. Should it be static?
drivers/staging/btmtk_usb/btmtk_usb.c:227:5:
warning: symbol 'checksume16' was not declared. Should it be static?

-> add the static keyword

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/btmtk_usb/btmtk_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/btmtk_usb/btmtk_usb.c b/drivers/staging/btmtk_usb/btmtk_usb.c
index 772c49e..a7539df 100644
--- a/drivers/staging/btmtk_usb/btmtk_usb.c
+++ b/drivers/staging/btmtk_usb/btmtk_usb.c
@@ -47,7 +47,7 @@ static struct usb_driver btmtk_usb_driver;
 static int btmtk_usb_load_rom_patch(struct btmtk_usb_data *);
 static int btmtk_usb_load_fw(struct btmtk_usb_data *);
 
-void hex_dump(char *str, u8 *src_buf, u32 src_buf_len)
+static void hex_dump(char *str, u8 *src_buf, u32 src_buf_len)
 {
 	unsigned char *pt;
 	int x;
@@ -224,7 +224,7 @@ static void btmtk_usb_cap_init(struct btmtk_usb_data *data)
 	}
 }
 
-u16 checksume16(u8 *pData, int len)
+static u16 checksume16(u8 *pData, int len)
 {
 	int sum = 0;
 
-- 
1.8.1.5

