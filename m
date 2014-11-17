Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaKQNbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:31:02 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:53488 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaKQNa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:30:57 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v5 1/8] PM / Domains: Add DT bindings for power-on/off latencies
Date: Mon, 17 Nov 2014 14:30:37 +0100
Message-Id: <1416231044-1903-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416231044-1903-1-git-send-email-geert+renesas@glider.be>
References: <1416231044-1903-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PM domain power on/off-latencies are properties of the hardware.
In legacy code, they're specified from platform code.
On DT platforms, their values should come from DT.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Kevin Hilman <khilman@linaro.org>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
---
v5:
  - No changes,
v4:
  - Add Reviewed-by,
  - Replace single latency value by list of latencies,
v3:
  - No changes,
v2:
  - Add Acked-by.
---
 Documentation/devicetree/bindings/power/power_domain.txt | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/power/power_domain.txt b/Documentation/devicetree/bindings/power/power_domain.txt
index 98c16672ab5f49e0..c4a4afb2ac3b0500 100644
--- a/Documentation/devicetree/bindings/power/power_domain.txt
+++ b/Documentation/devicetree/bindings/power/power_domain.txt
@@ -19,16 +19,26 @@ Required properties:
    providing multiple PM domains (e.g. power controllers), but can be any value
    as specified by device tree binding documentation of particular provider.
 
+Optional properties:
+ - power-on-latency: List of power-on latencies (in ns), one for each PM
+   domain. If all power-on latencies are identical, the list may be shortened
+   to a single value.
+ - power-off-latency: List of power-off latencies (in ns), one for each PM
+   domain. If all power-off latencies are identical, the list may be shortened
+   to a single value.
+
 Example:
 
 	power: power-controller@12340000 {
 		compatible = "foo,power-controller";
 		reg = <0x12340000 0x1000>;
 		#power-domain-cells = <1>;
+		power-on-latency = <250000 400000 180000>;
+		power-off-latency = <250000 400000 300000>;
 	};
 
-The node above defines a power controller that is a PM domain provider and
-expects one cell as its phandle argument.
+The node above defines a power controller that is a PM domain provider for
+3 PM domains, and expects one cell as its phandle argument.
 
 ==PM domain consumers==
 
-- 
1.9.1

