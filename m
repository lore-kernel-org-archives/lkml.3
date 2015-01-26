Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbbAZKpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:45:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39869 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbbAZKpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:45:30 -0500
Date: Mon, 26 Jan 2015 02:44:53 -0800
From: tip-bot for Baruch Siach <tipbot@zytor.com>
Message-ID: <tip-f848526f3768a80cb3fbcf503306e2c29a80a83c@git.kernel.org>
Cc: hpa@zytor.com, jason@lakedaemon.net, linux-kernel@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com, arnd@arndb.de, baruch@tkos.co.il,
        mingo@kernel.org, tglx@linutronix.de, mark.rutland@arm.com
Reply-To: sergei.shtylyov@cogentembedded.com, arnd@arndb.de, hpa@zytor.com,
        jason@lakedaemon.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, mark.rutland@arm.com, baruch@tkos.co.il
In-Reply-To: <505a65c8861e5210d94227bc0eec89cab0593fca.1421317616.git.baruch@tkos.co.il>
References: <505a65c8861e5210d94227bc0eec89cab0593fca.1421317616.git.baruch@tkos.co.il>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: Devicetree:
  document Conexant Digicolor irq binding
Git-Commit-ID: f848526f3768a80cb3fbcf503306e2c29a80a83c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f848526f3768a80cb3fbcf503306e2c29a80a83c
Gitweb:     http://git.kernel.org/tip/f848526f3768a80cb3fbcf503306e2c29a80a83c
Author:     Baruch Siach <baruch@tkos.co.il>
AuthorDate: Thu, 15 Jan 2015 12:33:59 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 26 Jan 2015 11:38:23 +0100

irqchip: Devicetree: document Conexant Digicolor irq binding

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Link: http://lkml.kernel.org/r/505a65c8861e5210d94227bc0eec89cab0593fca.1421317616.git.baruch@tkos.co.il
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 .../bindings/interrupt-controller/digicolor-ic.txt  | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt b/Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt
new file mode 100644
index 0000000..42d41ec
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt
@@ -0,0 +1,21 @@
+Conexant Digicolor Interrupt Controller
+
+Required properties:
+
+- compatible : should be "cnxt,cx92755-ic"
+- reg : Specifies base physical address and size of the interrupt controller
+  registers (IC) area
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Specifies the number of cells needed to encode an
+  interrupt source. The value shall be 1.
+- syscon: A phandle to the syscon node describing UC registers
+
+Example:
+
+	intc: interrupt-controller@f0000040 {
+		compatible = "cnxt,cx92755-ic";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		reg = <0xf0000040 0x40>;
+		syscon = <&uc_regs>;
+	};
