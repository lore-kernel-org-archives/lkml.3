Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbaCaJQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 05:16:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41650 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbaCaJQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 05:16:38 -0400
Date: Mon, 31 Mar 2014 02:16:07 -0700
From: tip-bot for Hans de Goede <tipbot@zytor.com>
Message-ID: <tip-536a44d4277709303755e6365a059f54f4aa5403@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        hdegoede@redhat.com, carlo@caione.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hdegoede@redhat.com, tglx@linutronix.de, carlo@caione.org
In-Reply-To: <1395939759-11135-2-git-send-email-carlo@caione.org>
References: <1395939759-11135-2-git-send-email-carlo@caione.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] ARM: sun7i/sun6i: dts:
  Fix IRQ number for sun6i NMI controller
Git-Commit-ID: 536a44d4277709303755e6365a059f54f4aa5403
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

Commit-ID:  536a44d4277709303755e6365a059f54f4aa5403
Gitweb:     http://git.kernel.org/tip/536a44d4277709303755e6365a059f54f4aa5403
Author:     Hans de Goede <hdegoede@redhat.com>
AuthorDate: Thu, 27 Mar 2014 18:02:38 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Mar 2014 11:12:57 +0200

ARM: sun7i/sun6i: dts: Fix IRQ number for sun6i NMI controller

The IRQ line used in sun6i-a31.dtsi for the NMI controller is wrong.
This causes a IRQ storm since the NMI controller is repeatedly fired.
This patch fixes this problem assigning the correct IRQ number to the
NMI controller.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Carlo Caione <carlo@caione.org>
Cc: maxime.ripard@free-electrons.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-sunxi@googlegroups.com
Link: http://lkml.kernel.org/r/1395939759-11135-2-git-send-email-carlo@caione.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index eea6033..fbdf88f 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -195,7 +195,7 @@
 			interrupt-controller;
 			#interrupt-cells = <2>;
 			reg = <0x01f00c0c 0x38>;
-			interrupts = <0 0 4>;
+			interrupts = <0 32 4>;
 		};
 
 		pio: pinctrl@01c20800 {
