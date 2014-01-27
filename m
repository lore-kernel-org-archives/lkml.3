Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaA0KUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:20:51 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:11145
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753735AbaA0KUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:20:46 -0500
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h2148h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h2189h1d1ah1cabh1d2ah21bch1fc6hzz1de098h8275bh1de097hz31h87h2a8h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h129fi1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, Steven Miao <realmz6@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        <adi-buildroot-devel@lists.sourceforge.net>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 1/3] pinctrl: Move pint PM storage structure out of blackfin architecture.
Date: Mon, 27 Jan 2014 18:23:54 +0800
Message-ID: <1390818236-13531-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.8.2.3
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

It is better to keep this structure in the pinctrl-adi2 driver.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 arch/blackfin/include/asm/irq.h |  9 ---------
 drivers/pinctrl/pinctrl-adi2.c  | 15 ++++++++++++++-
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/blackfin/include/asm/irq.h b/arch/blackfin/include/asm/irq.h
index 2fd04f1..89de539 100644
--- a/arch/blackfin/include/asm/irq.h
+++ b/arch/blackfin/include/asm/irq.h
@@ -20,15 +20,6 @@
 /* SYS_IRQS and NR_IRQS are defined in <mach-bf5xx/irq.h> */
 #include <mach/irq.h>
 
-/*
- * pm save bfin pint registers
- */
-struct adi_pm_pint_save {
-	u32 assign;
-	u32 edge_set;
-	u32 invert_set;
-};
-
 #if ANOMALY_05000244 && defined(CONFIG_BFIN_ICACHE)
 # define NOP_PAD_ANOMALY_05000244 "nop; nop;"
 #else
diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
index 7a39562..e8120fa 100644
--- a/drivers/pinctrl/pinctrl-adi2.c
+++ b/drivers/pinctrl/pinctrl-adi2.c
@@ -89,6 +89,19 @@ struct gpio_port_saved {
 	u32 mux;
 };
 
+/*
+ * struct gpio_pint_saved - PINT registers saved in PM operations
+ *
+ * @assign: ASSIGN register
+ * @edge_set: EDGE_SET register
+ * @invert_set: INVERT_SET register
+ */
+struct gpio_pint_saved {
+	u32 assign;
+	u32 edge_set;
+	u32 invert_set;
+};
+
 /**
  * struct gpio_pint - Pin interrupt controller device. Multiple ADI GPIO
  * banks can be mapped into one Pin interrupt controller.
@@ -114,7 +127,7 @@ struct gpio_pint {
 	int irq;
 	struct irq_domain *domain[2];
 	struct gpio_pint_regs *regs;
-	struct adi_pm_pint_save saved_data;
+	struct gpio_pint_saved saved_data;
 	int map_count;
 	spinlock_t lock;
 
-- 
1.8.2.3


