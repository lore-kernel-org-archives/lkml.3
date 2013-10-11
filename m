Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab3JKK05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:26:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49765 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab3JKK0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:26:55 -0400
From: Nishanth Menon <nm@ti.com>
To: Rob Landley <rob@landley.net>, Mark Brown <broonie@linaro.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kishon Vijay Abraham I <kishon@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rajendra Nayak <rnayak@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH] regulator: dts: Fix bindings description of regulator-boot-on
Date: Fri, 11 Oct 2013 05:26:47 -0500
Message-ID: <1381487207-18298-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since regulator-boot-on property maps back to constraints->boot_on,
current description of 'regulator-boot-on' property conflicts with
description of 'boot-on' in include/linux/regulator/machine.h and the
corresponding implementation in drivers/regulator/core.c.

Ensure the description is more inline with the original intent.

Cc: Rajendra Nayak <rnayak@ti.com>

Reported-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---

Ref: my confusion in http://marc.info/?t=138140228800004&r=1&w=2
Based on v3.12-rc4 tag

 .../devicetree/bindings/regulator/regulator.txt    |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 2bd8f09..d999f096 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -8,7 +8,9 @@ Optional properties:
 - regulator-min-microamp: smallest current consumers may set
 - regulator-max-microamp: largest current consumers may set
 - regulator-always-on: boolean, regulator should never be disabled
-- regulator-boot-on: bootloader/firmware enabled regulator
+- regulator-boot-on: regulator is enabled when the system is initially started.
+  If the regulator is not enabled by the hardware or bootloader then it will be
+  enabled when the constraints are applied.
 - regulator-allow-bypass: allow the regulator to go into bypass mode
 - <name>-supply: phandle to the parent supply/regulator node
 - regulator-ramp-delay: ramp delay for regulator(in uV/uS)
-- 
1.7.9.5

