Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3ARE51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 23:57:27 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35578 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab3ARE5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 23:57:25 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <tony@atomide.com>, <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <artem.bityutskiy@linux.intel.com>,
        <zonque@gmail.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH] ARM: OMAP: gpmc: Add device tree documentation for elm handle
Date: Fri, 18 Jan 2013 10:27:46 +0530
Message-ID: <1358485066-27495-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case ELM module available, omap2 NAND driver can opt for hardware
correction method for bit flip errors in NAND flash with BCH. Hence the
detection of ELM module is done through devicetree population of elm_id.
This patch update device tree documentation for gpmc-nand for elm-id
data population.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
This patch based [1] and depends on [2]. As Artem suggested, this patch can
go in omap_tree due to the dependency on [3].
Discussion can found at [4]

Tony,
  Can you accept this patch.

1. http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap.git;a=shortlog;h=refs/heads/omap-for-v3.9/gpmc
2. mtd: nand: omap2: Support for hardware BCH error correction
   http://git.infradead.org/users/dedekind/l2-mtd-2.6.git/commit/576daed18c3f27bb5d0e57e1df11e8f7b493dce8
3. ARM: OMAP: gpmc: add DT bindings for GPMC timings and NAND
   http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap.git;a=commit;h=bc6b1e7b86f5d8e4a6fc1c0189e64bba4077efe0
4. https://lkml.org/lkml/2013/1/17/167   

 .../devicetree/bindings/mtd/gpmc-nand.txt          |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
index 9f464f9..e7f8d7e 100644
--- a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
@@ -29,6 +29,9 @@ Optional properties:
 		"bch4"		4-bit BCH ecc code
 		"bch8"		8-bit BCH ecc code
 
+ - elm_id:	Specifies elm device node. This is required to support BCH
+ 		error correction using ELM module.
+
 For inline partiton table parsing (optional):
 
  - #address-cells: should be set to 1
@@ -46,6 +49,7 @@ Example for an AM33xx board:
 		#address-cells = <2>;
 		#size-cells = <1>;
 		ranges = <0 0 0x08000000 0x2000>;	/* CS0: NAND */
+		elm_id = <&elm>;
 
 		nand@0,0 {
 			reg = <0 0 0>; /* CS0, offset 0 */
-- 
1.7.9.5

