Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbaAIMgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:36:42 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:48195 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbaAIMfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:35:19 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, b.brezillon@overkiz.com, arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v2 12/12] at91: dt: sam9261: Added DM9000 in the device tree
Date: Thu,  9 Jan 2014 13:31:49 +0100
Message-Id: <1389270709-32662-13-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
References: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 arch/arm/boot/dts/at91sam9261ek.dts | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9261ek.dts b/arch/arm/boot/dts/at91sam9261ek.dts
index e92cb8e..a3d9d5a 100644
--- a/arch/arm/boot/dts/at91sam9261ek.dts
+++ b/arch/arm/boot/dts/at91sam9261ek.dts
@@ -76,6 +76,38 @@
 		smc: smc@ffffec00 {
 			status = "okay";
 
+			ebi_cs2@2,0 {
+				status = "okay";
+				smc,converter = "nanosec";
+				smc,ncs_read_setup = <0>;
+				smc,nrd_setup = <20>;
+				smc,ncs_write_setup = <0>;
+				smc,nwe_setup = <20>;
+				smc,ncs_read_pulse = <80>;
+				smc,nrd_pulse = <40>;
+				smc,ncs_write_pulse = <80>;
+				smc,nwe_pulse = <40>;
+				smc,read_cycle = <160>;
+				smc,write_cycle = <160>;
+				smc,tdf_cycles = <10>;
+				smc,tdf_optimized = <0>;
+				smc,page_size = <0>;
+				smc,byte_access_type = <1>;
+				smc,bus_width = <1>;
+				smc,nwait_mode = <0>;
+				smc,read_mode = <1>;
+				smc,write_mode = <1>;
+
+				ethernet@2,0 {
+					compatible = "davicom,dm9000";
+					reg = <0x0 0x2 0x4 0x2>;
+					interrupt-parent = <&pioC>;
+					interrupts = <11 IRQ_TYPE_EDGE_BOTH>;
+					local-mac-address = [00 00 de ad be ef];
+					davicom,no-eeprom;
+				};
+			};
+
 			ebi_cs3@3,0 {
 				status = "okay";
 				smc,ncs_read_setup = <0>;
-- 
1.8.5.2

