Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbaJHNqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:46:06 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:52439 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625AbaJHNqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:46:00 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 3/5] regulator: dt-bindings: Add regulator-initial-mode support
Date: Wed,  8 Oct 2014 15:44:05 +0200
Message-Id: <1412775847-15213-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulators can run on different operating modes (opmodes). This allows
systems to choose the most efficient opmode for each regulator. The
regulator core defines a set of generic modes so each system can define
the opmode in these generic terms and drivers are responsible to map the
generic modes to the ones supported by each hardware according to their
data-sheet.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 Documentation/devicetree/bindings/regulator/regulator.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index ccba90b..a9d6767 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -23,6 +23,14 @@ Optional properties:
   state among following defined suspend states:
   <3>: PM_SUSPEND_MEM - Setup regulator according to regulator-state-mem
   <4>: PM_SUSPEND_MAX - Setup regulator according to regulator-state-disk
+- regulator-initial-mode: initial regulator operating mode. One of following:
+	<1>: REGULATOR_MODE_FAST    - Regulator can handle fast changes.
+	<2>: REGULATOR_MODE_NORMAL  - Normal regulator power supply mode.
+	<4>: REGULATOR_MODE_IDLE    - Regulator runs in a more efficient mode.
+	<8>: REGULATOR_MODE_STANDBY - Regulator runs in the most efficient mode.
+  modes are defined in the dt-bindings/regulator/regulator.h header and can be
+  used in device tree sources files. If no mode is defined, then the OS will not
+  manage the operating mode and the HW default values will be used instead.
 - regulator-state-mem sub-root node for Suspend-to-RAM mode
   : suspend to memory, the device goes to sleep, but all data stored in memory,
   only some external interrupt can wake the device.
-- 
2.1.0

