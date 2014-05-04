Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbaEDRAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 13:00:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaEDPlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.14 013/158] ARM: dts: omap4/5: Use l3_ick for the gpmc node
Date: Sun,  4 May 2014 11:38:42 -0400
Message-Id: <20140504154031.825643909@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Vaussard <florian.vaussard@epfl.ch>

commit 7b8b6af169a069454936053631d151a50af7b69a upstream.

The GPMC clock is derived from l3_ick. The simplest solution is
to reference directly l3_ick to provide the GPMC fck in order to
get correct timings. The real management of the clock is left to
hwmod.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/omap4.dtsi |    2 ++
 arch/arm/boot/dts/omap5.dtsi |    2 ++
 2 files changed, 4 insertions(+)

--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -275,6 +275,8 @@
 			gpmc,num-waitpins = <4>;
 			ti,hwmods = "gpmc";
 			ti,no-idle-on-init;
+			clocks = <&l3_div_ck>;
+			clock-names = "fck";
 		};
 
 		uart1: serial@4806a000 {
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -302,6 +302,8 @@
 			gpmc,num-cs = <8>;
 			gpmc,num-waitpins = <4>;
 			ti,hwmods = "gpmc";
+			clocks = <&l3_iclk_div>;
+			clock-names = "fck";
 		};
 
 		i2c1: i2c@48070000 {


