Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbaCZAEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:04:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34263 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbaCZAEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:04:13 -0400
Date: Tue, 25 Mar 2014 17:03:59 -0700
From: tip-bot for Carlo Caione <tipbot@zytor.com>
Message-ID: <tip-ae7d9d3245b7ced5c6f615cfef1250226d518436@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        carlo@caione.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, carlo@caione.org
In-Reply-To: <1395256879-8475-4-git-send-email-carlo@caione.org>
References: <1395256879-8475-4-git-send-email-carlo@caione.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] ARM: sun7i/sun6i: irqchip:
  Update the documentation
Git-Commit-ID: ae7d9d3245b7ced5c6f615cfef1250226d518436
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

Commit-ID:  ae7d9d3245b7ced5c6f615cfef1250226d518436
Gitweb:     http://git.kernel.org/tip/ae7d9d3245b7ced5c6f615cfef1250226d518436
Author:     Carlo Caione <carlo@caione.org>
AuthorDate: Wed, 19 Mar 2014 20:21:19 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Mar 2014 01:00:50 +0100

ARM: sun7i/sun6i: irqchip: Update the documentation

Add documentation for NMI irqchip.

Signed-off-by: Carlo Caione <carlo@caione.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-sunxi@googlegroups.com
Cc: mark.rutland@arm.com
Cc: hdegoede@redhat.com
Acked-by: maxime.ripard@free-electrons.com
Link: http://lkml.kernel.org/r/1395256879-8475-4-git-send-email-carlo@caione.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 .../allwinner,sun67i-sc-nmi.txt                    | 27 ++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/allwinner,sun67i-sc-nmi.txt b/Documentation/devicetree/bindings/interrupt-controller/allwinner,sun67i-sc-nmi.txt
new file mode 100644
index 0000000..d1c5cda
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/allwinner,sun67i-sc-nmi.txt
@@ -0,0 +1,27 @@
+Allwinner Sunxi NMI Controller
+==============================
+
+Required properties:
+
+- compatible : should be "allwinner,sun7i-a20-sc-nmi" or
+  "allwinner,sun6i-a31-sc-nmi"
+- reg : Specifies base physical address and size of the registers.
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Specifies the number of cells needed to encode an
+  interrupt source. The value shall be 2. The first cell is the IRQ number, the
+  second cell the trigger type as defined in interrupt.txt in this directory.
+- interrupt-parent: Specifies the parent interrupt controller.
+- interrupts: Specifies the interrupt line (NMI) which is handled by
+  the interrupt controller in the parent controller's notation. This value
+  shall be the NMI.
+
+Example:
+
+sc-nmi-intc@01c00030 {
+	compatible = "allwinner,sun7i-a20-sc-nmi";
+	interrupt-controller;
+	#interrupt-cells = <2>;
+	reg = <0x01c00030 0x0c>;
+	interrupt-parent = <&gic>;
+	interrupts = <0 0 4>;
+};
