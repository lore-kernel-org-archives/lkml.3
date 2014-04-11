Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaDKGKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:10:30 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:22681
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750790AbaDKGK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:10:28 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2014 02:10:28 EDT
From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
To: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: DL-MegaRAID Linux <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: RE: [PATCH 52/55] scsi: Move prototype declaration to header file
 megaraid/megaraid_sas.h from megaraid/megaraid_sas_fusion.c
Thread-Topic: [PATCH 52/55] scsi: Move prototype declaration to header file
 megaraid/megaraid_sas.h from megaraid/megaraid_sas_fusion.c
Thread-Index: AQHPS39/4SUaAQMeBkOLlcjWW/zhsZsMAW4Q
Date: Fri, 11 Apr 2014 06:10:24 +0000
Message-ID: <6ec8bc9720b841c8b3b3f9d7fdbd38b1@DM2PR07MB400.namprd07.prod.outlook.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
 <f1f0ea7aadc1c722efdcbaecf3ac9d8dfe3afc5d.1396114898.git.rashika.kheria@gmail.com>
In-Reply-To: <f1f0ea7aadc1c722efdcbaecf3ac9d8dfe3afc5d.1396114898.git.rashika.kheria@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.19.224.250]
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(189002)(199002)(377454003)(51704005)(13464003)(92566001)(4396001)(87936001)(66066001)(46102001)(31966008)(76576001)(2656002)(33646001)(80022001)(76482001)(79102001)(86362001)(77982001)(74316001)(74502001)(74662001)(81342001)(19580405001)(19580395003)(83322001)(83072002)(85852003)(81542001)(99286001)(80976001)(20776003)(99396002)(575784001)(54356999)(76176999)(50986999)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR07MB399;H:DM2PR07MB400.namprd07.prod.outlook.com;FPR:BB6F7442.3E36AED9.69EF9BF3.4B5A19C2.20288;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3B6AbHB000710



>-----Original Message-----
>From: Rashika Kheria [mailto:rashika.kheria@gmail.com]
>Sent: Sunday, March 30, 2014 12:19 AM
>To: linux-kernel@vger.kernel.org
>Cc: DL-MegaRAID Linux; James E.J. Bottomley; linux-scsi@vger.kernel.org;
>josh@joshtriplett.org
>Subject: [PATCH 52/55] scsi: Move prototype declaration to header file
>megaraid/megaraid_sas.h from megaraid/megaraid_sas_fusion.c
>
>Move prototype declaration of function to header file
>megaraid/megaraid_sas.h from megaraid/megaraid_sas_fusion.c because it is
>used by more than one file.
>
>This eliminates the following warning in megaraid/megaraid_sas_fp.c:
>drivers/scsi/megaraid/megaraid_sas_fp.c:1223:5: warning: no previous
>prototype for â€˜get_updated_dev_handleâ€™ [-Wmissing-prototypes]
>
>Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>---
> drivers/scsi/megaraid/megaraid_sas.h        |    3 +++
> drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 --
> 2 files changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>b/drivers/scsi/megaraid/megaraid_sas.h
>index 3b0afb4..17fe706 100644
>--- a/drivers/scsi/megaraid/megaraid_sas.h
>+++ b/drivers/scsi/megaraid/megaraid_sas.h
>@@ -1737,6 +1737,9 @@ megasas_check_and_restore_queue_depth(struct
>megasas_instance *instance);  void megasas_free_cmds(struct
>megasas_instance *instance);  int megasas_alloc_cmds(struct
>megasas_instance *instance);
>
>+u16 get_updated_dev_handle(struct LD_LOAD_BALANCE_INFO *lbInfo,
>+			   struct IO_REQUEST_INFO *in_info);
>+
> u8
> MR_BuildRaidContext(struct megasas_instance *instance,
> 		    struct IO_REQUEST_INFO *io_info,
>diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>index ce6219c..b3d79f4 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>@@ -63,8 +63,6 @@ wait_and_poll(struct megasas_instance *instance, struct
>megasas_cmd *cmd);  int  megasas_clear_intr_fusion(struct
>megasas_register_set __iomem *regs);
>
>-u16 get_updated_dev_handle(struct LD_LOAD_BALANCE_INFO *lbInfo,
>-			   struct IO_REQUEST_INFO *in_info);
> int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
>
> extern u32 megasas_dbg_lvl;

Acked-by: Sumit Saxena <sumit.saxena@lsi.com>

-Sumit
>--
>1.7.9.5
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
