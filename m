Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761045Ab3DBNWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:22:21 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:56719 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760678Ab3DBNWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:22:17 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/9] ARM: ux500: Over-ride TCDM size when booting the DB8540 platform
Date: Tue,  2 Apr 2013 14:21:52 +0100
Message-Id: <1364908916-29803-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PRCMU's Tightly Coupled Data Memory on the DB8540 platform is
8kB larger than it's predecessor's. We need to reflect that in its
Device Tree. By re-specifying the address and size of the device
we effectively over-ride the previous values with more accurate
ones.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/u8540.dts |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/u8540.dts b/arch/arm/boot/dts/u8540.dts
index 02e8e1a..f829689 100644
--- a/arch/arm/boot/dts/u8540.dts
+++ b/arch/arm/boot/dts/u8540.dts
@@ -21,6 +21,11 @@
 	};
 
 	soc-u9500 {
+		prcmu@80157000 {
+			reg = <0x80157000 0x2000>, <0x801b0000 0x8000>, <0x801b8000 0x3000>;
+			reg-names = "prcmu", "prcmu-tcpm-per4", "prcmu-tcdm-per4";
+		};
+
 		uart@80120000 {
 			status = "okay";
 		};
-- 
1.7.10.4

