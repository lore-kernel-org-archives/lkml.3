Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab3CFS2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 13:28:51 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53184 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab3CFS2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 13:28:49 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Michal Marek <mmarek@suse.cz>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 3/6] ARM: tegra: use #include for all device trees
Date: Wed,  6 Mar 2013 11:28:34 -0700
Message-Id: <1362594517-22099-3-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362594517-22099-1-git-send-email-swarren@wwwdotorg.org>
References: <1362594517-22099-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Replace /include/ (dtc) with #include (C pre-processor) for all Tegra DT
files, so that gcc -E handles the entire include tree, and hence any of
those files can #include some other file e.g. for constant definitions.

This allows future use of #defines and header files in order to define
names for various constants, such as the IDs and flags in GPIO
specifiers. Use of those features will increase the readability of the
device tree files.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Just change the include syntax. Don't rename any files.
---
 arch/arm/boot/dts/tegra114-dalmore.dts     |    2 +-
 arch/arm/boot/dts/tegra114-pluto.dts       |    2 +-
 arch/arm/boot/dts/tegra114.dtsi            |    2 +-
 arch/arm/boot/dts/tegra20-colibri-512.dtsi |    2 +-
 arch/arm/boot/dts/tegra20-harmony.dts      |    2 +-
 arch/arm/boot/dts/tegra20-iris-512.dts     |    2 +-
 arch/arm/boot/dts/tegra20-medcom-wide.dts  |    2 +-
 arch/arm/boot/dts/tegra20-paz00.dts        |    2 +-
 arch/arm/boot/dts/tegra20-plutux.dts       |    2 +-
 arch/arm/boot/dts/tegra20-seaboard.dts     |    2 +-
 arch/arm/boot/dts/tegra20-tamonten.dtsi    |    2 +-
 arch/arm/boot/dts/tegra20-tec.dts          |    2 +-
 arch/arm/boot/dts/tegra20-trimslice.dts    |    2 +-
 arch/arm/boot/dts/tegra20-ventana.dts      |    2 +-
 arch/arm/boot/dts/tegra20-whistler.dts     |    2 +-
 arch/arm/boot/dts/tegra20.dtsi             |    2 +-
 arch/arm/boot/dts/tegra30-beaver.dts       |    2 +-
 arch/arm/boot/dts/tegra30-cardhu-a02.dts   |    2 +-
 arch/arm/boot/dts/tegra30-cardhu-a04.dts   |    2 +-
 arch/arm/boot/dts/tegra30-cardhu.dtsi      |    2 +-
 arch/arm/boot/dts/tegra30.dtsi             |    2 +-
 21 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index a30aca6..62cd1b2 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "tegra114.dtsi"
