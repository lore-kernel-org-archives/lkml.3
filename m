Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaE0FBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 01:01:40 -0400
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:9875 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752334AbaE0FBg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 01:01:36 -0400
From: Saurav Kashyap <saurav.kashyap@qlogic.com>
To: Benoit Taine <benoit.taine@lip6.fr>, Chad Dupuis <chad.dupuis@qlogic.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 7/18] qla2xxx: Use kmemdup instead of kmalloc + memcpy
Thread-Topic: [PATCH 7/18] qla2xxx: Use kmemdup instead of kmalloc + memcpy
Thread-Index: AQHPeWi1ZD0y8/Slf0275hHKYhuzkw==
Date: Tue, 27 May 2014 05:01:24 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D01284E9569@AVMB1.qlogic.org>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
 <1401117687-28911-8-git-send-email-benoit.taine@lip6.fr>
In-Reply-To: <1401117687-28911-8-git-send-email-benoit.taine@lip6.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
x-originating-ip: [10.35.102.48]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D1FF50CF43F07340AE9E534D83A345EF@qlogic.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7450 signatures=670455
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1405270073
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>



>This issue was reported by coccicheck using the semantic patch
>at scripts/coccinelle/api/memdup.cocci
>
>Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
>---
>Tested by compilation without errors.
>
> drivers/scsi/qla2xxx/qla_mbx.c |    3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_mbx.c
>b/drivers/scsi/qla2xxx/qla_mbx.c
>index 7f39e36..1c33a77 100644
>--- a/drivers/scsi/qla2xxx/qla_mbx.c
>+++ b/drivers/scsi/qla2xxx/qla_mbx.c
>@@ -1319,7 +1319,7 @@ qla2x00_get_node_name_list(scsi_qla_host_t *vha,
>void **out_data, int *out_len)
> 
> 		left = 0;
> 
>-		list = kzalloc(dma_size, GFP_KERNEL);
>+		list = kmemdup(pmap, dma_size, GFP_KERNEL);
> 		if (!list) {
> 			ql_log(ql_log_warn, vha, 0x1140,
> 			    "%s(%ld): failed to allocate node names list "
>@@ -1328,7 +1328,6 @@ qla2x00_get_node_name_list(scsi_qla_host_t *vha,
>void **out_data, int *out_len)
> 			goto out_free;
> 		}
> 
>-		memcpy(list, pmap, dma_size);
> restart:
> 		dma_free_coherent(&ha->pdev->dev, dma_size, pmap, pmap_dma);
> 	}
>

