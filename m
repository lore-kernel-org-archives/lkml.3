Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaLSM0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 07:26:37 -0500
Received: from smtprelay0113.hostedemail.com ([216.40.44.113]:43804 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752063AbaLSM0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 07:26:35 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:4321:5007:6261:7974:10004:10400:10848:11026:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: magic70_906f3e69aeb5a
X-Filterd-Recvd-Size: 1677
Message-ID: <1418991991.25129.10.camel@perches.com>
Subject: Re: [PATCH 3/3] [SCSI] mpt2sas: Remove unnecessary use of a boolean
 variable
From: Joe Perches <joe@perches.com>
To: Quentin Lambert <lambert.quentin@gmail.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 19 Dec 2014 04:26:31 -0800
In-Reply-To: <20141219111345.GA19938@sloth>
References: <20141219111345.GA19938@sloth>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-19 at 12:13 +0100, Quentin Lambert wrote:
[]
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
[]
> @@ -1414,12 +1414,8 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
>  	struct msix_entry *entries, *a;
>  	int r;
>  	int i;
> -	u8 try_msix = 0;
>  
> -	if (msix_disable == -1 || msix_disable == 0)
> -		try_msix = 1;
> -
> -	if (!try_msix)
> +	if (msix_disable != -1 || msix_disable != 0)
>  		goto try_ioapic;

logic not the same.

Now needs && not ||


