Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaJCVnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:43:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbaJCVnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.16 187/357] ARM: dts: dra7-evm: Fix NAND GPMC timings
Date: Fri,  3 Oct 2014 14:29:33 -0700
Message-Id: <20141003212939.090170796@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit 5990047cef0c6a36eefcb166bd32d99a8f95c75b upstream.

The nand timings were scaled down by 2 to account for
the 2x rate returned by clk_get_rate(gpmc_fclk).

As the clock data got fixed by [1], revert back to actual
timings (i.e. scale them up by 2).

Without this NAND doesn't work on dra7-evm.

[1] - commit dd94324b983afe114ba9e7ee3649313b451f63ce
    ARM: dts: dra7xx-clocks: Fix the l3 and l4 clock rates

Fixes: ff66a3c86e00 ("ARM: dts: dra7: add support for parallel NAND flash")
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/dra7-evm.dts |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -427,22 +427,19 @@
 		gpmc,device-width = <2>;
 		gpmc,sync-clk-ps = <0>;
 		gpmc,cs-on-ns = <0>;
-		gpmc,cs-rd-off-ns = <40>;
-		gpmc,cs-wr-off-ns = <40>;
+		gpmc,cs-rd-off-ns = <80>;
+		gpmc,cs-wr-off-ns = <80>;
 		gpmc,adv-on-ns = <0>;
-		gpmc,adv-rd-off-ns = <30>;
-		gpmc,adv-wr-off-ns = <30>;
-		gpmc,we-on-ns = <5>;
-		gpmc,we-off-ns = <25>;
-		gpmc,oe-on-ns = <2>;
-		gpmc,oe-off-ns = <20>;
-		gpmc,access-ns = <20>;
-		gpmc,wr-access-ns = <40>;
-		gpmc,rd-cycle-ns = <40>;
-		gpmc,wr-cycle-ns = <40>;
-		gpmc,wait-pin = <0>;
-		gpmc,wait-on-read;
-		gpmc,wait-on-write;
+		gpmc,adv-rd-off-ns = <60>;
+		gpmc,adv-wr-off-ns = <60>;
+		gpmc,we-on-ns = <10>;
+		gpmc,we-off-ns = <50>;
+		gpmc,oe-on-ns = <4>;
+		gpmc,oe-off-ns = <40>;
+		gpmc,access-ns = <40>;
+		gpmc,wr-access-ns = <80>;
+		gpmc,rd-cycle-ns = <80>;
+		gpmc,wr-cycle-ns = <80>;
 		gpmc,bus-turnaround-ns = <0>;
 		gpmc,cycle2cycle-delay-ns = <0>;
 		gpmc,clk-activation-ns = <0>;


