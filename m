Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038AbaJ1Hm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:42:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbaJ1Dj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:39:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Peddell <klightspeed@killerwolves.net>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.17 086/146] ARM: mvebu: Netgear RN102: Use Hardware BCH ECC
Date: Tue, 28 Oct 2014 11:33:48 +0800
Message-Id: <20141028033347.124502993@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "klightspeed@killerwolves.net" <klightspeed@killerwolves.net>

commit ace8578182dc347b043c0825b9873f62fdaa5b77 upstream.

The bootloader on the Netgear ReadyNAS RN102 uses Hardware BCH ECC
(strength = 4), while the pxa3xx NAND driver by default uses
Hamming ECC (strength = 1).

This patch changes the ECC mode on these machines to match that
of the bootloader and of the stock firmware. That way, it is
now possible to update the kernel from userland (e.g. using
standard tools from mtd-utils package); u-boot will happily
load and boot it.

Fixes: 92beaccd8b49 ("ARM: mvebu: Enable NAND controller in ReadyNAS 102 .dts file")
Signed-off-by: Ben Peddell <klightspeed@killerwolves.net>
Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Tested-by: Arnaud Ebalard <arno@natisbad.org>
Link: https://lkml.kernel.org/r/1410339341-3372-1-git-send-email-klightspeed@killerwolves.net
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/armada-370-netgear-rn102.dts |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm/boot/dts/armada-370-netgear-rn102.dts
+++ b/arch/arm/boot/dts/armada-370-netgear-rn102.dts
@@ -143,6 +143,10 @@
 				marvell,nand-enable-arbiter;
 				nand-on-flash-bbt;
 
+				/* Use Hardware BCH ECC */
+				nand-ecc-strength = <4>;
+				nand-ecc-step-size = <512>;
+
 				partition@0 {
 					label = "u-boot";
 					reg = <0x0000000 0x180000>;  /* 1.5MB */