+#include "tegra114.dtsi"
 
 / {
 	model = "NVIDIA Tegra114 Dalmore evaluation board";
diff --git a/arch/arm/boot/dts/tegra114-pluto.dts b/arch/arm/boot/dts/tegra114-pluto.dts
index 9bea8f5..9e95cb3 100644
--- a/arch/arm/boot/dts/tegra114-pluto.dts
+++ b/arch/arm/boot/dts/tegra114-pluto.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "tegra114.dtsi"
+#include "tegra114.dtsi"
 
 / {
 	model = "NVIDIA Tegra114 Pluto evaluation board";
diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index 1dfaf28..d2150f0 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -1,4 +1,4 @@
-/include/ "skeleton.dtsi"
+#include "skeleton.dtsi"
 
 / {
 	compatible = "nvidia,tegra114";
diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
index 4441620..d77252c 100644
--- a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
+++ b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
@@ -1,4 +1,4 @@
-/include/ "tegra20.dtsi"
+#include "tegra20.dtsi"
 
 / {
 	model = "Toradex Colibri T20 512MB";
diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index 61d027f..a4d0d78 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "tegra20.dtsi"
+#include "tegra20.dtsi"
 
 / {
 	model = "NVIDIA Tegra20 Harmony evaluation board";
diff --git a/arch/arm/boot/dts/tegra20-iris-512.dts b/arch/arm/boot/dts/tegra20-iris-512.dts
index 52f1103..248f7ea 100644
--- a/arch/arm/boot/dts/tegra20-iris-512.dts
+++ b/arch/arm/boot/dts/tegra20-iris-512.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "tegra20-colibri-512.dtsi"
+#include "tegra20-colibri-512.dtsi"
 
 / {
 	model = "Toradex Colibri T20 512MB on Iris";
diff --git a/arch/arm/boot/dts/tegra20-medcom-wide.dts b/arch/arm/boot/dts/tegra20-medcom-wide.dts
index a2d6d65..10aa386 100644
--- a/arch/arm/boot/dts/tegra20-medcom-wide.dts
+++ b/arch/arm/boot/dts/tegra20-medcom-wide.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "tegra20-tamonten.dtsi"
+#include "tegra20-tamonten.dtsi"
 
 / {
 	model = "Avionic Design Medcom-Wide board";
diff --git a/arch/arm/boot/dts/tegra20-paz00.dts b/arch/arm/boot/dts/tegra20-paz00.dts
index 54d6fce..13a2118 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dts
+++ b/arch/arm/boot/dts/tegra20-paz00.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "tegra20.dtsi"
+#include "tegra20.dtsi"
 
 / {
 	model = "Toshiba AC100 / Dynabook AZ";
diff --git a/arch/arm/boot/dts/tegra20-plutux.dts b/arch/arm/boot/dts/tegra20-plutux.dts
index 2894800..eca914e 100644
--- a/arch/arm/boot/dts/tegra20-plutux.dts
+++ b/arch/arm/boot/dts/tegra20-plutux.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "tegra20-tamonten.dtsi"
+#include "tegra20-tamonten.dtsi"
 
 / {
 	model = "Avionic Design Plutux board";
diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
index 37b3a57..74716c9 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "tegra20.dtsi"
+#include "tegra20.dtsi"
 
 / {
 	model = "NVIDIA Seaboard";
diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index 4766aba..855f65d 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -1,4 +1,4 @@
-/include/ "tegra20.dtsi"
+#include "tegra20.dtsi"
 
 / {
 	model = "Avionic Design Tamonten SOM";
diff --git a/arch/arm/boot/dts/tegra20-tec.dts b/arch/arm/boot/dts/tegra20-tec.dts
index 402b210..aaca293 100644
--- a/arch/arm/boot/dts/tegra20-tec.dts
+++ b/arch/arm/boot/dts/tegra20-tec.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "tegra20-tamonten.dtsi"
+#include "tegra20-tamonten.dtsi"
 
 / {
 	model = "Avionic Design Tamonten Evaluation Carrier";
diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dts/tegra20-trimslice.dts
index 5d79e4f..af2a874 100644
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "tegra20.dtsi"
+#include "tegra20.dtsi"
 
 / {
 	model = "Compulab TrimSlice board";
diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index 425c890..b5251db 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "tegra20.dtsi"
+#include "tegra20.dtsi"
 
 / {
 	model = "NVIDIA Tegra20 Ventana evaluation board";
diff --git a/arch/arm/boot/dts/tegra20-whistler.dts b/arch/arm/boot/dts/tegra20-whistler.dts
index ea57c0f..f1d92c1 100644
--- a/arch/arm/boot/dts/tegra20-whistler.dts
+++ b/arch/arm/boot/dts/tegra20-whistler.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "tegra20.dtsi"
+#include "tegra20.dtsi"
 
 / {
 	model = "NVIDIA Tegra20 Whistler evaluation board";
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 7708975..0bff930 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -1,4 +1,4 @@
-/include/ "skeleton.dtsi"
+#include "skeleton.dtsi"
 
 / {
 	compatible = "nvidia,tegra20";
diff --git a/arch/arm/boot/dts/tegra30-beaver.dts b/arch/arm/boot/dts/tegra30-beaver.dts
index 8ff2ff2..89b46c1 100644
--- a/arch/arm/boot/dts/tegra30-beaver.dts
+++ b/arch/arm/boot/dts/tegra30-beaver.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "tegra30.dtsi"
+#include "tegra30.dtsi"
 
 / {
 	model = "NVIDIA Tegra30 Beaver evaluation board";
diff --git a/arch/arm/boot/dts/tegra30-cardhu-a02.dts b/arch/arm/boot/dts/tegra30-cardhu-a02.dts
index adc88aa..814359e 100644
--- a/arch/arm/boot/dts/tegra30-cardhu-a02.dts
+++ b/arch/arm/boot/dts/tegra30-cardhu-a02.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "tegra30-cardhu.dtsi"
+#include "tegra30-cardhu.dtsi"
 
 /* This dts file support the cardhu A02 version of board */
 
diff --git a/arch/arm/boot/dts/tegra30-cardhu-a04.dts b/arch/arm/boot/dts/tegra30-cardhu-a04.dts
index 08163e1..4ac31ec 100644
--- a/arch/arm/boot/dts/tegra30-cardhu-a04.dts
+++ b/arch/arm/boot/dts/tegra30-cardhu-a04.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "tegra30-cardhu.dtsi"
+#include "tegra30-cardhu.dtsi"
 
 /* This dts file support the cardhu A04 and later versions of board */
 
diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index 1749927..51a24cc 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -1,4 +1,4 @@
-/include/ "tegra30.dtsi"
+#include "tegra30.dtsi"
 
 /**
  * This file contains common DT entry for all fab version of Cardhu.
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 9d87a3f..f474b6e 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -1,4 +1,4 @@
-/include/ "skeleton.dtsi"
+#include "skeleton.dtsi"
 
 / {
 	compatible = "nvidia,tegra30";
-- 
1.7.10.4

