Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab3J2MUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 08:20:39 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12618 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab3J2MUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:20:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 29 Oct 2013 05:15:37 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lee.jones@linaro.org>, <sameo@linux.intel.com>, <mturquette@linaro.org>,
        <dwmw2@infradead.org>, <anton@enomsg.org>
CC: <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <rob.herring@calxeda.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/4] mfd: as3722: add clock driver as mfd-sub device for the ams AS3722
Date: Tue, 29 Oct 2013 17:50:02 +0530
Message-ID: <1383049205-29620-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1383049205-29620-1-git-send-email-ldewangan@nvidia.com>
References: <1383049205-29620-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device ams AS3722 supports the one 32KHz clock output. The clock control
support is provided through clock driver.

Add clock driver as mfd sub device to probe the clock driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 Documentation/devicetree/bindings/mfd/as3722.txt |    9 +++++++++
 drivers/mfd/as3722.c                             |    3 +++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/as3722.txt b/Documentation/devicetree/bindings/mfd/as3722.txt
index fc2191e..e782f39 100644
--- a/Documentation/devicetree/bindings/mfd/as3722.txt
+++ b/Documentation/devicetree/bindings/mfd/as3722.txt
@@ -112,6 +112,15 @@ Following are properties of regulator subnode.
 		ams,enable-tracking: Enable tracking with SD1, only supported
 			by LDO3.
 
+Clock:
+======
+AS3722 supports one 32KHz clock to output from device. The clock control is
+provided through the clock driver.
+This binding uses the common clock binding ./clock-bindings.txt.
+The device node should have the optional properties to support the clock:
+#clock-cells: from common clock binding; shall be set to 1. The clock id for
+	single clock output is 0.
+
 Example:
 --------
 #include <dt-bindings/mfd/as3722.h>
diff --git a/drivers/mfd/as3722.c b/drivers/mfd/as3722.c
index f161f2e..1d3415c 100644
--- a/drivers/mfd/as3722.c
+++ b/drivers/mfd/as3722.c
@@ -72,6 +72,9 @@ static struct mfd_cell as3722_devs[] = {
 		.resources = as3722_adc_resource,
 	},
 	{
+		.name = "as3722-clk",
+	},
+	{
 		.name = "as3722-power-off",
 	},
 };
-- 
1.7.1.1

