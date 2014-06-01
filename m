Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbaFAJfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 05:35:44 -0400
Received: from smtprelay0186.hostedemail.com ([216.40.44.186]:49649 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752101AbaFAJfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 05:35:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3866:3867:3870:3871:3873:4321:4605:5007:7652:10004:10400:10848:11026:11232:11657:11658:11914:12043:12114:12438:12517:12519:12740:13069:13311:13357:13618,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: knife80_31872c8a5d751
X-Filterd-Recvd-Size: 1911
Message-ID: <1401615337.15125.7.camel@joe-AO725>
Subject: Re: [PATCH] staging/wlan-ng: use ether_addr_equal_unaligned
From: Joe Perches <joe@perches.com>
To: Denis Pithon <denis.pithon@gmail.com>
Cc: gregkh@linuxfoundation.org, vitaly.osipov@gmail.com, ztugcesirin@gmail.com,
        josh@joshtriplett.org, himangi774@gmail.com, superna9999@gmail.com,
        paul.gortmaker@windriver.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 01 Jun 2014 02:35:37 -0700
In-Reply-To: <1401607325-32733-1-git-send-email-denis.pithon@gmail.com>
References: <1401607325-32733-1-git-send-email-denis.pithon@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-06-01 at 09:22 +0200, Denis Pithon wrote:
> This patch get rid of all memcmp() on ethernet addresses in wlan-ng.
> Replaced with ether_addr_equal_unaligned().

ether_addr_equal_unaligned is only useful for
code symmetry when some uses are known to be
ether_addr_equal.

At least one of these conversions could/should be
ether_addr_equal.

Have you checked or did you just do a global
s/memcpy/ether_addr_equal_unaligned/ ?

> diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
[]
> @@ -1505,7 +1506,8 @@ static void prism2sta_inf_assocstatus(wlandevice_t *wlandev,
>  	 */
>  
>  	for (i = 0; i < hw->authlist.cnt; i++)
> -		if (memcmp(rec.sta_addr, hw->authlist.addr[i], ETH_ALEN) == 0)
> +		if (ether_addr_equal_unaligned(rec.sta_addr,
> +					       hw->authlist.addr[i]))

I looked at this one, both are __aligned(2)
I didn't look at any others.


