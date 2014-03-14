Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbaCNQPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:15:14 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:49286
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755370AbaCNQO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:14:57 -0400
Date: Fri, 14 Mar 2014 21:40:30 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <sreekanth.reddy@lsi.com>,
        <linux-kernel@vger.kernel.org>, <sreekanthreddy0547@gmail.com>
Subject: [PATCH 2/9][SCSI]mpt3sas: MPI2.5 Rev G (2.5.2) specifications
Message-ID: <20140314161030.GA8357@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(377424004)(87266001)(74876001)(85306002)(87936001)(74706001)(81542001)(33656001)(50466002)(81342001)(69226001)(31966008)(74366001)(92726001)(54356001)(53806001)(51856001)(23726002)(46406003)(56776001)(76796001)(83322001)(19580395003)(94316002)(6806004)(44976005)(80976001)(19580405001)(81686001)(63696002)(47776003)(20776003)(36756003)(65816001)(93516002)(86362001)(80022001)(59766001)(93136001)(77982001)(575784001)(54316002)(95416001)(85852003)(95666003)(97186001)(81816001)(83072002)(47446002)(97336001)(77096001)(56816005)(47976001)(79102001)(83506001)(74662001)(76786001)(46102001)(92566001)(76482001)(74502001)(16796002)(97756001)(47736001)(90146001)(4396001)(57986002)(94946001)(50986001)(76176001)(49866001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB068;H:COSEXCH10.lsi.com;FPR:B628D567.ACF29C4D.30D42048.82BF2ED3.20487;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0150F3F97D
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the change set in MPI2.5 Rev G specification and 2.00.31 header files
1) Added SCSIStatusQualifier to SCSI IO Error Reply message.
2) Added ATA Security Freeze Lock to IO Unit Page 1 Flags field.
3) Added Allow Protection Information bit for IR Volume Create.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt3sas/mpi/mpi2.h      |    6 ++++--
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h |    8 ++++++--
 drivers/scsi/mpt3sas/mpi/mpi2_init.h |    6 ++++--
 drivers/scsi/mpt3sas/mpi/mpi2_raid.h |    6 +++++-
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2.h b/drivers/scsi/mpt3sas/mpi/mpi2.h
index 20da8f9..dc143dd 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2.h
@@ -8,7 +8,7 @@
  *                 scatter/gather formats.
  * Creation Date:  June 21, 2006
  *
- * mpi2.h Version:  02.00.29
+ * mpi2.h Version:  02.00.31
  *
  * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or Mpi25
  *       prefix are for use only on MPI v2.5 products, and must not be used
@@ -86,6 +86,8 @@
  * 11-27-12  02.00.28  Bumped MPI2_HEADER_VERSION_UNIT.
  * 12-20-12  02.00.29  Bumped MPI2_HEADER_VERSION_UNIT.
  *                     Added MPI25_SUP_REPLY_POST_HOST_INDEX_OFFSET.
+ * 04-09-13  02.00.30  Bumped MPI2_HEADER_VERSION_UNIT.
+ * 04-17-13  02.00.31  Bumped MPI2_HEADER_VERSION_UNIT.
  * --------------------------------------------------------------------------
  */
 
@@ -119,7 +121,7 @@
 #define MPI2_VERSION_02_05                  (0x0205)
 
 /*Unit and Dev versioning for this MPI header set */
-#define MPI2_HEADER_VERSION_UNIT            (0x1D)
+#define MPI2_HEADER_VERSION_UNIT            (0x1F)
 #define MPI2_HEADER_VERSION_DEV             (0x00)
 #define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
 #define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 889aa70..5b0e5c1 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -6,7 +6,7 @@
  *         Title:  MPI Configuration messages and pages
  * Creation Date:  November 10, 2006
  *
- *   mpi2_cnfg.h Version:  02.00.24
+ *   mpi2_cnfg.h Version:  02.00.25
  *
  * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or Mpi25
  *       prefix are for use only on MPI v2.5 products, and must not be used
@@ -160,6 +160,9 @@
  * 12-20-12  02.00.24  Marked MPI2_SASIOUNIT1_CONTROL_CLEAR_AFFILIATION as
  *                     obsolete for MPI v2.5 and later.
  *                     Added some defines for 12G SAS speeds.
+ * 04-09-13  02.00.25  Added MPI2_IOUNITPAGE1_ATA_SECURITY_FREEZE_LOCK.
+ *                     Fixed MPI2_IOUNITPAGE5_DMA_CAP_MASK_MAX_REQUESTS to
+ *                     match the specification.
  * --------------------------------------------------------------------------
  */
 
