Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbaJ1Gnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:43:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbaJ1Dtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:49:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnaud Ebalard <arno@natisbad.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.14 067/100] ARM: mvebu: Netgear RN104: Use Hardware BCH ECC
Date: Tue, 28 Oct 2014 11:35:52 +0800
Message-Id: <20141028033503.583417387@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033500.670583608@linuxfoundation.org>
References: <20141028033500.670583608@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaud Ebalard <arno@natisbad.org>

commit 225b94cdf719d0bc522a354bdafc18e5da5ff83b upstream.

The bootloader on the Netgear ReadyNAS RN104 uses Hardware BCH
ECC (strength = 4), while the pxa3xx NAND driver by default uses
Hamming ECC (strength = 1).

This patch changes the ECC mode on these machines to match that
of the bootloader and of the stock firmware. That way, it is
now possible to update the kernel from userland (e.g. using
standard tools from mtd-utils package); u-boot will happily
load and boot it.

The issue was initially reported and fixed by Ben Pedell for
RN102. The RN104 shares the same Hynix H27U1G8F2BTR NAND
flash and setup. This patch is based on Ben's fix for RN102.

Fixes: 0373a558bd79 ("ARM: mvebu: Enable NAND controller in ReadyNAS 104 .dts file")
Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Link: https://lkml.kernel.org/r/920c7e7169dc6aaaa3eb4bced2336d38e77b8864.1410035142.git.arno@natisbad.org
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/armada-370-netgear-rn104.dts |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm/boot/dts/armada-370-netgear-rn104.dts
+++ b/arch/arm/boot/dts/armada-370-netgear-rn104.dts
@@ -146,6 +146,10 @@
 				marvell,nand-enable-arbiter;
 				nand-on-flash-bbt;
 
+				/* Use Hardware BCH ECC */
+				nand-ecc-strength = <4>;
+				nand-ecc-step-size = <512>;
+
 				partition@0 {
 					label = "u-boot";
 					reg = <0x0000000 0x180000>;  /* 1.5MB */


