Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951AbaD2RbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:31:22 -0400
Received: from mail-oa0-f74.google.com ([209.85.219.74]:61596 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933692AbaD2RbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:31:20 -0400
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: olof@lixom.net, Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: mux: Add more warnings to i2c-arb-gpio-challenge docs
Date: Tue, 29 Apr 2014 10:30:51 -0700
Message-Id: <1398792651-27115-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds some more warnings to the i2c-arb-gpio-challenge docs to
help encourage people not to use it in their designs unless they have
no choice.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 Documentation/devicetree/bindings/i2c/i2c-arb-gpio-challenge.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-arb-gpio-challenge.txt b/Documentation/devicetree/bindings/i2c/i2c-arb-gpio-challenge.txt
index 1ac8ea8..bfeabb8 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-arb-gpio-challenge.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-arb-gpio-challenge.txt
@@ -8,6 +8,12 @@ the standard I2C multi-master rules.  Using GPIOs is generally useful in
 the case where there is a device on the bus that has errata and/or bugs
 that makes standard multimaster mode not feasible.
 
+Note that this scheme works well enough but has some downsides:
+* It is nonstandard (not using standard I2C multimaster)
+* Having two masters on a bus in general makes it relatively hard to debug
+  problems (hard to tell if i2c issues were caused by one master, another, or
+  some device on the bus).
+
 
 Algorithm:
 
-- 
1.9.1.423.g4596e3a

