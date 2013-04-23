Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab3DWQgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:36:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56553 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278Ab3DWQcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:32:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Pratyush Anand <pratyush.anand@st.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Viresh Kumar <viresh.kumar@st.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 13/21] misc: mark spear13xx-pcie-gadget as broken
Date: Tue, 23 Apr 2013 18:30:45 +0200
Message-Id: <1366734653-488286-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:h0T0Fj7tiB+cBs4/cDHbCYSbGQpIQyT60iirjspSb7K
 c1N5O5l0W1tz9EVi8L/l3xT9jOC8HmmeXmbYLO4VF9gyasbOJx
 cp9ECzpobmQyn6tLNUc1hEpm6P4demHSEwdUgw83A6T4Kzbtjf
 cIiGO7EugxLS/ohyVwoqYgj4cCoYPTENMR78fRVYHWfR06oHWy
 Xh+YvmU1RcDYVR+HtOC/5HrKjw1K7XuUMaGXw+Sv6YL36YawCM
 +V4VOut4kItk0lck+e1RpB8MHajgbnQeBoOZkBqOIahZYijlxI
 1E67YjQsX1zBprkdfqW8w9gQij+27JDy259f+63Ofmu3CEqoZV
 H+3Opb3EEPYhnb3trfcDkli/b4rL9vNta5cwSF24z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver was merged in 2.6.38 but never actually compiled because
it depends on the <mach/pcie.h> header that has not made it into the
kernel. Starting with Linux-3.10, this results in "allyesconfig"
build errors, since spear13xx can now be enabled with the default
"multiplatform" platform on ARM. Let's mark it as broken for now.
If it doesn't get fixed, we can drop it completely.

Cc: Pratyush Anand <pratyush.anand@st.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Viresh Kumar <viresh.kumar@st.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/misc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index e83fdfe..c74b13b 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -398,7 +398,7 @@ config DS1682
 
 config SPEAR13XX_PCIE_GADGET
 	bool "PCIe gadget support for SPEAr13XX platform"
-	depends on ARCH_SPEAR13XX
+	depends on ARCH_SPEAR13XX && BROKEN
 	default n
 	help
 	 This option enables gadget support for PCIe controller. If
-- 
1.8.1.2

