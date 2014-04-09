Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbaDIAEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:04:31 -0400
Received: from smtprelay0076.hostedemail.com ([216.40.44.76]:56630 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756179AbaDIAE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:04:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:3872:3874:4321:5007:6119:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: seat97_7e3e5ac35f559
X-Filterd-Recvd-Size: 1656
Message-ID: <1397001866.14321.13.camel@joe-AO722>
Subject: Re: [PATCH] scsi: lpfc: lpfc_init: use kcalloc for allocating memory
From: Joe Perches <joe@perches.com>
To: Matei Oprea <eu@opreamatei.ro>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Date: Tue, 08 Apr 2014 17:04:26 -0700
In-Reply-To: <1396989746-29647-1-git-send-email-eu@opreamatei.ro>
References: <1396989746-29647-1-git-send-email-eu@opreamatei.ro>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 23:42 +0300, Matei Oprea wrote:
> It's easier to use kcalloc for allocating arrays. While at it
> also remove useless casting value.
[]
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
[]
> @@ -4742,12 +4742,14 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
[]
> -	if (!phba->sli.ring)
[]
> +	if (unlikely(!phba->sli.ring)) {

Why add the unlikely?

Glancing at the code it seems more like that this
should be likely than unlikely.

> +		phba->sli.ring = kcalloc(LPFC_SLI3_MAX_RING,
> +				sizeof(struct lpfc_sli_ring),
> +				GFP_KERNEL);

It'd be nicer looking if aligned better

		phba->sli.ring = kcalloc(LPFC_SLI3_MAX_RING,
					 sizeof(struct lpfc_sli_ring),
					 GFP_KERNEL);


