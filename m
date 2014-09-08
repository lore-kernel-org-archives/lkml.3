Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbaIHWiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:38:09 -0400
Received: from smtprelay0036.hostedemail.com ([216.40.44.36]:43237 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754947AbaIHWiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:38:08 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3874:3876:4321:5007:7652:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12517:12519:12740:13069:13161:13229:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: act37_808f7d0d6493a
X-Filterd-Recvd-Size: 1641
Message-ID: <1410215881.12560.21.camel@joe-AO725>
Subject: Re: [PATCH] drivers: staging: lustre: Fix "space prohibited after
 that open parenthesis '('" errors
From: Joe Perches <joe@perches.com>
To: Greg Donald <gdonald@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2014 15:38:01 -0700
In-Reply-To: <1410215528-22856-1-git-send-email-gdonald@gmail.com>
References: <1410215528-22856-1-git-send-email-gdonald@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-08 at 17:32 -0500, Greg Donald wrote:
> Fix checkpatch.pl "space prohibited after that open parenthesis '('" errors
[]
> diff --git a/drivers/staging/lustre/lustre/obdclass/obdo.c b/drivers/staging/lustre/lustre/obdclass/obdo.c
[]
> @@ -161,35 +161,35 @@ int obdo_cmp_md(struct obdo *dst, struct obdo *src, u32 compare)
>  {
>  	int res = 0;
>  
> -	if ( compare & OBD_MD_FLATIME )
> +	if (compare & OBD_MD_FLATIME)
>  		res = (res || (dst->o_atime != src->o_atime));

These would be nicer as

		res |= dst->o_atime != src->o_atime;

> -	if ( compare & OBD_MD_FLMTIME )
> +	if (compare & OBD_MD_FLMTIME)
>  		res = (res || (dst->o_mtime != src->o_mtime));

etc...


