Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbaJHBDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 21:03:17 -0400
Received: from smtprelay0090.hostedemail.com ([216.40.44.90]:39452 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754820AbaJHBDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 21:03:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3874:3876:4321:5007:7652:7903:8660:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13019:13069:13148:13230:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: act00_1c356a5db3404
X-Filterd-Recvd-Size: 1557
Message-ID: <1412730192.3438.19.camel@joe-AO725>
Subject: Re: [PATCH] staging: rtl8712: fix unnecessary elses after
 return/break in rtl8712_efuse.c
From: Joe Perches <joe@perches.com>
To: Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 07 Oct 2014 18:03:12 -0700
In-Reply-To: <20141007234823.GA25549@fedora.localdomain>
References: <20141007234823.GA25549@fedora.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-07 at 16:48 -0700, Serguey Parkhomovsky wrote:
> This patch fixes two unnecessary else conditions that were found by checkpatch.pl.
[]
> diff --git a/drivers/staging/rtl8712/rtl8712_efuse.c b/drivers/staging/rtl8712/rtl8712_efuse.c
[]
> @@ -414,19 +414,19 @@ u8 r8712_efuse_pg_packet_write(struct _adapter *padapter, const u8 offset,
[]
> +		/* call rescue procedure */
> +		if (fix_header(padapter, efuse_data, efuse_addr) ==
> +		    false)
> +			return false; /* rescue fail */

Probably better as:

		if (!fix_header(padapter, efuse_data, efuse_addr))
			return false;	/* rescue fail */



