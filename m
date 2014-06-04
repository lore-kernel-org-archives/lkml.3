Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbaFEAbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:31:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbaFDXWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.14 110/228] ARM: mvebu: fix NOR bus-width in Armada XP OpenBlocks AX3 Device Tree
Date: Wed,  4 Jun 2014 16:22:19 -0700
Message-Id: <20140604232351.586912286@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 6e20bae8a39c40d4e03698e4160bad2d2629062b upstream.

The mvebu-devbus driver had a serious bug, which lead to a 8 bits bus
width declared in the Device Tree being considered as a 16 bits bus
width when configuring the hardware.

This bug in mvebu-devbus driver was compensated by a symetric mistake
in the Armada XP OpenBlocks AX3 Device Tree: a 8 bits bus width was
declared, even though the hardware actually has a 16 bits bus width
connection with the NOR flash.

Now that we have fixed the mvebu-devbus driver to behave according to
its Device Tree binding, this commit fixes the problematic Device Tree
files as well.

This bug was introduced in commit
a7d4f81821f7eec3175f8e23dd6949c71ab2da43 ('ARM: mvebu: Add support for
NOR flash device on Openblocks AX3 board') which was merged in v3.10.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: https://lkml.kernel.org/r/1397489361-5833-5-git-send-email-thomas.petazzoni@free-electrons.com
Fixes: a7d4f81821f7 ('ARM: mvebu: Add support for NOR flash device on Openblocks AX3 board')
Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
+++ b/arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
@@ -37,7 +37,7 @@
 			/* Device Bus parameters are required */
 
 			/* Read parameters */
-			devbus,bus-width    = <8>;
+			devbus,bus-width    = <16>;
 			devbus,turn-off-ps  = <60000>;
 			devbus,badr-skew-ps = <0>;
 			devbus,acc-first-ps = <124000>;


