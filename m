Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaEREMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 00:12:40 -0400
Received: from smtprelay0124.hostedemail.com ([216.40.44.124]:36408 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750711AbaEREMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 00:12:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:4321:5007:7652:10004:10400:10848:11658:11914:12043:12517:12519:12555:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rake15_33fb58bf02f1b
X-Filterd-Recvd-Size: 1480
Message-ID: <1400386345.14720.3.camel@joe-AO725>
Subject: Re: [PATCH 1/2] staging: slicoss: rewrite eeprom checksum code
From: Joe Perches <joe@perches.com>
To: David Matlack <matlackdavid@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, liodot@gmail.com, charrer@alacritech.com
Date: Sat, 17 May 2014 21:12:25 -0700
In-Reply-To: <1400385604-21086-2-git-send-email-matlackdavid@gmail.com>
References: <1400385604-21086-1-git-send-email-matlackdavid@gmail.com>
	 <1400385604-21086-2-git-send-email-matlackdavid@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-17 at 21:00 -0700, David Matlack wrote:
[]
> diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
[]
> +static inline u16 __reduce(u32 checksum)
> +{
> +	u16 lower_16 = checksum & 0xFFFF;
> +	u16 upper_16 = (checksum >> 16) & 0xFFFF;
> +
> +	checksum = lower_16 + upper_16;
> +
> +	if (checksum > 65535)
> +		checksum -= 65535;
> +
> +	return checksum;
> +}

The if seems unnecessary.

Perhaps declare a u16 return var or use

	return lower_16 + upper_16;


