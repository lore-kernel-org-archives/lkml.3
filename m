Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab3EWM5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:57:42 -0400
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:58739 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758180Ab3EWM5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:57:41 -0400
X-Greylist: delayed 2864 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2013 08:57:41 EDT
From: Vijay Mohan Guvva <vmohan@Brocade.com>
To: Jakob Normark <jakobnormark@gmail.com>,
        Anil Gurumurthy <agurumur@Brocade.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 May 2013 06:09:42 -0600
Subject: RE: [PATCH 1/1] bfa: Fixes for 0-terminated strncpy and possible
 null pointer dereference
Thread-Topic: [PATCH 1/1] bfa: Fixes for 0-terminated strncpy and possible
 null pointer dereference
Thread-Index: Ac5RpFGfoGhJSFM2T6Ogx4/SChfjRAGCbvuQ
Message-ID: <51BD2AE8016AE441B63F5661159C99020F1DF187A0@BRM-EXCH-3.corp.brocade.com>
References: <1368646911-22620-1-git-send-email-jakobnormark@gmail.com>
In-Reply-To: <1368646911-22620-1-git-send-email-jakobnormark@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-05-23_04:2013-05-23,2013-05-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1211240000 definitions=main-1305230072
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Jakob Normark
> Sent: Thursday, May 16, 2013 1:12 AM
> To: Anil Gurumurthy; Vijay Mohan Guvva; James E.J. Bottomley
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Jakob Normark
> Subject: [PATCH 1/1] bfa: Fixes for 0-terminated strncpy and possible null
> pointer dereference
> 
> This patch fixes two cppcheck errors in drivers/scsi/bfa/bfad_im.c Kernel
> version: v3.10-rc1
> 
> Signed-off-by: Jakob Normark <jakobnormark@gmail.com>
> ---
>  drivers/scsi/bfa/bfad_im.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c index
> 5864f98..9489c56 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -944,13 +944,15 @@ static int
>  bfad_im_slave_alloc(struct scsi_device *sdev)  {
>  	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
> -	struct bfad_itnim_data_s *itnim_data =
> -				(struct bfad_itnim_data_s *) rport->dd_data;
> -	struct bfa_s *bfa = itnim_data->itnim->bfa_itnim->bfa;
> +	struct bfad_itnim_data_s *itnim_data;
> +	struct bfa_s *bfa;
> 
>  	if (!rport || fc_remote_port_chkready(rport))
>  		return -ENXIO;
> 
> +	itnim_data = (struct bfad_itnim_data_s *) rport->dd_data;
> +	bfa = itnim_data->itnim->bfa_itnim->bfa;
> +
>  	if (bfa_get_lun_mask_status(bfa) == BFA_LUNMASK_ENABLED) {
>  		/*
>  		 * We should not mask LUN 0 - since this will translate @@ -
> 1037,6 +1039,7 @@ bfad_fc_host_init(struct bfad_im_port_s *im_port)
> 
>  	strncpy(symname, bfad-
> >bfa_fcs.fabric.bport.port_cfg.sym_name.symname,
>  		BFA_SYMNAME_MAXLEN);
> +	symname[BFA_SYMNAME_MAXLEN - 1] = '\0';
>  	sprintf(fc_host_symbolic_name(host), "%s", symname);
> 
>  	fc_host_supported_speeds(host) =
> bfad_im_supported_speeds(&bfad->bfa);
> --
> 1.7.9.5

Changes looks good. Thanks for the patch.
Acked-by: Vijay Mohan Guvva <vmohan@brocade.com>


