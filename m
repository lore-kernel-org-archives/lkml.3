Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbaFZMFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:05:12 -0400
Received: from smtprelay0189.hostedemail.com ([216.40.44.189]:33172 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757743AbaFZMFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:05:08 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3867:3870:3871:3873:4321:5007:6119:7652:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: teeth68_2c599d537ce3b
X-Filterd-Recvd-Size: 1796
Message-ID: <1403784303.7977.38.camel@joe-AO725>
Subject: Re: [PATCH v2] scsi: bnx2i: bnx2i_iscsi.c:  Cleaning up variable is
 set more than once
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Eddie Wai <eddie.wai@broadcom.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Jun 2014 05:05:03 -0700
In-Reply-To: <1403783689-10457-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403783689-10457-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-26 at 13:54 +0200, Rickard Strandqvist wrote:
> A struct member variable is set to different values without having used in between.
[]
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
[]
> @@ -1643,12 +1643,11 @@ static void bnx2i_conn_get_stats(struct iscsi_cls_conn *cls_conn,
>  	stats->r2t_pdus = conn->r2t_pdus_cnt;
>  	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
>  	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
> -	stats->custom_length = 3;
>  	strcpy(stats->custom[2].desc, "eh_abort_cnt");
>  	stats->custom[2].value = conn->eh_abort_cnt;
>  	stats->digest_err = 0;
>  	stats->timeout_err = 0;
> -	stats->custom_length = 0;
> +	stats->custom_length = 3;

You are changing custom_length from 0 to 3.

Why is this correct?


