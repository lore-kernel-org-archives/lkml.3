Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949AbaAaVqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:46:25 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9142 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbaAaVqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:46:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 31 Jan 2014 13:45:07 -0800
From: Andrew Chew <achew@nvidia.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <abrestic@chromium.org>, <dgreid@chromium.org>, <katierh@chromium.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH v1] ARM: tegra: add nvidia,wdt-timer-id optional property
Date: Fri, 31 Jan 2014 13:46:51 -0800
Message-ID: <1391204811-6293-1-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This optional property can be used to specify which timers are to be used
for hardware watchdog timeouts (via a tegra wdt driver).

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
 Documentation/devicetree/bindings/timer/nvidia,tegra30-timer.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/timer/nvidia,tegra30-timer.txt b/Documentation/devicetree/bindings/timer/nvidia,tegra30-timer.txt
index b5082a1..e87fa70 100644
--- a/Documentation/devicetree/bindings/timer/nvidia,tegra30-timer.txt
+++ b/Documentation/devicetree/bindings/timer/nvidia,tegra30-timer.txt
@@ -13,6 +13,13 @@ Required properties:
 - clocks : Must contain one entry, for the module clock.
   See ../clocks/clock-bindings.txt for details.
 
+Optional properties:
+
+- nvidia,wdt-timer-id: A list of timer IDs to be used for watchdogs.
+    Watchdog 0 will be assigned to the first timer listed, watchdog 1 will
+    be assigned to the second timer listed, etc. up to the number of watchdogs
+    available.
+
 timer {
 	compatible = "nvidia,tegra30-timer", "nvidia,tegra20-timer";
 	reg = <0x60005000 0x400>;
@@ -23,4 +30,5 @@ timer {
 		      0 121 0x04
 		      0 122 0x04>;
 	clocks = <&tegra_car 214>;
+	nvidia,wdt-timer-id = <7 8>;
 };
-- 
1.8.1.5

