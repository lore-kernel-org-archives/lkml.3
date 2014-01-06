Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbaAGAGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:06:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbaAFWie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        William Towle <william.towle@codethink.co.uk>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH 3.12 044/144] ARM: shmobile: r8a7790: fix shdi resource sizes
Date: Mon,  6 Jan 2014 14:36:45 -0800
Message-Id: <20140106223746.601770096@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Dooks <ben.dooks@codethink.co.uk>

commit d721a15c300c5f638a11573a6dd492158e737d6a upstream.

The r8a7790.dtsi file has four sdhi nodes which the first two have the wrong
resource size for their register block. This causes the sh_modbile_sdhi driver
to fail to communicate with card at-all.

Change sdhi{0,1} node size from 0x100 to 0x200 to correct these nodes
as per Kuninori Morimoto's response to the original patch where all four
nodes where changed. sdhi{2,3} are the correct size.

This bug has been present since sdhi resources were added to the r8a7790 by
8c9b1aa41853272a ("ARM: shmobile: r8a7790: add MMCIF and SDHI DT
templates") in v3.11-rc2.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Tested-by: William Towle <william.towle@codethink.co.uk>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/r8a7790.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/r8a7790.dtsi
+++ b/arch/arm/boot/dts/r8a7790.dtsi
@@ -152,7 +152,7 @@
 
 	sdhi0: sdhi@ee100000 {
 		compatible = "renesas,sdhi-r8a7790";
-		reg = <0 0xee100000 0 0x100>;
+		reg = <0 0xee100000 0 0x200>;
 		interrupt-parent = <&gic>;
 		interrupts = <0 165 4>;
 		cap-sd-highspeed;
@@ -161,7 +161,7 @@
 
 	sdhi1: sdhi@ee120000 {
 		compatible = "renesas,sdhi-r8a7790";
-		reg = <0 0xee120000 0 0x100>;
+		reg = <0 0xee120000 0 0x200>;
 		interrupt-parent = <&gic>;
 		interrupts = <0 166 4>;
 		cap-sd-highspeed;


