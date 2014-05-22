Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaEVVBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:01:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33051 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaEVVAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:00:19 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: "David S . Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>
Subject: [PATCH 2/5] devicetree: bindings: Properly document micrel ks8851 SPI chips
Date: Thu, 22 May 2014 14:00:10 -0700
Message-Id: <1400792413-21618-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1400792413-21618-1-git-send-email-sboyd@codeaurora.org>
References: <1400792413-21618-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ks8851 SPI ethernet wasn't documented, but we documented the
optional regulator supply for it under the mll based ethernet
chip. Furthermore, that compatible string needed another 'l'. Fix
all of this and document the newly added optional vdd-io and
reset-gpios properties.

Cc: Nishanth Menon <nm@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 Documentation/devicetree/bindings/net/micrel-ks8851.txt | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/micrel-ks8851.txt b/Documentation/devicetree/bindings/net/micrel-ks8851.txt
index d54d0cc79487..bbdf9a7359a2 100644
--- a/Documentation/devicetree/bindings/net/micrel-ks8851.txt
+++ b/Documentation/devicetree/bindings/net/micrel-ks8851.txt
@@ -1,9 +1,18 @@
-Micrel KS8851 Ethernet mac
+Micrel KS8851 Ethernet mac (MLL)
 
 Required properties:
-- compatible = "micrel,ks8851-ml" of parallel interface
+- compatible = "micrel,ks8851-mll" of parallel interface
 - reg : 2 physical address and size of registers for data and command
 - interrupts : interrupt connection
 
+Micrel KS8851 Ethernet mac (SPI)
+
+Required properties:
+- compatible = "micrel,ks8851" or the deprecated "ks8851"
+- reg : chip select number
+- interrupts : interrupt connection
+
 Optional properties:
-- vdd-supply:	supply for Ethernet mac
+- vdd-supply: analog 3.3V supply for Ethernet mac
+- vdd-io-supply: digital 1.8V IO supply for Ethernet mac
+- reset-gpios: reset_n input pin
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

