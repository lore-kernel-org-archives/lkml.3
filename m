Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3AKPpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 10:45:38 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49078 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab3AKPpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 10:45:36 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/2] ARM: ux500: Provide a link from AB8500 Pinctrl to the PRCMU
Date: Fri, 11 Jan 2013 15:45:28 +0000
Message-Id: <1357919129-1928-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AB8500 Pinctrl driver uses PRCMU register addresses to
control Pinctrl related functions. For this to happen, the
Pinctrl driver needs the PRCMU base to work from. We can do
that using standard Open Firmware (of_*) function calls, but
first we need a mechanism to gain access to the PRCMU
device node. We're going to use a Phandle in this case.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index db69f3c..3381ba6 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -170,10 +170,9 @@
 			gpio-bank = <8>;
 		};
 
-		pinctrl@80157000 {
-			// This is actually the PRCMU base address
-			reg = <0x80157000 0x2000>;
+		pinctrl {
 			compatible = "stericsson,nmk_pinctrl";
+			prcm = <&prcmu>;
 		};
 
 		usb@a03e0000 {
@@ -190,7 +189,7 @@
 			interrupts = <0 25 0x4>;
 		};
 
-		prcmu@80157000 {
+		prcmu: prcmu@80157000 {
 			compatible = "stericsson,db8500-prcmu";
 			reg = <0x80157000 0x2000>;
 			interrupts = <0 47 0x4>;
-- 
1.7.9.5

