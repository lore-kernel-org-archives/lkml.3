Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbbA2BXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:23:45 -0500
Received: from smtprelay0247.hostedemail.com ([216.40.44.247]:49006 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753744AbbA2BWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:22:52 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3874:4321:5007:6119:6261:7903:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12438:12517:12519:12555:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bee65_52cc91c11f519
X-Filterd-Recvd-Size: 2270
Message-ID: <1422494566.13127.25.camel@perches.com>
Subject: Re: [PATCH] staging: lustre: fid: lproc_fid: Removed variables that
 is never used
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Eremin <dmitry.eremin@intel.com>,
        Eddie Kovsky <ewk@edkovsky.org>, Anil Belur <askb23@gmail.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Jan 2015 17:22:46 -0800
In-Reply-To: <1422485188-10994-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1422485188-10994-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-28 at 23:46 +0100, Rickard Strandqvist wrote:
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
[]
> diff --git a/drivers/staging/lustre/lustre/fid/lproc_fid.c b/drivers/staging/lustre/lustre/fid/lproc_fid.c
[]
> @@ -63,7 +63,6 @@ static int lprocfs_fid_write_common(const char __user *buffer, size_t count,
>  				    struct lu_seq_range *range)
>  {
>  	struct lu_seq_range tmp;
> -	int rc;
>  	char kernbuf[MAX_FID_RANGE_STRLEN];
>  
>  	LASSERT(range != NULL);
> @@ -82,7 +81,7 @@ static int lprocfs_fid_write_common(const char __user *buffer, size_t count,
>  	}
>  
>  	/* of the form "[0x0000000240000400 - 0x000000028000400]" */
> -	rc = sscanf(kernbuf, "[%llx - %llx]\n",
> +	sscanf(kernbuf, "[%llx - %llx]\n",
>  		    (unsigned long long *)&tmp.lsr_start,
>  		    (unsigned long long *)&tmp.lsr_end);
>  	if (!range_is_sane(&tmp) || range_is_zero(&tmp) ||

Better to make this test use rc rather than
ignore the return from sscanf

	if (rc != 2 || !range_is_sane(etc...))

