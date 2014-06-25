Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaFYULX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:11:23 -0400
Received: from mout.perfora.net ([74.208.4.195]:59314 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbaFYULV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:11:21 -0400
From: Marcel Ziswiler <marcel@ziswiler.com>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, bhelgaas@google.com
Cc: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch,
        Marcel Ziswiler <marcel@ziswiler.com>
Subject: [PATCH] ARM: tegra: Migrate Apalis T30 PCIe power supply scheme
Date: Wed, 25 Jun 2014 22:10:01 +0200
Message-Id: <67868f9464baee36eba48582d56f586ad69d3e86.1403725976.git.marcel@ziswiler.com>
X-Mailer: git-send-email 1.7.9.5
X-Provags-ID: V02:K0:A9DBn7vdCFKQck+PjF+IgWEiOG453/LmYAFSuLO0MqF
 rJd9aK/27Aujt8S92A4mj5JrCTZmGhTKAf+qpRC8fGeJBDZYQ9
 BU9SPkFfMuQjsfoI+/zy9tIfiWHsEJFsCSTDfUM/mmso6+Lpob
 LinXMwMVh9Ob1anr26aBy6uq8fYyge8WB1LbMxpfTWd4MPI+MM
 qsoBWCdywi0oqQcM6AH3RYuvdkWDioD9v9aEtst3YSS86v/29l
 EnN8KkpGE/eSrFLxlFc0rU+/Jg49eJXs3fkEuPnIukp13AxVzn
 R7IzsM4MkFWrMzm86Y8hEAm3ZhSA+keeZ/a9woICXif2tGoZV7
 wOKSNAAmHfwKUZv198mrVbsAytCp4crOLFOVYfo05Ic8iXLKbj
 SNSyjDig9tMDFo2qELUtgd/cprEQq7HSO0W2MxvgzDdYENCgl9
 dqgyCP10Izt+rXr6BCQEa0MqBeg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This migration is required for continued PCIe operation after commit:

d3c7e24b84fcb62f96fa9a585a41f1829f326878

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
---
 arch/arm/boot/dts/tegra30-apalis.dtsi |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-apalis.dtsi b/arch/arm/boot/dts/tegra30-apalis.dtsi
index d04efcf..8adaa78 100644
--- a/arch/arm/boot/dts/tegra30-apalis.dtsi
+++ b/arch/arm/boot/dts/tegra30-apalis.dtsi
@@ -9,9 +9,14 @@
 	compatible = "toradex,apalis_t30", "nvidia,tegra30";
 
 	pcie-controller@00003000 {
-		pex-clk-supply = <&sys_3v3_reg>;
-		vdd-supply = <&vdd2_reg>;
-		avdd-supply = <&ldo6_reg>;
+		avdd-pexa-supply = <&vdd2_reg>;
+		vdd-pexa-supply = <&vdd2_reg>;
+		avdd-pexb-supply = <&vdd2_reg>;
+		vdd-pexb-supply = <&vdd2_reg>;
+		avdd-pex-pll-supply = <&vdd2_reg>;
+		avdd-plle-supply = <&ldo6_reg>;
+		vddio-pex-ctl-supply = <&sys_3v3_reg>;
+		hvdd-pex-supply = <&sys_3v3_reg>;
 
 		pci@1,0 {
 			nvidia,num-lanes = <4>;
-- 
1.7.9.5

