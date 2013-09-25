Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab3IYBUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:20:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab3IYAQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [ 013/110] ARM: dts: add missing cpu #address-cell values
Date: Tue, 24 Sep 2013 17:14:11 -0700
Message-Id: <20130925001324.844716003@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 8b2efa896cc618e055e90c9d9600e7c8388ae3b7 upstream.

A recent series has added CPU numbers to a lot of dts files,
but unfortunately in a few cases the #address-cells
and #size-cells values are missing, which causes build warnings.
This adds the missing ones for sunxi and sama5 that I found
through build testing.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/sama5d3.dtsi   |    2 ++
 arch/arm/boot/dts/sun4i-a10.dtsi |    2 ++
 arch/arm/boot/dts/sun5i-a13.dtsi |    2 ++
 3 files changed, 6 insertions(+)

--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -35,6 +35,8 @@
 		ssc1 = &ssc1;
 	};
 	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
 		cpu@0 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a5";
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -16,6 +16,8 @@
 	interrupt-parent = <&intc>;
 
 	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
 		cpu@0 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a8";
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -17,6 +17,8 @@
 	interrupt-parent = <&intc>;
 
 	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
 		cpu@0 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a8";


