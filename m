Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaFDPAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:00:16 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:47920 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782AbaFDPAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:00:05 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH RESEND 01/12] clk: st: Update ST clock binding documentation
Date: Wed,  4 Jun 2014 16:31:49 +0200
Message-Id: <1401892320-18211-2-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401892320-18211-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1401892320-18211-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-04_03:2014-06-04,2014-06-04,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new compatibilities to support STiH407 SoC.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 .../devicetree/bindings/clock/st/st,clkgen-mux.txt   |  2 +-
 .../devicetree/bindings/clock/st/st,clkgen-pll.txt   |  5 ++++-
 .../devicetree/bindings/clock/st/st,clkgen.txt       | 20 ++++++++++++++++----
 .../devicetree/bindings/clock/st/st,quadfs.txt       |  3 +++
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen-mux.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen-mux.txt
index 943e080..2d92fc8 100644
--- a/Documentation/devicetree/bindings/clock/st/st,clkgen-mux.txt
+++ b/Documentation/devicetree/bindings/clock/st/st,clkgen-mux.txt
@@ -17,7 +17,7 @@ Required properties:
 	"st,stih416-clkgenf-vcc-sd",	"st,clkgen-mux"
 	"st,stih415-clkgen-a9-mux",	"st,clkgen-mux"
 	"st,stih416-clkgen-a9-mux",	"st,clkgen-mux"
-
+	"st,stih407-clkgen-a9-mux",	"st,clkgen-mux"
 
 - #clock-cells : from common clock binding; shall be set to 0.
 
diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen-pll.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen-pll.txt
index 81eb385..b852925 100644
--- a/Documentation/devicetree/bindings/clock/st/st,clkgen-pll.txt
+++ b/Documentation/devicetree/bindings/clock/st/st,clkgen-pll.txt
@@ -19,11 +19,14 @@ Required properties:
 	"st,stih415-plls-c32-ddr",	"st,clkgen-plls-c32"
 	"st,stih416-plls-c32-a9",	"st,clkgen-plls-c32"
 	"st,stih416-plls-c32-ddr",	"st,clkgen-plls-c32"
+	"st,stih407-plls-c32-a0",	"st,clkgen-plls-c32"
+	"st,stih407-plls-c32-a9",	"st,clkgen-plls-c32"
+	"st,stih407-plls-c32-c0_0",	"st,clkgen-plls-c32"
+	"st,stih407-plls-c32-c0_1",	"st,clkgen-plls-c32"
 
 	"st,stih415-gpu-pll-c32",	"st,clkgengpu-pll-c32"
 	"st,stih416-gpu-pll-c32",	"st,clkgengpu-pll-c32"
 
-
 - #clock-cells : From common clock binding; shall be set to 1.
 
 - clocks : From common clock binding
diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
index 49ec5ae..55506c2 100644
--- a/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
+++ b/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
@@ -24,16 +24,28 @@ address is common of all subnode.
 		quadfs_node {
 			...
 		};
+
+		mux_node {
+			...
+		};
+
+		vcc_node {
+			...
+		};
 		...
 	};
 
 This binding uses the common clock binding[1].
-Each subnode should use the binding discribe in [2]..[4]
+Each subnode should use the binding discribe in [2]..[7]
 
 [1] Documentation/devicetree/bindings/clock/clock-bindings.txt
-[2] Documentation/devicetree/bindings/clock/st,quadfs.txt
-[3] Documentation/devicetree/bindings/clock/st,quadfs.txt
-[4] Documentation/devicetree/bindings/clock/st,quadfs.txt
+[2] Documentation/devicetree/bindings/clock/st,clkgen-divmux.txt
+[3] Documentation/devicetree/bindings/clock/st,clkgen-mux.txt
+[4] Documentation/devicetree/bindings/clock/st,clkgen-pll.txt
+[5] Documentation/devicetree/bindings/clock/st,clkgen-prediv.txt
+[6] Documentation/devicetree/bindings/clock/st,vcc.txt
+[7] Documentation/devicetree/bindings/clock/st,quadfs.txt
+
 
 Required properties:
 - reg : A Base address and length of the register set.
diff --git a/Documentation/devicetree/bindings/clock/st/st,quadfs.txt b/Documentation/devicetree/bindings/clock/st/st,quadfs.txt
index ec86d62..c0a4045 100644
--- a/Documentation/devicetree/bindings/clock/st/st,quadfs.txt
+++ b/Documentation/devicetree/bindings/clock/st/st,quadfs.txt
@@ -15,6 +15,9 @@ Required properties:
   "st,stih416-quadfs432",	"st,quadfs"
   "st,stih416-quadfs660-E",	"st,quadfs"
   "st,stih416-quadfs660-F",	"st,quadfs"
+  "st,stih407-quadfs660-C",	"st,quadfs"
+  "st,stih407-quadfs660-D",	"st,quadfs"
+
 
 - #clock-cells : from common clock binding; shall be set to 1.
 
-- 
1.9.1

