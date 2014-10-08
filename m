Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaJHQ5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:57:13 -0400
Received: from smtprelay0182.hostedemail.com ([216.40.44.182]:49037 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750875AbaJHQ5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:57:12 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3873:3874:4321:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13019:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: burn58_3e80651a1101b
X-Filterd-Recvd-Size: 1671
Message-ID: <1412787427.3438.35.camel@joe-AO725>
Subject: Re: [PATCH v2] staging: rtl8712: fix unnecessary elses after
 return/break in rtl8712_efuse.c
From: Joe Perches <joe@perches.com>
To: Serguey Parkhomovsky <xindigo@gmail.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 08 Oct 2014 09:57:07 -0700
In-Reply-To: <20141008034245.GA26853@fedora.localdomain>
References: <20141008034245.GA26853@fedora.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-07 at 20:42 -0700, Serguey Parkhomovsky wrote:
> This patch fixes two unnecessary else conditions that were found by checkpatch.pl.
[]
> diff --git a/drivers/staging/rtl8712/rtl8712_efuse.c b/drivers/staging/rtl8712/rtl8712_efuse.c
[]
> @@ -541,15 +540,16 @@ u8 r8712_efuse_map_write(struct _adapter *padapter, u16 addr, u16 cnts,
[]
> +
> +			if ((data[idx] != pktdata[i]) || (data[idx+1] !=
> +			     pktdata[i+1])) {

Just an fyi: (and I know you didn't introduce this)

Maximal fill to 80 columns is not always the most
readable for humans.

This sort of test is generally better where the
individual tests are written on separate lines like:

			if ((data[idx] != pktdata[i]) ||
			    (data[idx+1] != pktdata[i+1])) {



