Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbaDKGWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:22:14 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:36569
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751462AbaDKGWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:22:12 -0400
From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
To: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: DL-MegaRAID Linux <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: RE: [PATCH 51/55] scsi: Move prototype declaration to header file
 megaraid/megaraid_sas_fusion.h from megaraid/megaraid_sas_base.c
Thread-Topic: [PATCH 51/55] scsi: Move prototype declaration to header file
 megaraid/megaraid_sas_fusion.h from megaraid/megaraid_sas_base.c
Thread-Index: AQHPS39OeXpeMNk38kq+xOCJoxvREpsMATPg
Date: Fri, 11 Apr 2014 06:06:22 +0000
Message-ID: <1c8b659ee2504ec4a351f9a17ab00412@DM2PR07MB400.namprd07.prod.outlook.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
 <c3ef8857a4533ed6282301f74cec5a4b42e75944.1396114898.git.rashika.kheria@gmail.com>
In-Reply-To: <c3ef8857a4533ed6282301f74cec5a4b42e75944.1396114898.git.rashika.kheria@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.19.224.250]
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(51704005)(189002)(199002)(377454003)(13464003)(92566001)(74316001)(85852003)(20776003)(66066001)(99286001)(19580405001)(83322001)(19580395003)(76176999)(54356999)(50986999)(79102001)(80976001)(86362001)(4396001)(80022001)(2656002)(77982001)(33646001)(81342001)(76576001)(87936001)(74502001)(46102001)(74662001)(81542001)(76482001)(99396002)(31966008)(83072002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR07MB398;H:DM2PR07MB400.namprd07.prod.outlook.com;FPR:BA3EF86E.240B8EDA.8BD79BFB.6B493AF1.20295;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3B6MMar000760



>-----Original Message-----
>From: Rashika Kheria [mailto:rashika.kheria@gmail.com]
>Sent: Sunday, March 30, 2014 12:18 AM
>To: linux-kernel@vger.kernel.org
>Cc: DL-MegaRAID Linux; James E.J. Bottomley; linux-scsi@vger.kernel.org;
>josh@joshtriplett.org
>Subject: [PATCH 51/55] scsi: Move prototype declaration to header file
>megaraid/megaraid_sas_fusion.h from megaraid/megaraid_sas_base.c
>
>Move prototype declarations of functions to header file
>megaraid/megaraid_sas_fusion.h from megaraid/megaraid_sas_base.c
>because they are used by more than one file.
>
>This eliminates the following type of warnings in
>megaraid/megaraid_sas_fusion.c:
>drivers/scsi/megaraid/megaraid_sas_fusion.c:2170:1: warning: no previous
>prototype for â€˜megasas_release_fusionâ€™ [-Wmissing-prototypes]
>
>Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c   |   13 -------------
> drivers/scsi/megaraid/megaraid_sas_fusion.h |   14 ++++++++++++++
> 2 files changed, 14 insertions(+), 13 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 9768deee..0ad386b 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -160,21 +160,8 @@ u32
> megasas_build_and_issue_cmd(struct megasas_instance *instance,
> 			    struct scsi_cmnd *scmd);
> static void megasas_complete_cmd_dpc(unsigned long instance_addr); -void
>-megasas_release_fusion(struct megasas_instance *instance); -int -
>megasas_ioc_init_fusion(struct megasas_instance *instance); -void -
>megasas_free_cmds_fusion(struct megasas_instance *instance);
>-u8
>-megasas_get_map_info(struct megasas_instance *instance); -int -
>megasas_sync_map_info(struct megasas_instance *instance);  int
>wait_and_poll(struct megasas_instance *instance, struct megasas_cmd
>*cmd); -void megasas_reset_reply_desc(struct megasas_instance *instance);
>-int megasas_reset_fusion(struct Scsi_Host *shost); -void
>megasas_fusion_ocr_wq(struct work_struct *work);
>
> static void
> megasas_issue_dcmd(struct megasas_instance *instance, struct
>megasas_cmd *cmd) diff --git
>a/drivers/scsi/megaraid/megaraid_sas_fusion.h
>b/drivers/scsi/megaraid/megaraid_sas_fusion.h
>index 35a5139..01e5ab3 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
>+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
>@@ -760,4 +760,18 @@ union desc_value {
> 	} u;
> };
>
>+void
>+megasas_release_fusion(struct megasas_instance *instance); int
>+megasas_ioc_init_fusion(struct megasas_instance *instance); void
>+megasas_free_cmds_fusion(struct megasas_instance *instance);
>+u8
>+megasas_get_map_info(struct megasas_instance *instance); int
>+megasas_sync_map_info(struct megasas_instance *instance); void
>+megasas_reset_reply_desc(struct megasas_instance *instance); int
>+megasas_reset_fusion(struct Scsi_Host *shost); void
>+megasas_fusion_ocr_wq(struct work_struct *work);
>+
> #endif /* _MEGARAID_SAS_FUSION_H_ */

Acked-by: Sumit Saxena <sumit.saxena@lsi.com>

-Sumit
>--
>1.7.9.5
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
