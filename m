Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab3CZWoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:44:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab3CZWoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [ 56/98] ARM: tegra: fix register address of slink controller
Date: Tue, 26 Mar 2013 15:42:45 -0700
Message-Id: <20130326224248.348235601@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Dewangan <ldewangan@nvidia.com>

commit 57471c8d3c22873f70813820e6b4d2d1fea9629d upstream.

Fix typo on register address of slink3 controller where register
address is wrongly set as 0x7000d480 but it is 0x7000d800.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/tegra20.dtsi |    2 +-
 arch/arm/boot/dts/tegra30.dtsi |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -314,7 +314,7 @@
 
 	spi@7000d800 {
 		compatible = "nvidia,tegra20-slink";
-		reg = <0x7000d480 0x200>;
+		reg = <0x7000d800 0x200>;
 		interrupts = <0 83 0x04>;
 		nvidia,dma-request-selector = <&apbdma 17>;
 		#address-cells = <1>;
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -309,7 +309,7 @@
 
 	spi@7000d800 {
 		compatible = "nvidia,tegra30-slink", "nvidia,tegra20-slink";
-		reg = <0x7000d480 0x200>;
+		reg = <0x7000d800 0x200>;
 		interrupts = <0 83 0x04>;
 		nvidia,dma-request-selector = <&apbdma 17>;
 		#address-cells = <1>;


