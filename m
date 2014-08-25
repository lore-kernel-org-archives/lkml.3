Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaHYGa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 02:30:58 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13073 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbaHYGaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 02:30:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 24 Aug 2014 23:16:45 -0700
From: Wei Ni <wni@nvidia.com>
To: <edubezval@gmail.com>, <khali@linux-fr.org>, <linux@roeck-us.net>,
        <swarren@wwwdotorg.org>
CC: <lm-sensors@lm-sensors.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v3 3/4] thermal: add more description for thermal-zones
Date: Mon, 25 Aug 2014 14:29:47 +0800
Message-ID: <1408948188-4181-4-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1408948188-4181-1-git-send-email-wni@nvidia.com>
References: <1408948188-4181-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add more description for the "polling-delay" property.
Set "trips" and "cooling maps" as optional property, because
if missing these two sub-nodes, the thermal zone device still
work properly.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 Documentation/devicetree/bindings/thermal/thermal.txt | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Documentation/devicetree/bindings/thermal/thermal.txt
index f5db6b7..e3d3ed9 100644
--- a/Documentation/devicetree/bindings/thermal/thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/thermal.txt
@@ -136,8 +136,8 @@ containing trip nodes and one sub-node containing all the zone cooling maps.
 
 Required properties:
 - polling-delay:	The maximum number of milliseconds to wait between polls
-  Type: unsigned	when checking this thermal zone.
-  Size: one cell
+  Type: unsigned	when checking this thermal zone. If this value is 0, the
+  Size: one cell	driver will not run polling queue, but just cancel it.
 
 - polling-delay-passive: The maximum number of milliseconds to wait
   Type: unsigned	between polls when performing passive cooling.
@@ -148,14 +148,16 @@ Required properties:
   phandles + sensor
   specifier
 
+Optional property:
 - trips:		A sub-node which is a container of only trip point nodes
   Type: sub-node	required to describe the thermal zone.
 
 - cooling-maps:		A sub-node which is a container of only cooling device
   Type: sub-node	map nodes, used to describe the relation between trips
-			and cooling devices.
+			and cooling devices. If missing the "trips" property,
+			This sub-node will not be parsed, because no trips can
+			be bound to cooling devices.
 
-Optional property:
 - coefficients:		An array of integers (one signed cell) containing
   Type: array		coefficients to compose a linear relation between
   Elem size: one cell	the sensors listed in the thermal-sensors property.
-- 
1.8.1.5

