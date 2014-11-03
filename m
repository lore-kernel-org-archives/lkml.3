Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaKCEz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 23:55:57 -0500
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:52615 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128AbaKCEz4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 23:55:56 -0500
From: Saurav Kashyap <saurav.kashyap@qlogic.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>
CC: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: scsi: qla2xxx: Remove redundant declaration in
 'qla_gbl.h'
Thread-Topic: [PATCH] drivers: scsi: qla2xxx: Remove redundant declaration
 in 'qla_gbl.h'
Thread-Index: AQHP9ciXzDxSSqDZGE6k65TOWg0d85xPO1iA
Date: Mon, 3 Nov 2014 04:54:57 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D0128570B02@AVMB1.qlogic.org>
References: <5454C804.50407@gmail.com>
In-Reply-To: <5454C804.50407@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.4.5.141003
x-originating-ip: [10.1.4.10]
disclaimer: bypass
Content-Type: text/plain; charset="us-ascii"
Content-ID: <54655209CFD35D45977A89E2DECE266B@qlogic.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7610 signatures=670571
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1411030053
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>


>Remove 2 redundant extern inline functions: qla8044_set_qsnt_ready() and
>qla8044_need_reset_handler(). At present, within upstream next kernel
>source code, they are only used within "drivers/scsi/qla2xxx/qla_nx2.c".
>
>The related error and warnings (with allmodconfig under tile):
>
>    CC [M]  drivers/scsi/qla2xxx/qla_nx2.o
>  drivers/scsi/qla2xxx/qla_nx2.c:1633:1: error: static declaration of
>'qla8044_need_reset_handler' follows non-static declaration
>   qla8044_need_reset_handler(struct scsi_qla_host *vha)
>   ^
>  In file included from drivers/scsi/qla2xxx/qla_def.h:3706:0,
>                   from drivers/scsi/qla2xxx/qla_nx2.c:11:
>  drivers/scsi/qla2xxx/qla_gbl.h:756:20: note: previous declaration of
>'qla8044_need_reset_handler' was here
>   extern inline void qla8044_need_reset_handler(struct scsi_qla_host
>*vha);
>                      ^
>  drivers/scsi/qla2xxx/qla_gbl.h:756:20: warning: inline function
>'qla8044_need_reset_handler' declared but never defined
>  make[3]: *** [drivers/scsi/qla2xxx/qla_nx2.o] Error 1
>  make[2]: *** [drivers/scsi/qla2xxx] Error 2
>  make[1]: *** [drivers/scsi] Error 2
>  make: *** [drivers] Error 2
>
>    CC [M]  drivers/scsi/qla2xxx/qla_tmpl.o
>  In file included from drivers/scsi/qla2xxx/qla_def.h:3706:0,
>                   from drivers/scsi/qla2xxx/qla_tmpl.c:7:
>  drivers/scsi/qla2xxx/qla_gbl.h:755:20: warning: inline function
>'qla8044_set_qsnt_ready' declared but never defined
>   extern inline void qla8044_set_qsnt_ready(struct scsi_qla_host *vha);
>                    ^
>
>Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>---
> drivers/scsi/qla2xxx/qla_gbl.h | 2 --
> drivers/scsi/qla2xxx/qla_nx2.c | 2 +-
> 2 files changed, 1 insertion(+), 3 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_gbl.h
>b/drivers/scsi/qla2xxx/qla_gbl.h
>index b1865a7..7686bfe 100644
>--- a/drivers/scsi/qla2xxx/qla_gbl.h
>+++ b/drivers/scsi/qla2xxx/qla_gbl.h
>@@ -752,8 +752,6 @@ extern void qla8044_set_idc_dontreset(struct
>scsi_qla_host *ha);
> extern int qla8044_rd_direct(struct scsi_qla_host *vha, const uint32_t
>crb_reg);
> extern void qla8044_wr_direct(struct scsi_qla_host *vha,
> 			      const uint32_t crb_reg, const uint32_t value);
>-extern inline void qla8044_set_qsnt_ready(struct scsi_qla_host *vha);
>-extern inline void qla8044_need_reset_handler(struct scsi_qla_host *vha);
> extern int qla8044_device_state_handler(struct scsi_qla_host *vha);
> extern void qla8044_clear_qsnt_ready(struct scsi_qla_host *vha);
> extern void qla8044_clear_drv_active(struct qla_hw_data *);
>diff --git a/drivers/scsi/qla2xxx/qla_nx2.c
>b/drivers/scsi/qla2xxx/qla_nx2.c
>index 24a8528..ed4d6b6 100644
>--- a/drivers/scsi/qla2xxx/qla_nx2.c
>+++ b/drivers/scsi/qla2xxx/qla_nx2.c
>@@ -238,7 +238,7 @@ qla8044_rmw_crb_reg(struct scsi_qla_host *vha,
> 	return;
> }
> 
>-inline void
>+static inline void
> qla8044_set_qsnt_ready(struct scsi_qla_host *vha)
> {
> 	uint32_t qsnt_state;
>-- 
>1.9.3

