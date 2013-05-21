Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab3EUGC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:02:57 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:58957 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab3EUGC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:02:56 -0400
X-AuditID: 9c93017e-b7c8fae000000f00-cd-519b0e0d817b
From: Jongsung Kim <neidhard.kim@lge.com>
To: swarren@wwwdotorg.org, linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        jslaby@suse.cz
Cc: linux-serial@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jongsung Kim <neidhard.kim@lge.com>
Subject: [PATCH] ARM: bcm2835: override the HW UART periphid
Date: Tue, 21 May 2013 15:02:29 +0900
Message-Id: <1369116149-2361-1-git-send-email-neidhard.kim@lge.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <519AD82A.6090809@wwwdotorg.org>
References: <519AD82A.6090809@wwwdotorg.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren reported the recent commit 78506f2 (add support for
extended FIFO-size of PL011-r1p5) breaks the serial port on the
BCM2835 ARM SoC.

A UART compatible with the ARM PL011-r1p5 should have 32-deep FIFOs.
The BCM2835 UART just looks like an ARM PL011-r1p5, but has 16-deep
FIFOs just like PL011-r1p4 or earlier revisions. As a workaround for
this compatibility issue, this patch overrides the HW UART periphid
register values with the actually compatible UART periphid 0x00241011
(r1p3 or r1p4).

Reported-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Jongsung Kim <neidhard.kim@lge.com>
---
 arch/arm/boot/dts/bcm2835.dtsi |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/bcm2835.dtsi b/arch/arm/boot/dts/bcm2835.dtsi
index f0052dc..1e12aef 100644
--- a/arch/arm/boot/dts/bcm2835.dtsi
+++ b/arch/arm/boot/dts/bcm2835.dtsi
@@ -44,6 +44,7 @@
 			reg = <0x7e201000 0x1000>;
 			interrupts = <2 25>;
 			clock-frequency = <3000000>;
+			arm,primecell-periphid = <0x00241011>;
 		};
 
 		gpio: gpio {
-- 
1.7.1

