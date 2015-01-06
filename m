Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbbAFQh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:37:59 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:47875 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbbAFQh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:37:56 -0500
From: mathieu.poirier@linaro.org
To: liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org, patches@linaro.org
Subject: [PATCH 8/9] coresight: Adding DT generic power domain support
Date: Tue,  6 Jan 2015 09:37:12 -0700
Message-Id: <1420562233-2015-9-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420562233-2015-1-git-send-email-mathieu.poirier@linaro.org>
References: <1420562233-2015-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

ETM and PTM tracers need to hookup to the generic power domain
API in order to make sure their power domain doesn't get switched
off by other system components.

On the vexpress a single entity (the SPC) is responsible for power
management of the A7 and A15 clusters domain.  As such using a single
power domain representation with power-domain-cells to represent the
domains, as required by the generic power domain binding.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
index 33920df03640..8f6fc26b59fb 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
@@ -358,6 +358,11 @@
 		};
 	};
 
+	A7_A15_cluster_pd: A7-A15-cluster-pd {
+		compatible = "arm,vexpress-power-controller";
+		#power-domain-cells = <1>;
+	};
+
 	etb@0,20010000 {
 		compatible = "arm,coresight-etb10", "arm,primecell";
 		reg = <0 0x20010000 0 0x1000>;
@@ -494,6 +499,7 @@
 		cpu = <&cpu0>;
 		clocks = <&oscclk6a>;
 		clock-names = "apb_pclk";
+		power-domains = <&A7_A15_cluster_pd 0>;
 		port {
 			ptm0_out_port: endpoint {
 				remote-endpoint = <&funnel_in_port0>;
@@ -508,6 +514,7 @@
 		cpu = <&cpu1>;
 		clocks = <&oscclk6a>;
 		clock-names = "apb_pclk";
+		power-domains = <&A7_A15_cluster_pd 0>;
 		port {
 			ptm1_out_port: endpoint {
 				remote-endpoint = <&funnel_in_port1>;
@@ -522,6 +529,7 @@
 		cpu = <&cpu2>;
 		clocks = <&oscclk6a>;
 		clock-names = "apb_pclk";
+		power-domains = <&A7_A15_cluster_pd 1>;
 		port {
 			etm0_out_port: endpoint {
 				remote-endpoint = <&funnel_in_port2>;
@@ -536,6 +544,7 @@
 		cpu = <&cpu3>;
 		clocks = <&oscclk6a>;
 		clock-names = "apb_pclk";
+		power-domains = <&A7_A15_cluster_pd 1>;
 		port {
 			etm1_out_port: endpoint {
 				remote-endpoint = <&funnel_in_port4>;
@@ -550,6 +559,7 @@
 		cpu = <&cpu4>;
 		clocks = <&oscclk6a>;
 		clock-names = "apb_pclk";
+		power-domains = <&A7_A15_cluster_pd 1>;
 		port {
 			etm2_out_port: endpoint {
 				remote-endpoint = <&funnel_in_port5>;
-- 
1.9.1

