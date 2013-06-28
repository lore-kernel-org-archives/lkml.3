Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751047Ab3F1EMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 00:12:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41663 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3F1EMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 00:12:00 -0400
From: Lokesh Vutla <lokeshvutla@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <shawn.guo@linaro.org>, <olof@lixom.net>,
        <arnd@arndb.de>, <benoit.cousson@linaro.org>, <nm@ti.com>,
        <rnayak@ti.com>, <gregkh@linuxfoundation.org>, <lokeshvutla@ti.com>,
        <paul@pwsan.com>, <khilman@linaro.org>, <tony@atomide.com>
Subject: [PATCH] ARM: dts: remove previously generated .dtb files on clean
Date: Fri, 28 Jun 2013 09:41:02 +0530
Message-ID: <1372392662-6833-1-git-send-email-lokeshvutla@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*.dtb used to be generated in the *arch/arm/boot* directory
which is different from where it is generated now.
Current rules delete the previously generated files only for
*make dtbs*.
Let distclean delete all the generated dtb files.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index f0895c5..d293167 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -219,4 +219,4 @@ endif
 dtbs: $(addprefix $(obj)/, $(dtb-y))
 	$(Q)rm -f $(obj)/../*.dtb
 
-clean-files := *.dtb
+clean-files := *.dtb ../*.dtb
-- 
1.7.9.5

