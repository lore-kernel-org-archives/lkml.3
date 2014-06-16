Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaFPGRC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 02:17:02 -0400
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:23024 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852AbaFPGRA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 02:17:00 -0400
From: Saurav Kashyap <saurav.kashyap@qlogic.com>
To: Joe Perches <joe@perches.com>, linux-kernel <linux-kernel@vger.kernel.org>
CC: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH -next 22/26] qla2xxx: Use dma_zalloc_coherent
Thread-Topic: [PATCH -next 22/26] qla2xxx: Use dma_zalloc_coherent
Thread-Index: AQHPiSqPU9BB2KYxsk+whndch/gCeg==
Date: Mon, 16 Jun 2014 06:16:50 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D01284FFE36@AVMB1.qlogic.org>
References: <cover.1402863904.git.joe@perches.com>
 <5e845f43a014ad7dd4ab3a4fdcd95b879bc496ef.1402863905.git.joe@perches.com>
In-Reply-To: <5e845f43a014ad7dd4ab3a4fdcd95b879bc496ef.1402863905.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9FEC3186B4FB9E4C9BB5E89287019BA1@qlogic.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7470 signatures=670466
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1406160073
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>


>Use the zeroing function instead of dma_alloc_coherent & memset(,0,)
>
>Signed-off-by: Joe Perches <joe@perches.com>
>---
> drivers/scsi/qla2xxx/qla_init.c | 10 ++++------
> 1 file changed, 4 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_init.c
>b/drivers/scsi/qla2xxx/qla_init.c
>index e218441..46990f4 100644
>--- a/drivers/scsi/qla2xxx/qla_init.c
>+++ b/drivers/scsi/qla2xxx/qla_init.c
>@@ -1526,8 +1526,8 @@ try_fce:
> 			    FCE_SIZE, ha->fce, ha->fce_dma);
> 
> 		/* Allocate memory for Fibre Channel Event Buffer. */
>-		tc = dma_alloc_coherent(&ha->pdev->dev, FCE_SIZE, &tc_dma,
>-		    GFP_KERNEL);
>+		tc = dma_zalloc_coherent(&ha->pdev->dev, FCE_SIZE, &tc_dma,
>+					 GFP_KERNEL);
> 		if (!tc) {
> 			ql_log(ql_log_warn, vha, 0x00be,
> 			    "Unable to allocate (%d KB) for FCE.\n",
>@@ -1535,7 +1535,6 @@ try_fce:
> 			goto try_eft;
> 		}
> 
>-		memset(tc, 0, FCE_SIZE);
> 		rval = qla2x00_enable_fce_trace(vha, tc_dma, FCE_NUM_BUFFERS,
> 		    ha->fce_mb, &ha->fce_bufs);
> 		if (rval) {
>@@ -1560,8 +1559,8 @@ try_eft:
> 			    EFT_SIZE, ha->eft, ha->eft_dma);
> 
> 		/* Allocate memory for Extended Trace Buffer. */
>-		tc = dma_alloc_coherent(&ha->pdev->dev, EFT_SIZE, &tc_dma,
>-		    GFP_KERNEL);
>+		tc = dma_zalloc_coherent(&ha->pdev->dev, EFT_SIZE, &tc_dma,
>+					 GFP_KERNEL);
> 		if (!tc) {
> 			ql_log(ql_log_warn, vha, 0x00c1,
> 			    "Unable to allocate (%d KB) for EFT.\n",
>@@ -1569,7 +1568,6 @@ try_eft:
> 			goto cont_alloc;
> 		}
> 
>-		memset(tc, 0, EFT_SIZE);
> 		rval = qla2x00_enable_eft_trace(vha, tc_dma, EFT_NUM_BUFFERS);
> 		if (rval) {
> 			ql_log(ql_log_warn, vha, 0x00c2,
>-- 
>1.8.1.2.459.gbcd45b4.dirty
>

