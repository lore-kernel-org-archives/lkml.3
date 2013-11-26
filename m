Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab3KZXzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:55:09 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:40337 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3KZXzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:55:05 -0500
From: Stefan Agner <stefan@agner.ch>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, sameo@linux.intel.com,
        dev@lynxeye.de
Cc: mark.rutland@arm.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>
Subject: [PATCH 3/3] ARM: tegra: set SM2 voltage correct
Date: Wed, 27 Nov 2013 00:45:45 +0100
Message-Id: <c9ceead9e3df77b5a33ad654db23c241cd624096.1385508112.git.stefan@agner.ch>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <cover.1385508112.git.stefan@agner.ch>
References: <cover.1385508112.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the requested SM2 voltage to the correct value of 1.8V. The value
before used to work on TPS658623 since the driver applied a wrong
voltage table too. However, the TPS658643 used on newer devices uses
yet another voltage table and those broke that compatibility. The
regulator driver now has the correct voltage table for both regulator
versions and those the correct voltage can be used in this device
tree.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/tegra20-colibri-512.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
index d5c9bca..cbe89ff 100644
--- a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
+++ b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
@@ -268,8 +268,8 @@
 					reg = <3>;
 					regulator-compatible = "sm2";
 					regulator-name = "vdd_sm2,vin_ldo*";
-					regulator-min-microvolt = <3700000>;
-					regulator-max-microvolt = <3700000>;
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
 					regulator-always-on;
 				};
 
-- 
1.8.4.2

