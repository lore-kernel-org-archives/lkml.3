Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab3DDHdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:33:46 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35567 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763244Ab3DDHdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:33:45 -0400
Date: Thu, 4 Apr 2013 08:33:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: [PATCH] ARM: ux500: Over-ride TCDM size when booting the DB8540
 platform
Message-ID: <20130404073340.GA6892@gmail.com>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
 <1364908916-29803-5-git-send-email-lee.jones@linaro.org>
 <CACRpkdbh-DJti2ny=uBe-b_vGkQBNL=emMuZ6+_cE5jvRsA4sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbh-DJti2ny=uBe-b_vGkQBNL=emMuZ6+_cE5jvRsA4sA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
 arch/arm/boot/dts/ccu8540.dts |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/ccu8540.dts b/arch/arm/boot/dts/ccu8540.dts
index 02e8e1a..f829689 100644
--- a/arch/arm/boot/dts/ccu8540.dts
+++ b/arch/arm/boot/dts/ccu8540.dts
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
