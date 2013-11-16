Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab3KPADA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:03:00 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:48823 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab3KPACB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:02:01 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: linux-omap@vger.kernel.org
Cc: linaro-networking@linaro.org, Victor Kamensky <victor.kamensky@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC 12/23] mfd: omap-usb-tll: raw read and write endian fix
Date: Sat, 16 Nov 2013 02:01:15 +0200
Message-Id: <1384560086-11994-13-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Victor Kamensky <victor.kamensky@linaro.org>

All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
Need to use endian neutral functions to read/write h/w registers.
I.e instead of __raw_read[lw] and __raw_write[lw] functions code
need to use read[lw]_relaxed and write[lw]_relaxed functions.
If the first simply reads/writes register, the second will byteswap
it if host operates in BE mode.

Changes are trivial sed like replacement of __raw_xxx functions
with xxx_relaxed variant.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
 drivers/mfd/omap-usb-tll.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index e59ac4c..15bcd93 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -121,22 +121,22 @@ static DEFINE_SPINLOCK(tll_lock);	/* serialize access to tll_dev */
 
 static inline void usbtll_write(void __iomem *base, u32 reg, u32 val)
 {
-	__raw_writel(val, base + reg);
+	writel_relaxed(val, base + reg);
 }
 
 static inline u32 usbtll_read(void __iomem *base, u32 reg)
 {
-	return __raw_readl(base + reg);
+	return readl_relaxed(base + reg);
 }
 
 static inline void usbtll_writeb(void __iomem *base, u8 reg, u8 val)
 {
-	__raw_writeb(val, base + reg);
+	writeb_relaxed(val, base + reg);
 }
 
 static inline u8 usbtll_readb(void __iomem *base, u8 reg)
 {
-	return __raw_readb(base + reg);
+	return readb_relaxed(base + reg);
 }
 
 /*-------------------------------------------------------------------------*/
-- 
1.7.9.5

