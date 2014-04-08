Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbaDHTs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 15:48:29 -0400
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:60939 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932358AbaDHTs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 15:48:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3872:3873:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wound55_497795f1bdb02
X-Filterd-Recvd-Size: 2106
Message-ID: <1396986502.5212.68.camel@joe-AO722>
Subject: Re: [PATCH] scsi: lpfc: lpfc_init: use kcalloc for allocating memory
From: Joe Perches <joe@perches.com>
To: Matei Oprea <eu@opreamatei.ro>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Date: Tue, 08 Apr 2014 12:48:22 -0700
In-Reply-To: <1396986291-28530-1-git-send-email-eu@opreamatei.ro>
References: <1396986291-28530-1-git-send-email-eu@opreamatei.ro>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 22:44 +0300, Matei Oprea wrote:
> It's easier to use kcalloc for allocating arrays. While at it
> also remove useless casting value.
> 
> Signed-off-by: Matei Oprea <eu@opreamatei.ro>
> Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 635eeb3..e286909 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4742,12 +4742,12 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
>  			phba->cfg_sg_seg_cnt = LPFC_DEFAULT_MENLO_SG_SEG_CNT;
>  	}
>  
> -	if (!phba->sli.ring)
> -		phba->sli.ring = (struct lpfc_sli_ring *)
> -			kzalloc(LPFC_SLI3_MAX_RING *
> -			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
> -	if (!phba->sli.ring)
> +	if (!phba->sli.ring) {
> +		phba->sli.ring = kcalloc(LPFC_SLI3_MAX_RING,
> +				sizeof(struct lpfc_sli_ring),
> +				GFP_KERNEL);
>  		return -ENOMEM;
> +	}

You seem to be returning -ENOMEM after kcalloc.

You need to put back the

	if (!phba->sli.ring)
		return -ENOMEM;

after the alloc.


