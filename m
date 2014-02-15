Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaBOCWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 21:22:31 -0500
Received: from exprod5og118.obsmtp.com ([64.18.0.160]:40838 "HELO
	exprod5og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752178AbaBOCWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 21:22:24 -0500
From: Ravi Patel <rapatel@apm.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jcm@redhat.com, patches@apm.com, Ravi Patel <rapatel@apm.com>,
        Keyur Chudgar <kchudgar@apm.com>
Subject: [PATCH V3 4/4] arm64: boot: dts: entries for APM X-Gene SoC QMTM
Date: Fri, 14 Feb 2014 18:22:02 -0800
Message-Id: <1392430922-24643-5-git-send-email-rapatel@apm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392430922-24643-1-git-send-email-rapatel@apm.com>
References: <1392430922-24643-1-git-send-email-rapatel@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds APM X-Gene SoC Queue Manager/Traffic Manager DTS entries.

Signed-off-by: Ravi Patel <rapatel@apm.com>
Signed-off-by: Keyur Chudgar <kchudgar@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index d37d736..70b2725 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -148,10 +148,15 @@
 				compatible = "apm,xgene-device-clock";
 				#clock-cells = <1>;
 				clocks = <&socplldiv2 0>;
-				clock-names = "qmlclk";
+				clock-names = "socplldiv2";
 				reg = <0x0 0x1703C000 0x0 0x1000>;
 				reg-names = "csr-reg";
 				clock-output-names = "qmlclk";
+				status = "ok";
+				csr-offset = <0x0>;
+				csr-mask = <0x3>;
+				enable-offset = <0x8>;
+				enable-mask = <0x3>;
 			};
 
 			ethclk: ethclk {
@@ -187,5 +192,16 @@
 			interrupt-parent = <&gic>;
 			interrupts = <0x0 0x4c 0x4>;
 		};
+
+		qmlite: mailbox@17030000 {
+			compatible = "apm,xgene-qmtm";
+			#mailbox-cells = <4>;
+			status = "ok";
+			reg = <0x0 0x17030000 0x0 0x10000>,
+			      <0x0 0x10000000 0x0 0x400000>;
+			interrupts = <0x0 0x40 0x4>,
+				     <0x0 0x3c 0x4>;
+			clocks = <&qmlclk 0>;
+		};
 	};
 };
-- 
1.7.9.5