@@ -792,6 +795,7 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_1 {
 #define MPI2_IOUNITPAGE1_PAGEVERSION                    (0x04)
 
 /*IO Unit Page 1 Flags defines */
+#define MPI2_IOUNITPAGE1_ATA_SECURITY_FREEZE_LOCK       (0x00004000)
 #define MPI25_IOUNITPAGE1_NEW_DEVICE_FAST_PATH_DISABLE  (0x00002000)
 #define MPI25_IOUNITPAGE1_DISABLE_FAST_PATH             (0x00001000)
 #define MPI2_IOUNITPAGE1_ENABLE_HOST_BASED_DISCOVERY    (0x00000800)
@@ -870,7 +874,7 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_5 {
 #define MPI2_IOUNITPAGE5_PAGEVERSION                    (0x00)
 
 /*defines for IO Unit Page 5 DmaEngineCapabilities field */
-#define MPI2_IOUNITPAGE5_DMA_CAP_MASK_MAX_REQUESTS      (0xFF00)
+#define MPI2_IOUNITPAGE5_DMA_CAP_MASK_MAX_REQUESTS      (0xFFFF0000)
 #define MPI2_IOUNITPAGE5_DMA_CAP_SHIFT_MAX_REQUESTS     (16)
 
 #define MPI2_IOUNITPAGE5_DMA_CAP_EEDP                   (0x0008)
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_init.h b/drivers/scsi/mpt3sas/mpi/mpi2_init.h
index f7928bf..b3e3331 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_init.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_init.h
@@ -6,7 +6,7 @@
  *         Title:  MPI SCSI initiator mode messages and structures
  * Creation Date:  June 23, 2006
  *
- * mpi2_init.h Version:  02.00.14
+ * mpi2_init.h Version:  02.00.15
  *
  * NOTE: Names (typedefs, defines, etc.) beginning with an MPI25 or Mpi25
  *       prefix are for use only on MPI v2.5 products, and must not be used
@@ -44,6 +44,8 @@
  *                     Priority to match SAM-4.
  *                     Added EEDPErrorOffset to MPI2_SCSI_IO_REPLY.
  * 07-10-12  02.00.14  Added MPI2_SCSIIO_CONTROL_SHIFT_DATADIRECTION.
+ * 04-09-13  02.00.15  Added SCSIStatusQualifier field to MPI2_SCSI_IO_REPLY,
+ *                     replacing the Reserved4 field.
  * --------------------------------------------------------------------------
  */
 
@@ -347,7 +349,7 @@ typedef struct _MPI2_SCSI_IO_REPLY {
 	U32 SenseCount;		/*0x18 */
 	U32 ResponseInfo;	/*0x1C */
 	U16 TaskTag;		/*0x20 */
-	U16 Reserved4;		/*0x22 */
+	U16 SCSIStatusQualifier; /* 0x22 */
 	U32 BidirectionalTransferCount;	/*0x24 */
 	U32 EEDPErrorOffset;	/*0x28 *//*MPI 2.5 only; Reserved in MPI 2.0*/
 	U32 Reserved6;		/*0x2C */
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_raid.h b/drivers/scsi/mpt3sas/mpi/mpi2_raid.h
index 7176523..fbe3aae 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_raid.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_raid.h
@@ -6,7 +6,7 @@
  *         Title:  MPI Integrated RAID messages and structures
  * Creation Date:  April 26, 2007
  *
- *   mpi2_raid.h Version:  02.00.09
+ *   mpi2_raid.h Version:  02.00.10
  *
  * Version History
  * ---------------
@@ -30,6 +30,7 @@
  * 02-06-12  02.00.08  Added MPI2_RAID_ACTION_PHYSDISK_HIDDEN.
  * 07-26-12  02.00.09  Added ElapsedSeconds field to MPI2_RAID_VOL_INDICATOR.
  *                     Added MPI2_RAID_VOL_FLAGS_ELAPSED_SECONDS_VALID define.
+ * 04-17-13  02.00.10  Added MPI25_RAID_ACTION_ADATA_ALLOW_PI.
  * --------------------------------------------------------------------------
  */
 
@@ -46,6 +47,9 @@
 * RAID Action messages
 ****************************************************************************/
 
+/* ActionDataWord defines for use with MPI2_RAID_ACTION_CREATE_VOLUME action */
+#define MPI25_RAID_ACTION_ADATA_ALLOW_PI            (0x80000000)
+
 /*ActionDataWord defines for use with MPI2_RAID_ACTION_DELETE_VOLUME action */
 #define MPI2_RAID_ACTION_ADATA_KEEP_LBA0            (0x00000000)
 #define MPI2_RAID_ACTION_ADATA_ZERO_LBA0            (0x00000001)
-- 
1.7.1

