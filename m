Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762217Ab3DBTfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:35:11 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63987 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762171Ab3DBTfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:35:09 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Tue, 02 Apr 2013 14:35:06 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        David Daney <david.daney@cavium.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 1/5] of_net.h: Provide empty functions if OF_NET is not configured
Date: Tue,  2 Apr 2013 12:35:07 -0700
Message-Id: <1364931311-30603-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1364931311-30603-1-git-send-email-linux@roeck-us.net>
References: <1364931311-30603-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_mac_address() and of_get_phy_mode() are only provided if OF_NET
is configured. While most callers check for the define, not all do, and those
who do require #ifdef around the code. For those who don't, the missing check
can result in errors such as

arch/powerpc/sysdev/tsi108_dev.c:107:3: error: implicit declaration of
	function 'of_get_mac_address' [-Werror=implicit-function-declaration]
arch/powerpc/sysdev/mv64x60_dev.c:253:2: error: implicit declaration of
	function 'of_get_mac_address' [-Werror=implicit-function-declaration]

Provide empty functions if OF_NET is not configured.
This is safe because all callers do check the return values.

Cc: David Daney <david.daney@cavium.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Rob Herring <rob.herring@calxeda.com>
---
 include/linux/of_net.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/of_net.h b/include/linux/of_net.h
index f474641..61bf53b 100644
--- a/include/linux/of_net.h
+++ b/include/linux/of_net.h
@@ -11,6 +11,16 @@
 #include <linux/of.h>
 extern const int of_get_phy_mode(struct device_node *np);
 extern const void *of_get_mac_address(struct device_node *np);
+#else
+static inline const int of_get_phy_mode(struct device_node *np)
+{
+	return -ENODEV;
+}
+
+static inline const void *of_get_mac_address(struct device_node *np)
+{
+	return NULL;
+}
 #endif
 
 #endif /* __LINUX_OF_NET_H */
-- 
1.7.9.7

