Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaCLVfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 17:35:50 -0400
Received: from smtprelay0143.hostedemail.com ([216.40.44.143]:53799 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750981AbaCLVfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 17:35:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:4321:5007:6642:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: actor17_142b7ffe50210
X-Filterd-Recvd-Size: 1578
Message-ID: <1394660137.3915.58.camel@joe-AO722>
Subject: Re: [PATCH] Scsi: lpfc: lpfc_init: Remove useless casting value
From: Joe Perches <joe@perches.com>
To: Matei Oprea <eu@opreamatei.ro>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Date: Wed, 12 Mar 2014 14:35:37 -0700
In-Reply-To: <1394659247-20037-1-git-send-email-eu@opreamatei.ro>
References: <1394659247-20037-1-git-send-email-eu@opreamatei.ro>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 23:20 +0200, Matei Oprea wrote:
> Remove useless casting value returned by k[cmz]alloc
> to (struct lpfc_sli_ring *).
> 
> Found using coccinelle

trivial note:

> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
[]
> @@ -4731,8 +4731,7 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
[]
> -		phba->sli.ring = (struct lpfc_sli_ring *)
> -			kzalloc(LPFC_SLI3_MAX_RING *
> +		phba->sli.ring = kzalloc(LPFC_SLI3_MAX_RING *
>  			sizeof(struct lpfc_sli_ring), GFP_KERNEL);

Using kcalloc would have been even nicer too

		phba->sli.ring = kcalloc(LPFC_SLI3_MAX_RING,
					 sizeof(struct lpfc_sli_ring),
					 GFP_KERNEL);


