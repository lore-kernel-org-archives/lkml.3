Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaJTOsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:48:43 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39905 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbaJTOsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:48:37 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 2/5] regulator: core: Add regulator mode and initial mode properties
Date: Mon, 20 Oct 2014 16:47:49 +0200
Message-Id: <1413816472-1895-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413816472-1895-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1413816472-1895-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some regulators can run on different operating modes (opmodes). This
allows systems to choose the most efficient opmode for each regulator.

This patch adds a "regulator-initial-mode" property to configure at
startup the operating mode for the regulators that support changing
its mode during normal operation and a "regulator-mode" to be used as
a property of the suspend states "regulator-state-[mem/disk]" nodes
for the regulators that supports changing its operating mode when the
system enters in a suspend state.

The set of possible modes that a regulator can operate depends on
the hardware capabilities so a list of generic operating modes can't
be provided. Instead, each hardware should define the list of valid
operating modes for the regulators found on that device.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 Documentation/devicetree/bindings/regulator/regulator.txt | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index aaad615..8b54be1 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -28,6 +28,20 @@ Optional properties:
 - regulator-state-[mem/disk] node has following common properties:
 	- regulator-on-in-suspend: regulator should be on in suspend state.
 	- regulator-off-in-suspend: regulator should be off in suspend state.
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

