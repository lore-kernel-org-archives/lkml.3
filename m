Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaIYQbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:31:43 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:53765 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbaIYQ2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:28:53 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v3 02/13] PM / Domains: Add DT bindings for power-on/off latencies
Date: Thu, 25 Sep 2014 18:28:29 +0200
Message-Id: <1411662520-22795-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
References: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PM domain power on/off-latencies are properties of the hardware.
In legacy code, they're specified from platform code.
On DT platforms, their values should come from DT.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Kevin Hilman <khilman@linaro.org>
---
v3:
  - No changes
v2:
  - Add Acked-by

 Documentation/devicetree/bindings/power/power_domain.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/power/power_domain.txt b/Documentation/devicetree/bindings/power/power_domain.txt
index 98c16672ab5f49e0..7bc421d84367d636 100644
--- a/Documentation/devicetree/bindings/power/power_domain.txt
+++ b/Documentation/devicetree/bindings/power/power_domain.txt
@@ -19,12 +19,18 @@ Required properties:
    providing multiple PM domains (e.g. power controllers), but can be any value
    as specified by device tree binding documentation of particular provider.
 
+Optional properties:
+ - power-on-latency: Power-on latency of the PM domain, in ns,
+ - power-off-latency: Power-off latency of the PM domain, in ns.
+
 Example:
 
 	power: power-controller@12340000 {
 		compatible = "foo,power-controller";
 		reg = <0x12340000 0x1000>;
 		#power-domain-cells = <1>;
+		power-on-latency = <250000>;
+		power-off-latency = <250000>;
 	};
 
 The node above defines a power controller that is a PM domain provider and
-- 
1.9.1

