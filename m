Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbaFZMSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:18:01 -0400
Received: from smtprelay0164.hostedemail.com ([216.40.44.164]:34142 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932110AbaFZMR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:17:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:196:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1622:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2895:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:6671:7652:9025:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12555:12740:13007:13025:13069:13095:13161:13229:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Cus
X-HE-Tag: nose42_b2f2f4b00720
X-Filterd-Recvd-Size: 2232
Message-ID: <1403785075.7977.46.camel@joe-AO725>
Subject: Re: [PATCH v2] scsi: bnx2i: bnx2i_iscsi.c:  Cleaning up variable is
 set more than once
From: Joe Perches <joe@perches.com>
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Eddie Wai <eddie.wai@broadcom.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Jun 2014 05:17:55 -0700
In-Reply-To: <53AC0E2A.4040907@redhat.com>
References: <1403783689-10457-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <1403784303.7977.38.camel@joe-AO725> <53AC0E2A.4040907@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-26 at 14:12 +0200, Maurizio Lombardi wrote:
> 
> On 06/26/2014 02:05 PM, Joe Perches wrote:
> > On Thu, 2014-06-26 at 13:54 +0200, Rickard Strandqvist wrote:
> >> A struct member variable is set to different values without having used in between.
> > []
> >> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> > []
> >> @@ -1643,12 +1643,11 @@ static void bnx2i_conn_get_stats(struct iscsi_cls_conn *cls_conn,
> >>  	stats->r2t_pdus = conn->r2t_pdus_cnt;
> >>  	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
> >>  	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
> >> -	stats->custom_length = 3;
> >>  	strcpy(stats->custom[2].desc, "eh_abort_cnt");
> >>  	stats->custom[2].value = conn->eh_abort_cnt;
> >>  	stats->digest_err = 0;
> >>  	stats->timeout_err = 0;
> >> -	stats->custom_length = 0;
> >> +	stats->custom_length = 3;
> > 
> > You are changing custom_length from 0 to 3.
> > 
> > Why is this correct?
> 
> http://marc.info/?l=linux-scsi&m=140371670511706&w=2

Then the subject and commit message are wrong and need
to be updated to reflect your text.

This is a bugfix, not a cleanup.


