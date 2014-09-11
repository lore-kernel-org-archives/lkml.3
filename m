Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaIKEaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 00:30:39 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:39202 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaIKEah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 00:30:37 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: Chris Zhong <zyw@rock-chips.com>, Addy Ke <addy.ke@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: Switch i2c0 to 400kHz on rk3288-evb-rk808
Date: Wed, 10 Sep 2014 21:30:15 -0700
Message-Id: <1410409815-22200-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should be able to talk to the PMIC at 400kHz.  No need to talk at
the slow 100kHz.

As measured by ftrace (with a bunch of extra patches, since cpufreq
for rk808 hasn't landed yet):
  before this change: cpu0_set_target() => ~500us
  after this change:  cpu0_set_target() => ~300us

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/rk3288-evb-rk808.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/rk3288-evb-rk808.dts b/arch/arm/boot/dts/rk3288-evb-rk808.dts
index 36db177..ff522f8 100644
--- a/arch/arm/boot/dts/rk3288-evb-rk808.dts
+++ b/arch/arm/boot/dts/rk3288-evb-rk808.dts
@@ -18,6 +18,7 @@
 };
 
 &i2c0 {
+	clock-frequency = <400000>;
 	status = "okay";
 
 	rk808: pmic@1b {
-- 
2.1.0.rc2.206.gedb03e5

