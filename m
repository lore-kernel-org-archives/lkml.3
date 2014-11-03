Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaKCOrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:47:15 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38826 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaKCOmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:42:16 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v4 01/14] regulator: Document binding for initial and suspend modes
Date: Mon,  3 Nov 2014 15:40:36 +0100
Message-Id: <1415025649-8119-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some regulators can run on different operating modes (opmodes). This
allows systems to choose the most efficient opmode for each regulator.

This patch builds on top of (291d761 regulator: Document binding for
regulator suspend state for PM state) adding a regulator-initial-mode
DT property to configure at startup the operating mode for regulators
that support changing its mode during normal operation and a property
regulator-mode to be used in the regulator-state-[mem/disk] nodes for
regulators that supports changing its operating mode when the system
enters in a suspend state.

The set of possible modes that a regulator can operate depends on the
hardware capabilities so a list of generic operating modes can't be
provided. Instead, each hardware binding should define the list of
valid operating modes for the regulators found on that device.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes in v3:
 - Rebased on top of regulator suspend voltage series

 Documentation/devicetree/bindings/regulator/regulator.txt | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 4e7ed76..3fffa3b 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -30,6 +30,20 @@ Optional properties:
 	- regulator-off-in-suspend: regulator should be off in suspend state.
 	- regulator-suspend-microvolt: regulator should be set to this voltage
 	  in suspend.
+	- regulator-mode: operating mode in the given suspend state.
+	  The set of possible operating modes depends on the capabilities of
+	  every hardware so the valid modes are documented on each regulator
+	  device tree binding document.
+	  The "regulator-mode" property only takes effect if the regulator is
+	  enabled for the given suspend state using "regulator-on-in-suspend".
+	  If the regulator has not been explicitly disabled for the given state
+	  with "regulator-off-in-suspend", then setting the operating mode
+	  will also have no effect.
+- regulator-initial-mode: initial operating mode. The set of possible operating
+  modes is the same used for the regulator-mode property and the device binding
+  documentation explains which property each regulator supports.
+If no mode is defined, then the OS will not manage the modes and the hardware
+default values will be used instead.
 
 Deprecated properties:
 - regulator-compatible: If a regulator chip contains multiple
-- 
2.1.0

