Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbaKSWWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:22:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549AbaKSUyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Nishanth Menon <nm@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.17 074/141] pinctrl: dra: dt-bindings: Fix output pull up/down
Date: Wed, 19 Nov 2014 12:51:37 -0800
Message-Id: <20141119205153.098385720@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit 73b3a6657a88ef5348a0d69c9a8107d6f01ae862 upstream.

For PIN_OUTPUT_PULLUP and PIN_OUTPUT_PULLDOWN we must not set the
PULL_DIS bit which disables the PULLs.

PULL_ENA is a 0 and using it in an OR operation is a NOP, so don't
use it in the PIN_OUTPUT_PULLUP/DOWN macros.

Fixes: 23d9cec07c58 ("pinctrl: dra: dt-bindings: Fix pull enable/disable")

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/dt-bindings/pinctrl/dra.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/dt-bindings/pinctrl/dra.h
+++ b/include/dt-bindings/pinctrl/dra.h
@@ -40,8 +40,8 @@
 
 /* Active pin states */
 #define PIN_OUTPUT		(0 | PULL_DIS)
-#define PIN_OUTPUT_PULLUP	(PIN_OUTPUT | PULL_ENA | PULL_UP)
-#define PIN_OUTPUT_PULLDOWN	(PIN_OUTPUT | PULL_ENA)
+#define PIN_OUTPUT_PULLUP	(PULL_UP)
+#define PIN_OUTPUT_PULLDOWN	(0)
 #define PIN_INPUT		(INPUT_EN | PULL_DIS)
 #define PIN_INPUT_SLEW		(INPUT_EN | SLEWCONTROL)
 #define PIN_INPUT_PULLUP	(PULL_ENA | INPUT_EN | PULL_UP)


