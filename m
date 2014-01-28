Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaA1C7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 21:59:34 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:32167
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754476AbaA1C7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 21:59:32 -0500
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h2148h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h2189h1d1ah1cabh1d2ah21bch1fc6hzz1de098h8275bh1de097hz31h87h2a8h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h129fi1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, Steven Miao <realmz6@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        <adi-buildroot-devel@lists.sourceforge.net>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 2/3 v2] pinctrl-adi2: change irq_base from usigned int to int
Date: Tue, 28 Jan 2014 11:02:42 +0800
Message-ID: <1390878162-22402-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.8.2.3
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Negative irq_base means there is no fixed Linux irq mappings are created from the platform data.
The driver calls irq_create_mapping to allocate a virtual Linux irq.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
v2-changes:
 - reword the patch description

 drivers/pinctrl/pinctrl-adi2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
index e8120fa..9fb53c9 100644
--- a/drivers/pinctrl/pinctrl-adi2.c
+++ b/drivers/pinctrl/pinctrl-adi2.c
@@ -173,7 +173,7 @@ struct adi_pinctrl {
 struct gpio_port {
 	struct list_head node;
 	void __iomem *base;
-	unsigned int irq_base;
+	int irq_base;
 	unsigned int width;
 	struct gpio_port_t *regs;
 	struct gpio_port_saved saved_data;
-- 
1.8.2.3


