Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaA3NqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:46:10 -0500
Received: from mail-ea0-f195.google.com ([209.85.215.195]:57173 "EHLO
	mail-ea0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaA3NqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:46:08 -0500
X-Greylist: delayed 83483 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jan 2014 08:46:07 EST
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Boris BREZILLON <b.brezillon.dev@gmail.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: =?UTF-8?q?=5BRFC=20PATCH=20pre-v3=2007/14=5D=20of=3A=20mtd=3A=20add=20documentation=20for=20the=20ONFI=20NAND=20timing=20mode=20property?=
Date: Thu, 30 Jan 2014 14:46:02 +0100
Message-Id: <1391089562-8385-1-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for the ONFI NAND timing mode property.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
Changes since v2:
 - fix description of the nand-timing-mode property: the mode property is
   a mask containing all supported modes, each mode is encoded as a bit
   position

 Documentation/devicetree/bindings/mtd/nand.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/mtd/nand.txt b/Documentation/devicetree/bindings/mtd/nand.txt
index 0c962296..60c7112 100644
--- a/Documentation/devicetree/bindings/mtd/nand.txt
+++ b/Documentation/devicetree/bindings/mtd/nand.txt
@@ -8,3 +8,10 @@
   E.g. : nand-ecc-level = <4 512>; /* 4 bits / 512 bytes */
 - nand-bus-width : 8 or 16 bus width if not present 8
 - nand-on-flash-bbt: boolean to enable on flash bbt option if not present false
+- onfi,nand-timing-mode: an integer encoding the supported ONFI timing modes of
+  the NAND chip. Each supported mode is represented as a bit position (i.e. :
+  mode 0 and 1 => (1 << 0) | (1 << 1) = 0x3).
+  This is only used when the chip does not support the ONFI standard.
+  The last bit set represent the closest mode fulfilling the NAND chip timings.
+  For a full description of the different timing modes see this document:
+  www.onfi.org/~/media/ONFI/specs/onfi_3_1_spec.pdf‎
-- 
1.7.9.5

