Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbbAFRvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:51:39 -0500
Received: from mail-bl2on0087.outbound.protection.outlook.com ([65.55.169.87]:36285
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756260AbbAFRvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:51:35 -0500
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <michal.simek@xilinx.com>,
        <grant.likely@linaro.org>, <gregkh@linuxfoundation.org>,
        <jason@lakedaemon.net>, <ezequiel.garcia@free-electrons.com>,
        <arnd@arndb.de>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <artem.bityutskiy@linux.intel.com>, <pekon@ti.com>,
        <jussi.kivilinna@iki.fi>, <acourbot@nvidia.com>,
        <ivan.khoronzhuk@ti.com>, <joern@logfs.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <kpc528@gmail.com>, <kalluripunnaiahchoudary@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: [PATCH v5 3/3] Documentation: nand: pl353: Add documentation for controller and driver
Date: Tue, 6 Jan 2015 23:21:12 +0530
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1420566672-6870-1-git-send-email-punnaia@xilinx.com>
References: <1420566672-6870-1-git-send-email-punnaia@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21228.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <66c2f1c72cc848d1bd89adad8f0c608d@BY2FFO11FD025.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(189002)(4396001)(50226001)(2201001)(62966003)(48376002)(64706001)(77156002)(20776003)(47776003)(50466002)(229853001)(106466001)(31966008)(107046002)(53416004)(74316001)(21056001)(92566001)(89996001)(87936001)(86362001)(50986999)(46102003)(76176999)(120916001)(6806004)(15975445007)(19580395003)(92726002)(19580405001)(99396003)(2950100001)(921003)(107986001)(24736002)(2101003)(83996005)(23106004)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB043;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB043;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2FFO11HUB043;
X-Forefront-PRVS: 0448A97BF2
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB043;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2015 17:51:26.6172
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2FFO11HUB043
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added notes about the controller and driver

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
Changes in v5:
- Fixed the review comments
Changes in v4:
- None
---
 Documentation/mtd/nand/pl353-nand.txt |   92 +++++++++++++++++++++++++++++++++
 1 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/mtd/nand/pl353-nand.txt

diff --git a/Documentation/mtd/nand/pl353-nand.txt b/Documentation/mtd/nand/pl353-nand.txt
new file mode 100644
index 0000000..4deac94
--- /dev/null
+++ b/Documentation/mtd/nand/pl353-nand.txt
@@ -0,0 +1,92 @@
+This documents provides some notes about the ARM pl353 smc controller used in
+Zynq SOC and confined to NAND specific details.
+
+Overview of the controller
+==========================
+	The SMC (PL353) supports two memory interfaces:
+	Interface 0 type SRAM.
+	Interface 1 type NAND.
+	This configuration supports the following configurable options:
+	   . 32-bit or 64-bit AXI data width
+	   . 8-bit, 16-bit, or 32-bit memory data width for interface 0
+	   . 8-bit, or 16-bit memory data width for interface 1
+	   . 1-4 chip selects on each interface
+	   . SLC ECC block for interface 1
+
+For more information, refer the below link for TRM
+http://infocenter.arm.com/help/topic/com.arm.doc.ddi0380g/
+DDI0380G_smc_pl350_series_r2p1_trm.pdf
+
+NAND memory accesses
+====================
+	. Two phase NAND accesses
+	. NAND command phase transfers
+	. NAND data phase transfers
+
+Two phase NAND accesses
+	The SMC defines two phases of commands when transferring data to or from
+NAND flash.
+
+Command phase
+	Commands and optional address information are written to the NAND flash.
+The command and address can be associated with either a data phase operation to
+write to or read from the array, or a status/ID register transfer.
+
+Data phase
+ Data is either written to or read from the NAND flash. This data can be either
+data transferred to or from the array, or status/ID register information.
+
+NAND AXI address setup
+       AXI address      Command phase      Data phase
+	[31:24]         Chip address       Chip address
+	[23]            NoOfAddCycles_2    Reserved
+	[22]            NoOfAddCycles_1    Reserved
+	[21]            NoOfAddCycles_0    ClearCS
+	[20]            End command valid  End command valid
+	[19]            0                  1
+	[18:11]         End command        End command
+	[10:3]          Start command      [10] ECC Last
+					   [9:3] Reserved
+	[2:0]           Reserved           Reserved
+
+ECC
+===
+    It operates on a number of 512 byte blocks of NAND memory and can be
+programmed to store the ECC codes after the data in memory. For writes,
+the ECC is written to the spare area of the page. For reads, the result of
+a block ECC check are made available to the device driver.
+
+------------------------------------------------------------------------
+|               n * 512 blocks                  | extra  | ecc    |     |
+|                                               | block  | codes  |     |
+------------------------------------------------------------------------
+
+The ECC calculation uses a simple Hamming code, using 1-bit correction 2-bit
+detection. It starts when a valid read or write command with a 512 byte aligned
+address is detected on the memory interface.
+
+Driver details
+==============
+	The NAND driver has dependancy with the pl353_smc memory controller
+driver for intializing the nand timing parameters, bus width, ECC modes,
+control and status information.
+
+Since the controller expects that the chipselect bit should be cleared for the
+last data transfer i.e last 4 data bytes, the existing nandbase page
+read/write routines for soft ecc and ecc none modes will not work. So, inorder
+to make this driver work, it always updates the ecc mode as HW ECC and
+implemented the page read/write functions for supporting the SW ECC.
+
+HW ECC mode:
+	Upto 2K page size is supported and beyond that it retuns
+-ENOSUPPORT error. If the flsh has ONDIE ecc controller then the
+priority has given to the ONDIE ecc controller. Also the current
+implementation has support for upto 64 byte oob area
+
+SW ECC mode:
+	It supports all the pgae sizes. But since, zynq soc bootrom uses
+HW ECC for the devices that have pgae size <=2K so, to avoid any ecc related
+issues during boot, prefer HW ECC over SW ECC.
+
+For devicetree binding information please refer the below dt binding file
+Documentation/devicetree/bindings/memory-controllers/pl353-smc.txt
-- 
1.7.4

