Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaFDWBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:01:30 -0400
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:42792 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751818AbaFDWB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:01:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3873:3874:4321:5007:6248:7652:8660:8957:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13148:13230:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: deer06_29c9a23778551
X-Filterd-Recvd-Size: 1922
Message-ID: <1401919283.26329.7.camel@joe-AO725>
Subject: Re: [PATCH] scsi: mpt2sas: mpt2sas_base.c:  Cleaning up missing
 null-terminate after strncpy call
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 04 Jun 2014 15:01:23 -0700
In-Reply-To: <1401917775-3222-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1401917775-3222-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 23:36 +0200, Rickard Strandqvist wrote:
> Added a guaranteed null-terminate after call to strncpy.

Next time you submit a patch series like this
can you please use a cover letter?

That way I can reply to the cover letter with
a comment about the series instead of multiple
replies to various patches.

I think all of these should be using strlcpy not
strncpy.

> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
[]
> @@ -2097,7 +2097,8 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
>  	u32 bios_version;
>  
>  	bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
> -	strncpy(desc, ioc->manu_pg0.ChipName, 16);
> +	strncpy(desc, ioc->manu_pg0.ChipName, sizeof(desc));
> +	desc[sizeof(desc) - 1] = '\0';


