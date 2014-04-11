Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaDKGTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:19:06 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:50550
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750790AbaDKGTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:19:04 -0400
From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
To: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: DL-MegaRAID Linux <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: RE: [PATCH 29/55] scsi: Mark functions as static in
 megaraid/megaraid_sas_fusion.c
Thread-Topic: [PATCH 29/55] scsi: Mark functions as static in
 megaraid/megaraid_sas_fusion.c
Thread-Index: AQHPS3sFuvh/DkmzOE6A+fhQmIjGEZsMAH0Q
Date: Fri, 11 Apr 2014 06:04:19 +0000
Message-ID: <fc3692b5308c4171ae09bb8fb63e9078@DM2PR07MB400.namprd07.prod.outlook.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
 <a0017455228e59c42db9004e315b69e763e25aa3.1396114898.git.rashika.kheria@gmail.com>
In-Reply-To: <a0017455228e59c42db9004e315b69e763e25aa3.1396114898.git.rashika.kheria@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.19.224.250]
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(51704005)(13464003)(377454003)(189002)(199002)(81542001)(83072002)(85852003)(99286001)(81342001)(83322001)(19580405001)(19580395003)(76176999)(54356999)(50986999)(20776003)(80976001)(99396002)(46102001)(31966008)(76576001)(4396001)(92566001)(87936001)(66066001)(86362001)(74502001)(74662001)(77982001)(74316001)(33646001)(80022001)(2656002)(79102001)(76482001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR07MB399;H:DM2PR07MB400.namprd07.prod.outlook.com;FPR:386CF84D.220276D9.F9FCDF17.8BCAF9D1.204A5;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3B6JG3X000746



>-----Original Message-----
>From: Rashika Kheria [mailto:rashika.kheria@gmail.com]
>Sent: Saturday, March 29, 2014 11:47 PM
>To: linux-kernel@vger.kernel.org
>Cc: DL-MegaRAID Linux; James E.J. Bottomley; linux-scsi@vger.kernel.org;
>josh@joshtriplett.org
>Subject: [PATCH 29/55] scsi: Mark functions as static in
>megaraid/megaraid_sas_fusion.c
>
>Mark functions as static in megaraid/megaraid_sas_fusion.c because they are
>not used outside this file.
>
>This eliminates the warnings of following type in
>megaraid/megaraid_sas_fusion.c:
>drivers/scsi/megaraid/megaraid_sas_fusion.c:91:1: warning: no previous
>prototype for â€˜megasas_enable_intr_fusionâ€™ [-Wmissing-prototypes]
>
>Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>---
> drivers/scsi/megaraid/megaraid_sas_fusion.c |   39 ++++++++++++++---------
>----
> 1 file changed, 20 insertions(+), 19 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>index 2806d6d..ce6219c 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>@@ -74,7 +74,7 @@ extern int resetwaittime;
>  * megasas_enable_intr_fusion -	Enables interrupts
>  * @regs:			MFI register set
>  */
>-void
>+static void
> megasas_enable_intr_fusion(struct megasas_instance *instance)  {
> 	struct megasas_register_set __iomem *regs; @@ -94,7 +94,7 @@
>megasas_enable_intr_fusion(struct megasas_instance *instance)
>  * megasas_disable_intr_fusion - Disables interrupt
>  * @regs:			 MFI register set
>  */
>-void
>+static void
> megasas_disable_intr_fusion(struct megasas_instance *instance)  {
> 	u32 mask = 0xFFFFFFFF;
>@@ -134,8 +134,8 @@ megasas_clear_intr_fusion(struct
>megasas_register_set __iomem *regs)
>  *
>  * Returns a free command from the pool
>  */
>-struct megasas_cmd_fusion *megasas_get_cmd_fusion(struct
>megasas_instance
>-						  *instance)
>+static struct megasas_cmd_fusion *megasas_get_cmd_fusion(
>+				  struct megasas_instance *instance)
> {
> 	unsigned long flags;
> 	struct fusion_context *fusion =
>@@ -363,7 +363,7 @@ static int megasas_create_frame_pool_fusion(struct
>megasas_instance *instance)
>  * and is used as SMID of the cmd.
>  * SMID value range is from 1 to max_fw_cmds.
>  */
>-int
>+static int
> megasas_alloc_cmds_fusion(struct megasas_instance *instance)  {
> 	int i, j, count;
>@@ -919,7 +919,7 @@ megasas_display_intel_branding(struct
>megasas_instance *instance)
>  *
>  * This is the main function for initializing firmware.
>  */
>-u32
>+static u32
> megasas_init_adapter_fusion(struct megasas_instance *instance)  {
> 	struct megasas_register_set __iomem *reg_set; @@ -1037,7 +1037,7
>@@ fail_alloc_mfi_cmds:
>  * @frame_count :		Number of frames for the command
>  * @regs :			MFI register set
>  */
>-void
>+static void
> megasas_fire_cmd_fusion(struct megasas_instance *instance,
> 			dma_addr_t req_desc_lo,
> 			u32 req_desc_hi,
>@@ -1059,7 +1059,7 @@ megasas_fire_cmd_fusion(struct megasas_instance
>*instance,
>  * @ext_status :	ext status of cmd returned by FW
>  */
>
>-void
>+static void
> map_cmd_status(struct megasas_cmd_fusion *cmd, u8 status, u8
>ext_status)  {
>
>@@ -1199,7 +1199,7 @@ megasas_make_sgl_fusion(struct megasas_instance
>*instance,
>  *
>  * Used to set the PD LBA in CDB for FP IOs
>  */
>-void
>+static void
> megasas_set_pd_lba(struct MPI2_RAID_SCSI_IO_REQUEST *io_request, u8
>cdb_len,
> 		   struct IO_REQUEST_INFO *io_info, struct scsi_cmnd *scp,
> 		   struct MR_FW_RAID_MAP_ALL *local_map_ptr, u32
>ref_tag) @@ -1376,7 +1376,7 @@ megasas_set_pd_lba(struct
>MPI2_RAID_SCSI_IO_REQUEST *io_request, u8 cdb_len,
>  * Prepares the io_request and chain elements (sg_frame) for IO
>  * The IO can be for PD (Fast Path) or LD
>  */
>-void
>+static void
> megasas_build_ldio_fusion(struct megasas_instance *instance,
> 			  struct scsi_cmnd *scp,
> 			  struct megasas_cmd_fusion *cmd)
>@@ -1678,7 +1678,7 @@ NonFastPath:
>  * Invokes helper functions to prepare request frames
>  * and sets flags appropriate for IO/Non-IO cmd
>  */
>-int
>+static int
> megasas_build_io_fusion(struct megasas_instance *instance,
> 			struct scsi_cmnd *scp,
> 			struct megasas_cmd_fusion *cmd)
>@@ -1749,7 +1749,7 @@ megasas_build_io_fusion(struct megasas_instance
>*instance,
> 	return 0;
> }
>
>-union MEGASAS_REQUEST_DESCRIPTOR_UNION *
>+static union MEGASAS_REQUEST_DESCRIPTOR_UNION *
> megasas_get_request_descriptor(struct megasas_instance *instance, u16
>index)  {
> 	u8 *p;
>@@ -1829,7 +1829,7 @@ megasas_build_and_issue_cmd_fusion(struct
>megasas_instance *instance,
>  * @instance:			Adapter soft state
>  * Completes all commands that is in reply descriptor queue
>  */
>-int
>+static int
> complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)  {
> 	union MPI2_REPLY_DESCRIPTORS_UNION *desc; @@ -1974,7 +1974,7
>@@ complete_cmd_fusion(struct megasas_instance *instance, u32
>MSIxIndex)
>  *
>  * Tasklet to complete cmds
>  */
>-void
>+static void
> megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)  {
> 	struct megasas_instance *instance =
>@@ -1999,7 +1999,7 @@ megasas_complete_cmd_dpc_fusion(unsigned long
>instance_addr)
> /**
>  * megasas_isr_fusion - isr entry point
>  */
>-irqreturn_t megasas_isr_fusion(int irq, void *devp)
>+static irqreturn_t megasas_isr_fusion(int irq, void *devp)
> {
> 	struct megasas_irq_context *irq_context = devp;
> 	struct megasas_instance *instance = irq_context->instance; @@ -
>2038,7 +2038,7 @@ irqreturn_t megasas_isr_fusion(int irq, void *devp)
>  * mfi_cmd:			megasas_cmd pointer
>  *
>  */
>-u8
>+static u8
> build_mpt_mfi_pass_thru(struct megasas_instance *instance,
> 			struct megasas_cmd *mfi_cmd)
> {
>@@ -2101,7 +2101,7 @@ build_mpt_mfi_pass_thru(struct megasas_instance
>*instance,
>  * @cmd:			mfi cmd to build
>  *
>  */
>-union MEGASAS_REQUEST_DESCRIPTOR_UNION *
>+static union MEGASAS_REQUEST_DESCRIPTOR_UNION *
> build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd
>*cmd)  {
> 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc; @@ -
>2134,7 +2134,7 @@ build_mpt_cmd(struct megasas_instance *instance,
>struct megasas_cmd *cmd)
>  * @cmd:			mfi cmd pointer
>  *
>  */
>-void
>+static void
> megasas_issue_dcmd_fusion(struct megasas_instance *instance,
> 			  struct megasas_cmd *cmd)
> {
>@@ -2197,7 +2197,8 @@ megasas_check_reset_fusion(struct
>megasas_instance *instance,  }
>
> /* This function waits for outstanding commands on fusion to complete */ -
>int megasas_wait_for_outstanding_fusion(struct megasas_instance
>*instance)
>+static int megasas_wait_for_outstanding_fusion(struct megasas_instance
>+					       *instance)
> {
> 	int i, outstanding, retval = 0;
> 	u32 fw_state;

Acked-by: Sumit Saxena <sumit.saxena@lsi.com>

-Sumit
>--
>1.7.9.5
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
