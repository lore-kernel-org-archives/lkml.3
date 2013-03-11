Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3CKSV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:21:57 -0400
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:54372 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245Ab3CKSVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:21:55 -0400
From: Vijay Mohan Guvva <vmohan@Brocade.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Anil Gurumurthy <agurumur@Brocade.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Mon, 11 Mar 2013 12:21:46 -0600
Subject: RE: [patch] [SCSI] bfa: Use GFP_ATOMIC under spin_lock
Thread-Topic: [patch] [SCSI] bfa: Use GFP_ATOMIC under spin_lock
Thread-Index: Ac4b9So4+ukEzhEVQrWiHsMOkYOM+ACj85Fw
Message-ID: <51BD2AE8016AE441B63F5661159C990203A17E0D0C@BRM-EXCH-3.corp.brocade.com>
References: <20130308120115.GA18712@longonot.mountain>
In-Reply-To: <20130308120115.GA18712@longonot.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-03-11_03:2013-03-08,2013-03-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1211240000 definitions=main-1303110136
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Friday, March 08, 2013 4:01 AM
> To: Anil Gurumurthy
> Cc: Vijay Mohan Guvva; James E.J. Bottomley; linux-scsi@vger.kernel.org;
> linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [patch] [SCSI] bfa: Use GFP_ATOMIC under spin_lock
> 
> This is always called with spinlocks held so it should use GFP_ATOMIC.  The
> call tree is:
> 
> -> bfad_drv_start()
>    Takes spin_lock_irqsave(&bfad->bfad_lock, flags);
>    -> bfa_fcs_pbc_vport_init()
>       -> bfa_fcb_pbc_vport_create()
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c index
> a5f7690..d144a06 100644
> --- a/drivers/scsi/bfa/bfad.c
> +++ b/drivers/scsi/bfa/bfad.c
> @@ -491,7 +491,7 @@ bfa_fcb_pbc_vport_create(struct bfad_s *bfad,
> struct bfi_pbc_vport_s pbc_vport)
>  	struct bfad_vport_s   *vport;
>  	int rc;
> 
> -	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_KERNEL);
> +	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_ATOMIC);
>  	if (!vport) {
>  		bfa_trc(bfad, 0);
>  		return;

Changes looks good. Thanks for the patch.
Acked-by: Vijay Mohan Guvva <vmohan@Brocade.com>
