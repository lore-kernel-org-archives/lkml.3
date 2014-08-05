Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbaHES3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:29:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147AbaHESOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.14 30/39] pinctrl: dra: dt-bindings: Fix pull enable/disable
Date: Tue,  5 Aug 2014 11:14:07 -0700
Message-Id: <20140805181336.954078546@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181336.030349158@linuxfoundation.org>
References: <20140805181336.030349158@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

commit 23d9cec07c589276561c13b180577c0b87930140 upstream.

The DRA74/72 control module pins have a weak pull up and pull down.
This is configured by bit offset 17. if BIT(17) is 1, a pull up is
selected, else a pull down is selected.

However, this pull resisstor is applied based on BIT(16) -
PULLUDENABLE - if BIT(18) is *0*, then pull as defined in BIT(17) is
applied, else no weak pulls are applied. We defined this in reverse.

Reference: Table 18-5 (Description of the pad configuration register
bits) in Technical Reference Manual Revision (DRA74x revision Q:
SPRUHI2Q Revised June 2014 and DRA72x revision F: SPRUHP2F - Revised
June 2014)

Fixes: 6e58b8f1daaf1a ("ARM: dts: DRA7: Add the dts files for dra7 SoC and dra7-evm board")
Signed-off-by: Nishanth Menon <nm@ti.com>
Tested-by: Felipe Balbi <balbi@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/dt-bindings/pinctrl/dra.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/include/dt-bindings/pinctrl/dra.h
+++ b/include/dt-bindings/pinctrl/dra.h
@@ -30,7 +30,8 @@
 #define MUX_MODE14	0xe
 #define MUX_MODE15	0xf
 
-#define PULL_ENA		(1 << 16)
+#define PULL_ENA		(0 << 16)
+#define PULL_DIS		(1 << 16)
 #define PULL_UP			(1 << 17)
 #define INPUT_EN		(1 << 18)
 #define SLEWCONTROL		(1 << 19)
@@ -38,10 +39,10 @@
 #define WAKEUP_EVENT		(1 << 25)
 
 /* Active pin states */
-#define PIN_OUTPUT		0
+#define PIN_OUTPUT		(0 | PULL_DIS)
 #define PIN_OUTPUT_PULLUP	(PIN_OUTPUT | PULL_ENA | PULL_UP)
 #define PIN_OUTPUT_PULLDOWN	(PIN_OUTPUT | PULL_ENA)
-#define PIN_INPUT		INPUT_EN
+#define PIN_INPUT		(INPUT_EN | PULL_DIS)
 #define PIN_INPUT_SLEW		(INPUT_EN | SLEWCONTROL)
 #define PIN_INPUT_PULLUP	(PULL_ENA | INPUT_EN | PULL_UP)
 #define PIN_INPUT_PULLDOWN	(PULL_ENA | INPUT_EN)


