Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaB1XTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 18:19:36 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36042 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbaB1XTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 18:19:33 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>, Paul Walmsley <paul@pwsan.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Sandeep Nair <sandeep_n@ti.com>
Subject: [PATCH 1/3] soc: Introduce drivers/soc place-holder for SOC specific drivers
Date: Fri, 28 Feb 2014 18:18:38 -0500
Message-ID: <1393629520-12713-2-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393629520-12713-1-git-send-email-santosh.shilimkar@ti.com>
References: <1393629520-12713-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on earlier thread "https://lkml.org/lkml/2013/10/7/662" and
further discussion at Kernel Summit'2013, it was agreed to create
'driver/soc' for drivers which are quite SOC specific.

Lets take the discussion forward with this patch.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sandeep Nair <sandeep_n@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/Kconfig     |    2 ++
 drivers/Makefile    |    4 ++++
 drivers/soc/Kconfig |    3 +++
 3 files changed, 9 insertions(+)
 create mode 100644 drivers/soc/Kconfig

diff --git a/drivers/Kconfig b/drivers/Kconfig
index b3138fb..37f955f 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -130,6 +130,8 @@ source "drivers/staging/Kconfig"
 
 source "drivers/platform/Kconfig"
 
+source "drivers/soc/Kconfig"
+
 source "drivers/clk/Kconfig"
 
 source "drivers/hwspinlock/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 8e3b8b0..0d8e2a4 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -132,6 +132,10 @@ obj-$(CONFIG_VHOST_RING)	+= vhost/
 obj-$(CONFIG_VLYNQ)		+= vlynq/
 obj-$(CONFIG_STAGING)		+= staging/
 obj-y				+= platform/
+
+# SOC specific drivers
+obj-y				+= soc/
+
 #common clk code
 obj-y				+= clk/
 
diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
new file mode 100644
index 0000000..2f9d7d0
--- /dev/null
+++ b/drivers/soc/Kconfig
@@ -0,0 +1,3 @@
+menu "SOC specific Drivers"
+
+endmenu
-- 
1.7.9.5

